import 'package:flutter/material.dart';

class StarterPageOne extends StatelessWidget {
  final void Function()? onFinished;
  StarterPageOne({super.key, this.onFinished});
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
              image: const AssetImage(
                  'assets/starter/bg_1.png'), // Add the path to your background image
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.4), // Set the opacity level here
                BlendMode.srcATop,
              ),
            ),
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    children: [
                      const Text(
                        'Seeds of Change',
                        style: TextStyle(
                          color: Color(0xff464742),
                          fontWeight:
                              FontWeight.w700, // Add the desired fontWeight
                          fontSize: 60.0, // Add the desired fontSize
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            color: Color(
                                      0xff48672F),
                            fontWeight: FontWeight.w400,
                            fontSize: 18.0,
                          ),
                          children: [
                            TextSpan(
                              text: 'You, yes,',
                            ),
                            TextSpan(
                              text: ' YOU ',
                              style: TextStyle(
                                  fontWeight: FontWeight
                                      .bold, // Add additional styles for "YOU"
                                  fontSize: 20.0,
                                  color: Color(
                                      0xff48672F) // Add additional fontSize for "YOU"
                                  ),
                            ),
                            TextSpan(
                              text:
                                  'are a seed of change for a greener future 🤩🌱.',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            color: Color(
                                      0xff48672F),
                            fontWeight: FontWeight.w400,
                            fontSize: 18.0,
                          ),
                          children: [
                            TextSpan(
                              text: 'Dear Earth guides your journey from ',
                            ),
                            TextSpan(
                              text: 'awareness',
                              style: TextStyle(
                                fontWeight: FontWeight
                                    .bold, // Add additional styles for "awareness"
                              ),
                            ),
                            TextSpan(
                              text: ' to ',
                            ),
                            TextSpan(
                              text: 'action',
                              style: TextStyle(
                                fontWeight: FontWeight
                                    .bold, // Add additional styles for "action"
                              ),
                            ),
                            TextSpan(
                              text: '.',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 90,
                      ),
                      Image.asset('assets/starter/dot_1.png')
                    ],
                  ),
                ),
                const SizedBox(height: 10),
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
                    onPressed: onFinished,
                    child: const Row(
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
