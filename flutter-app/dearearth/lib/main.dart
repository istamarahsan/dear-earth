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
    _pages = [
      HomePage(),
      // nanti yang dipakai ini
      // if (isLoggedIn()) HomePage() else LoginPage(pb: widget.pb),
      EvaluatePage(),
      ExplorePage(),
      ProfilePage(pb: widget.pb), // Access widget.pb here
    ];
  }

  bool isLoggedIn() {
    return widget.pb.authStore
        .isValid; // Replace with the actual method to check authentication
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
        // nanti ini yang dipakai
        // home: isLoggedIn()
        //     ? Scaffold(
        //         body: _pages[_currentIndex],
        //         bottomNavigationBar: NavigationBar(
        //           onDestinationSelected: (int index) {
        //             setState(() {
        //               _currentIndex = index;
        //             });
        //           },
        //           indicatorColor: Colors.amber,
        //           selectedIndex: _currentIndex,
        //           destinations: const <Widget>[
        //             NavigationDestination(
        //               selectedIcon: Icon(Icons.book),
        //               icon: Icon(Icons.book),
        //               label: 'Journal',
        //             ),
        //             NavigationDestination(
        //               icon: Badge(child: Icon(Icons.calculate)),
        //               label: 'Evaluate',
        //             ),
        //             NavigationDestination(
        //               icon: Badge(
        //                 label: Text('2'),
        //                 child: Icon(Icons.compass_calibration),
        //               ),
        //               label: 'Explore',
        //             ),
        //             NavigationDestination(
        //               icon: Badge(
        //                 label: Text('3'),
        //                 child: Icon(Icons.portable_wifi_off_outlined),
        //               ),
        //               label: 'Profile',
        //             ),
        //           ],
        //         ),
        //       )
        //     : LoginPage(pb: widget.pb),
        home: Scaffold(
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
                icon: Badge(
                  child: Image.asset(
                    'assets/icons/evaluate.png',
                    height: 24,
                    width: 24,
                  ),
                ),
                label: 'Evaluate',
              ),
              NavigationDestination(
                icon: Badge(
                  label: Text('2'),
                  child: Image.asset(
                    'assets/icons/compas.png',
                    height: 24,
                    width: 24,
                  ),
                ),
                label: 'Explore',
              ),
              NavigationDestination(
                icon: Badge(
                  label: Text('3'),
                  child: Image.asset(
                    'assets/icons/profile.png',
                    height: 24,
                    width: 24,
                  ),
                ),
                label: 'Profile',
              ),
            ],
          ),
        ));
  }
}
