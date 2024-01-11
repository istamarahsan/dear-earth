// import 'package:dear_earth/pages/home.dart';
import 'package:dearearth/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

void main() {
  final pb = PocketBase('http://pbdev.dearearth.app');
  final app = MyApp(pb: pb);
  runApp(app);
}

class MyApp extends StatelessWidget {
  final PocketBase pb;
  const MyApp({super.key, required this.pb});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Noto Sans'
      ),
      debugShowCheckedModeBanner: false,
      home: LoginPage(pb: pb),
    );
  }
}