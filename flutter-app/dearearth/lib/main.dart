import 'package:flutter/material.dart';
import 'package:dearearth/pages/home.dart';
import 'package:dearearth/pages/login.dart';
import 'package:dearearth/pages/chat.dart';
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

  late final List<Widget> _pages; // Declare _pages as a late final variable

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(),
      ChatPage(),
      LoginPage(pb: widget.pb), // Access widget.pb here
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
        fontFamily: 'Noto Sans',
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: HomePage(),
        // body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.login),
              label: 'Login',
            ),
          ],
        ),
      ),
    );
  }
}
