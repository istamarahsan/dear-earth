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
          decoration: const BoxDecoration(
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
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(0),
                  child: const Column(
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
                const SizedBox(height: 100),
                Container(
                  margin: const EdgeInsets.only(left: 70, right: 70),
                  padding: const EdgeInsets.all(10),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      backgroundColor: const Color(0xff48672F),
                    ),
                    onPressed: () async {
                      await pb.collection('users').authWithOAuth2('google',
                          (url) async {
                        await launchUrl(url);
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/Google.png',
                          height: 20,
                          width: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
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
                const SizedBox(height: 100),
              ]),
        ),
      ),
    );
  }
}
