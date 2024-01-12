import 'package:flutter/material.dart';

Widget buildProgressBar(double percentage) {
  return SizedBox(
    width: 180, // Adjust the width as needed
    child: LinearProgressIndicator(
      value: percentage / 100,
      backgroundColor: Color(0xffDAE7C9),
      valueColor: AlwaysStoppedAnimation<Color>(Color(0xff48672F)),
    ),
  );
}
