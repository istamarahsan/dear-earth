import 'package:flutter/material.dart';

class StarterPageThree extends StatelessWidget {
  final void Function()? onFinished;
  StarterPageThree({super.key, this.onFinished});
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
                  'assets/starter/bg_3.png'), // Add the path to your background image
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
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    children: [
                      const Text(
                        'Unlocking Green Horizons',
                        style: TextStyle(
                          color: Color(0xff464742),
                          fontWeight:
                              FontWeight.w700, // Add the desired fontWeight
                          fontSize: 60.0, // Add the desired fontSize
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Explore actionable initiatives, connect with the community, and track your green journey.',
                        style: TextStyle(
                          color: Color(0xff48672F),
                          fontWeight:
                              FontWeight.w400, // Add the desired fontWeight
                          fontSize: 18.0, // Add the desired fontSize
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            color: Color(0xff48672F),
                            fontWeight: FontWeight.w400,
                            fontSize: 18.0,
                          ),
                          children: [
                            TextSpan(
                              text: 'It’s time to ',
                            ),
                            TextSpan(
                              text: 'thrive on your green journey',
                              style: TextStyle(
                                fontWeight: FontWeight
                                    .bold, // Add additional styles for "thrive"
                              ),
                            ),
                            TextSpan(
                              text: ' with Dear Earth.',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 90,
                      ),
                      Image.asset('assets/starter/dot_3.png')
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
                          'Count me in!',
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
