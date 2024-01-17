// ignore_for_file: prefer_const_constructors
import 'package:dearearth/pages/home.dart';
import 'package:dearearth/pages/starter_1.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatelessWidget {
  final PocketBase pb;
  const LoginPage({super.key, required this.pb});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/starter/bg_main.png'), // Add the path to your background image
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/Logo.png',
                  height: 200,
                  width: 200,
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(0),
                  child: Column(
                    children: [
                      Text(
                        'Dear Earth',
                        style: TextStyle(
                          color: Color(0xff174A41),
                          fontWeight: FontWeight.w800, // Add the desired fontWeight
                          fontSize: 28.0, // Add the desired fontSize
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        'I can’t wait to start my green journey!',
                        style: TextStyle(
                          color: Color(0xff174A41),
                          fontWeight: FontWeight.w500, // Add the desired fontWeight
                          fontSize: 14.0,
                          fontStyle: FontStyle.italic // Add the desired fontSize
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 100),
                Container(
                  margin: EdgeInsets.only(left: 70, right: 70),
                  padding: EdgeInsets.all(10),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      backgroundColor: Color(0xff48672F),
                    ),
                    onPressed: () async {
                      final authData = await pb
                          .collection('users')
                          .authWithOAuth2('google', (url) async {
                        await launchUrl(url);
                      });
                      if (pb.authStore.isValid) {
                        print(authData);

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => StarterPageOne(pb: pb,)),
                        );
                      }
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
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 100),
              ]),
        ),
      ),
    );
  }
}
