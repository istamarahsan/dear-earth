import 'dart:convert';
import 'dart:io';

import 'package:dearearth/journal/journal.dart';
import 'package:dearearth/pages/starter_1.dart';
import 'package:dearearth/pages/starter_2.dart';
import 'package:dearearth/pages/starter_3.dart';
import 'package:flutter/material.dart';
import 'package:dearearth/pages/home.dart';
import 'package:dearearth/pages/login.dart';
import 'package:dearearth/pages/explore.dart';
import 'package:dearearth/pages/evaluate.dart';
import 'package:dearearth/pages/profile.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:sqflite/sql.dart' as sql;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const pbUrl = String.fromEnvironment('PB_URL', defaultValue: "https://pb.dearearth.app");
  final pb = PocketBase(pbUrl);

  final currentDatabaseVersion = await getCurrentDatabaseVersion(rootBundle);
  final databasesPath = await resolveDatabasesPath();
  final database = await openDatabase(
      path: join(databasesPath, 'dearearth.db'),
      version: currentDatabaseVersion);

  final chatsData = ChatsData.sqlite(database);
  final chatbotService = ChatbotService(pb: pb);

  final starters = await pb.collection("chat_starters").getFullList();
  await starters.fold(database.batch(), (batch, starter) {
    batch.insert(
        'chat_starter',
        {
          'name': starter.getStringValue('name'),
          'content': starter.getStringValue('content')
        },
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return batch;
  }).commit(noResult: true);

  runApp(DearEarthApp(
      pb: pb, chatbotService: chatbotService, chatsData: chatsData));
}

Future<sqflite.Database> openDatabase(
    {required String path, required int version}) async {
  return await sqflite.openDatabase(
    path,
    onCreate: (db, version) async {
      for (var i = 1; i <= version; i++) {
        final statements = await loadMigrationUp(rootBundle, number: i);
        for (var statement in statements!) {
          await db.execute(statement);
        }
      }
    },
    onUpgrade: (db, oldVersion, newVersion) async {
      for (var i = oldVersion + 1; i <= newVersion; i++) {
        final statements = await loadMigrationUp(rootBundle, number: i);
        for (var statement in statements!) {
          await db.execute(statement);
        }
      }
    },
    version: version,
  );
}

Future<String> resolveDatabasesPath() {
  return (Platform.isAndroid
      ? sqflite.getDatabasesPath()
      : path_provider.getLibraryDirectory().then((dir) => dir.path));
}

const migrationsPath = "assets/database";

Future<int> getCurrentDatabaseVersion(AssetBundle assetBundle) async {
  final meta = await assetBundle.loadStructuredData(
      "$migrationsPath/meta.json", (raw) => Future.value(json.decode(raw)));
  return (meta as dynamic)["currentVersion"] as int;
}

Future<List<String>?> loadMigrationUp(AssetBundle assetBundle,
    {required int number}) async {
  try {
    final raw =
        await assetBundle.loadString("$migrationsPath/$number.up.sqlite.sql");
    return parseMigrationStatements(raw);
  } catch (e) {
    return null;
  }
}

Future<List<String>?> loadMigrationDown(AssetBundle assetBundle,
    {required int number}) async {
  try {
    final raw =
        await assetBundle.loadString("$migrationsPath/$number.down.sqlite.sql");
    return parseMigrationStatements(raw);
  } catch (e) {
    return null;
  }
}

List<String> parseMigrationStatements(String raw) {
  return raw
      .replaceAll('\n', '')
      .replaceAll(RegExp(r'\s(\s+)'), ' ')
      .trim()
      .split(";")
      .where((str) => str.isNotEmpty)
      .toList();
}

class DearEarthApp extends StatefulWidget {
  final PocketBase pb;
  final ChatbotService chatbotService;
  final ChatsData chatsData;
  const DearEarthApp(
      {Key? key,
      required this.pb,
      required this.chatbotService,
      required this.chatsData})
      : super(key: key);

  @override
  DearEarthAppState createState() => DearEarthAppState();
}

class DearEarthAppState extends State<DearEarthApp> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    widget.pb.authStore.onChange.listen((_) {
      setState(() {});
    });
    _pages = [
      HomePage(
          pb: widget.pb,
          chatbotService: widget.chatbotService,
          chatsData: widget.chatsData),
      EvaluatePage(),
      ExplorePage(),
      ProfilePage(pb: widget.pb)
    ];
  }

  bool isLoggedIn() {
    return widget.pb.authStore.isValid;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          useMaterial3: true,
          fontFamily: 'Roboto',
        ),
        debugShowCheckedModeBanner: false,
        home: !isLoggedIn()
            ? LoginPage(pb: widget.pb)
            : !(widget.pb.authStore.model as RecordModel)
                    .getBoolValue("hasDoneOnboarding")
                ? _StarterFlow(onFinished: () {
                    widget.pb.collection("users").update(
                        (widget.pb.authStore.model as RecordModel).id,
                        body: {"hasDoneOnboarding": true});
                  })
                : Scaffold(
                    body: _pages[_currentIndex],
                    bottomNavigationBar: NavigationBar(
                      backgroundColor: Colors.white,
                      onDestinationSelected: (int index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      indicatorColor: const Color(0xffDAE7C9),
                      selectedIndex: _currentIndex,
                      destinations: <Widget>[
                        NavigationDestination(
                          selectedIcon: Image.asset(
                            'assets/icons/journal.png',
                            height: 24,
                            width: 24,
                          ),
                          icon: Image.asset(
                            'assets/icons/journal.png',
                            height: 24,
                            width: 24,
                          ),
                          label: 'Journal',
                        ),
                        NavigationDestination(
                          icon: Image.asset(
                            'assets/icons/evaluate.png',
                            height: 24,
                            width: 24,
                          ),
                          label: 'Evaluate',
                        ),
                        NavigationDestination(
                          icon: Image.asset(
                            'assets/icons/compas.png',
                            height: 24,
                            width: 24,
                          ),
                          label: 'Explore',
                        ),
                        NavigationDestination(
                          icon: Image.asset(
                            'assets/icons/profile.png',
                            height: 24,
                            width: 24,
                          ),
                          label: 'Profile',
                        ),
                      ],
                    ),
                  ));
  }
}

class _StarterFlow extends StatefulWidget {
  final void Function()? onFinished;
  const _StarterFlow({this.onFinished});

  @override
  State<_StarterFlow> createState() => _StarterFlowState();
}

class _StarterFlowState extends State<_StarterFlow> {
  int _idx = 0;

  @override
  Widget build(BuildContext context) {
    return switch (_idx) {
      2 => StarterPageTwo(
          onFinished: () => setState(() {
            _idx++;
          }),
        ),
      3 => StarterPageThree(
          onFinished: () => setState(() {
            widget.onFinished?.call();
          }),
        ),
      _ => StarterPageOne(
          onFinished: () => setState(() {
            _idx++;
          }),
        )
    };
  }
}
