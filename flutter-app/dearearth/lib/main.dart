import 'package:flutter/material.dart';
import 'package:dearearth/pages/home.dart';
import 'package:dearearth/pages/login.dart';
import 'package:dearearth/pages/explore.dart';
import 'package:dearearth/pages/evaluate.dart';
import 'package:dearearth/pages/profile.dart';
import 'package:dearearth/models/menu_bar.dart';
import 'package:pocketbase/pocketbase.dart';

void main() {
  final pb = PocketBase('http://pbdev.dearearth.app');
  runApp(MyApp(pb: pb));
}

class MyApp extends StatefulWidget {
  final PocketBase pb;
  const MyApp({Key? key, required this.pb}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    widget.pb.authStore.onChange.listen((_) {
      setState(() {});
    });
    _pages = [
      HomePage(pb: widget.pb),
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
          fontFamily: 'Noto Sans',
        ),
        debugShowCheckedModeBanner: false,
        home: !isLoggedIn()
            ? LoginPage(pb: widget.pb)
            : Scaffold(
                body: _pages[_currentIndex],
                bottomNavigationBar: NavigationBar(
                  backgroundColor: Colors.white,
                  onDestinationSelected: (int index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  indicatorColor: Color(0xffDAE7C9),
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
