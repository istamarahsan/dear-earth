// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/Logo.png',
                  height: 200,
                  width: 200,
                ),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(0),
                  child: Text(
                    'Dear Earth',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800, // Add the desired fontWeight
                      fontSize: 35.0, // Add the desired fontSize
                    ),
                  ),
                ),
                SizedBox(height: 50),
                Container(
                  margin: EdgeInsets.only(left: 70, right: 70),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Color(0xffE8E8E8),
                        width: 0.7,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () {
                      // Add button press logic here
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/Google.png',
                          height: 20,
                          width: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Continue with Google',
                          style: TextStyle(
                            color: Color(0xffA1A1A1),
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}