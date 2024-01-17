// ignore_for_file: prefer_const_constructors
import 'package:dearearth/pages/home.dart';
import 'package:dearearth/pages/starter_3.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:url_launcher/url_launcher.dart';

class StarterPageTwo extends StatelessWidget {
  final PocketBase pb;
  StarterPageTwo({super.key, required this.pb});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/starter/bg_2.png'), // Add the path to your background image
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.1), // Set the opacity level here
                BlendMode.srcATop,
              ),
            ),
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          style: TextStyle(
                            color: Color(0xff464742),
                            fontWeight: FontWeight.w700,
                            fontSize: 50.0,
                          ),
                          children: [
                            TextSpan(
                              text: 'The ',
                              style:
                                  TextStyle(fontSize: 50),
                            ),
                            TextSpan(
                              text: '✨magic✨',
                              style: TextStyle(
                                  fontSize: 40,
                                  fontStyle: FontStyle.italic),
                            ),
                            TextSpan(
                              text: '\nClimate',
                              style: TextStyle(
                                  fontSize: 50, color: Color(0xff48672F),height: 1.5),
                            ),
                            TextSpan(
                              text: '\nJournal',
                              style:
                                  TextStyle(fontSize: 50, color: Colors.black,height: 1.5),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        'Your personalized AI companion for climate literacy and action.',
                        style: TextStyle(
                          color: Color(
                                      0xff48672F),
                          fontWeight:
                              FontWeight.w400, // Add the desired fontWeight
                          fontSize: 18.0, // Add the desired fontSize
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Color(
                                      0xff48672F),
                            fontWeight: FontWeight.w400,
                            fontSize: 18.0,
                          ),
                          children: [
                            TextSpan(
                              text: 'Dear Earth provides climate learning & action made ',
                            ),
                            TextSpan(
                              text: 'relevant to your world',
                              style: TextStyle(
                                fontWeight: FontWeight
                                    .bold, // Add additional styles for "action made relevant to your world"
                              ),
                            ),
                            TextSpan(
                              text: '.',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 70,
                      ),
                      Container(
                          alignment: Alignment.center,
                          child: Image.asset('assets/starter/dot_2.png'))
                    ],
                  ),
                ),
                SizedBox(height: 10),
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
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StarterPageThree(
                                  pb: pb,
                                )),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Continue',
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
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
