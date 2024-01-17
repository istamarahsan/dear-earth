import 'package:flutter/material.dart';
import 'package:dearearth/models/progress_bar.dart';
import 'package:dearearth/models/profile_journey.dart';
import 'package:pocketbase/pocketbase.dart';

class ProfilePage extends StatelessWidget {
  final PocketBase pb;

  ProfilePage({required this.pb});

  List<ProfileJourneys> journeys = [];

  void __getInitialInfo() {
    journeys = ProfileJourneys.getJourneys();
  }

  @override
  Widget build(BuildContext context) {
    __getInitialInfo();
    final currentUser = pb.authStore.isValid;

    return Scaffold(
      body: ListView(
        children: [
          _profileSections(currentUser),
          SizedBox(
            height: 60,
          ),
          _topField(),
          SizedBox(
            height: 30,
          ),
          _journeysections(),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  Stack _profileSections(bool currentUser) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/profile/bg.png'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(top: 10, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [Image.asset('assets/profile/settings.png')],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 20),
                child: Column(children: [
                  Image.asset('assets/profile/dummy.png'),
                  SizedBox(height: 10),
                  Text(
                    '${currentUser}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                  Text('Email Address')
                ]),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
        Positioned(
          left: 50,
          right: 50,
          bottom:
              -30, // Adjust the value to move it down until half of its container
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Points',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(
                  '595 xp',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Image.asset('assets/icons/exp.png'),
                SizedBox(width: 10),
                Text(
                  'Actions',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Image.asset('assets/icons/leaf.png'),
                Text(
                  '10',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Column _journeysections() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 25, right: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Earthian Journey',
                    style: TextStyle(
                      color: Color(0xff174A41),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    'Reflect your love letters to the Earth',
                    style: TextStyle(
                        color: Color(0xff174A41),
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              Text(
                'View All',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.all(0),
          margin: EdgeInsets.only(left: 25, right: 25),
          height: 3 * 165,
          child: ListView.separated(
            itemBuilder: (context, index) {
              return Container(
                width: 300,
                margin: EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 253, 255, 237),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xff4F956F).withOpacity(0.3),
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment
                      .start, // Ensure content is aligned at the top
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.asset(
                        journeys[index].iconPath,
                        height: 150,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      // Use Expanded to ensure the Column takes available space
                      child: Padding(
                        padding:
                            const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Text(
                                      '${journeys[index].month}\n',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xff48672f),
                                      ),
                                    ),
                                    Positioned(
                                      top: 14, // Adjust this value as needed
                                      child: Text(
                                        journeys[index].date,
                                        style: TextStyle(
                                          fontSize:
                                              20, // Set a different font size for '07'
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xff48672f),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: 2,
                                  height: 38,
                                  decoration:
                                      BoxDecoration(color: Color(0xff48672f)),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Dear Earth, I will",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    Text(
                                      journeys[index].name,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              journeys[index].description,
                              style: TextStyle(
                                color: Color(0xff174A41),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
            itemCount: journeys.length,
            separatorBuilder: (context, index) => SizedBox(
              width: 0,
            ),
            scrollDirection: Axis.vertical,
          ),
        ),
      ],
    );
  }

  Widget _topField() {
    return Container(
        margin: EdgeInsets.only(left: 25, right: 25),
        padding: EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color(0xffF9FAEF),
          boxShadow: [
            BoxShadow(
              color: Color(0xff4F956F).withOpacity(0.3),
              spreadRadius: 0,
              blurRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Image.asset('assets/profile/ai.png'),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '1200 ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            FontWeight.w600, // Adjust the weight as needed
                        color: Colors.black, // Adjust the color as needed
                      ),
                    ),
                    TextSpan(
                      text: 'xp',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            FontWeight.w300, // Adjust the weight as needed
                        color: Colors.black, // Adjust the color as needed
                      ),
                    ),
                    TextSpan(
                      text: ' to receive a reward',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            FontWeight.w600, // Adjust the weight as needed
                        color: Colors.black, // Adjust the color as needed
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                padding: EdgeInsets.all(0),
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    // Progress bar
                    Container(
                      padding: EdgeInsets.all(0),
                      child: buildProgressBar(
                          50, BoxConstraints(minWidth: 220.0, maxWidth: 220.0)),
                    ),

                    // Background image
                    Container(
                      decoration: BoxDecoration(
                          color: Color(0xffF8F9FA),
                          border:
                              Border.all(color: Color(0xffDAE7C9), width: 3),
                          borderRadius: BorderRadius.circular(40)),
                      child: Image.asset(
                        'assets/icons/gift.png', // Replace with your image URL
                        width: 30,
                        height: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ]));
  }
}
