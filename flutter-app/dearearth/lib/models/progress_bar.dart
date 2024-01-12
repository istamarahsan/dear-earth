import 'package:flutter/material.dart';

Widget buildProgressBar(double percentage, BoxConstraints constraints) {
  return Container(
    constraints: constraints, // Apply the constraints to the Container
    child: LinearProgressIndicator(
      value: percentage / 100,
      backgroundColor: Color(0xffDAE7C9),
      valueColor: AlwaysStoppedAnimation<Color>(Color(0xff48672F)),
    ),
  );
}

