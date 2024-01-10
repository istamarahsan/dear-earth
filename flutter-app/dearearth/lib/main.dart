import 'package:dearearth/pages/home.dart';
import 'package:dearearth/pages/login.dart';
import 'package:dearearth/pages/chat.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      home: ChatPage(),
      // home: HomePage(),
      // home: LoginPage(),
    );
  }
}