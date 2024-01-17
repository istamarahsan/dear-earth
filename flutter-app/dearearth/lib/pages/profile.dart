import 'package:flutter/material.dart';
import 'package:dearearth/models/progress_bar.dart';
import 'package:dearearth/models/profile_journey.dart';
import 'package:pocketbase/pocketbase.dart';

class ProfilePage extends StatelessWidget {
  final PocketBase pb;

  ProfilePage({super.key, required this.pb});

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
          const SizedBox(
            height: 60,
          ),
          _topField(),
          const SizedBox(
            height: 30,
          ),
          _journeysections(),
          const SizedBox(
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
            image: const DecorationImage(
              image: AssetImage('assets/profile/bg.png'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
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
                  CircleAvatar(
                    radius: 48,
                    backgroundImage: NetworkImage(
                        (pb.authStore.model as RecordModel)
                            .getStringValue("avatarUrl")),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    (pb.authStore.model as RecordModel).getStringValue("name"),
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                  Text((pb.authStore.model as RecordModel)
                      .getStringValue("email")),
                  TextButton(
                      onPressed: () {
                        pb.authStore.clear();
                      },
                      child: const Text("Sign Out"))
                ]),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
        Positioned(
          left: 50,
          right: 50,
          bottom:
              -30, // Adjust the value to move it down until half of its container
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Points',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const Text(
                  '0 xp',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Image.asset('assets/icons/exp.png'),
                const SizedBox(width: 10),
                const Text(
                  'Actions',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Image.asset('assets/icons/leaf.png'),
                const Text(
                  '0',
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
        const SizedBox(
          height: 10,
        ),
        Container(
          padding: const EdgeInsets.all(0),
          margin: const EdgeInsets.only(left: 25, right: 25),
          height: 3 * 165,
          child: ListView.separated(
            itemBuilder: (context, index) {
              return Container(
                width: 300,
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 253, 255, 237),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff4F956F).withOpacity(0.3),
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: const Offset(0, 2),
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
                    const SizedBox(
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
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xff48672f),
                                      ),
                                    ),
                                    Positioned(
                                      top: 14, // Adjust this value as needed
                                      child: Text(
                                        journeys[index].date,
                                        style: const TextStyle(
                                          fontSize:
                                              20, // Set a different font size for '07'
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xff48672f),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: 2,
                                  height: 38,
                                  decoration: const BoxDecoration(
                                      color: Color(0xff48672f)),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Dear Earth, I will",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    Text(
                                      journeys[index].name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              journeys[index].description,
                              style: const TextStyle(
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
            separatorBuilder: (context, index) => const SizedBox(
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
        margin: const EdgeInsets.only(left: 25, right: 25),
        padding:
            const EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color(0xffF9FAEF),
          boxShadow: [
            BoxShadow(
              color: const Color(0xff4F956F).withOpacity(0.3),
              spreadRadius: 0,
              blurRadius: 2,
              offset: const Offset(0, 2),
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
                text: const TextSpan(
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
              const SizedBox(
                height: 5,
              ),
              Container(
                padding: const EdgeInsets.all(0),
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    // Progress bar
                    Container(
                      padding: const EdgeInsets.all(0),
                      child: buildProgressBar(
                          50,
                          const BoxConstraints(
                              minWidth: 220.0, maxWidth: 220.0)),
                    ),

                    // Background image
                    Container(
                      decoration: BoxDecoration(
                          color: const Color(0xffF8F9FA),
                          border: Border.all(
                              color: const Color(0xffDAE7C9), width: 3),
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
