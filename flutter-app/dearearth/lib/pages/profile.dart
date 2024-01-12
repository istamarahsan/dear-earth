import 'package:flutter/material.dart';
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

    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/profile/bg.png'),
                fit: BoxFit.cover, // adjust as needed
              ),
              borderRadius: BorderRadius.circular(15)),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [Image.asset('assets/profile/settings.png')],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50, bottom: 20),
                child: Column(children: [
                  Image.asset(
                    'assets/icons/profile.png',
                    width: 100,
                    height: 100,
                  ),
                  Text('${currentUser}'),
                  Text('Email Address')
                ]),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 30,
        ),
        _journeysections(),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }

  Column _journeysections() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
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
                        fontWeight: FontWeight.w600),
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
        Container(
          padding: EdgeInsets.all(0),
          height: 300,
          child: ListView.separated(
            itemBuilder: (context, index) {
              return Container(
                width: 300,
                margin: EdgeInsets.only(bottom: 15, left: 25, right: 25),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 253, 255, 237),
                  borderRadius: BorderRadius.circular(20),
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
                        height: 100,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      // Use Expanded to ensure the Column takes available space
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            journeys[index].name,
                            style: TextStyle(
                              color: Color(0xff174A41),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            journeys[index].description,
                            style: TextStyle(
                              color: Color(0xff174A41),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
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
}
