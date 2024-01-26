import 'package:dearearth/models/evaluate_recomendations.dart';
import 'package:flutter/material.dart';

class EvaluatePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<EvaluateRecomendations> recomendations = [];

  TextEditingController _searchController = TextEditingController();

  void __getInitialInfo() {
    recomendations = EvaluateRecomendations.getRecomendations();
  }

  @override
  Widget build(BuildContext context) {
    __getInitialInfo();
    return Scaffold(
      key: _scaffoldKey,
      appBar: _appBar(),
      body: ListView(
        children: [
          const SizedBox(
            height: 10,
          ),
          _topField(),
          const SizedBox(
            height: 30,
          ),
          _carbonSections(),
          const SizedBox(
            height: 30,
          ),
          _recomendationSections(),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  Column _recomendationSections() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                    'Recommended Actions',
                    style: TextStyle(
                      color: Color(0xff174A41),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          padding: EdgeInsets.all(0),
          margin: EdgeInsets.only( left: 25, right: 25),
          height: 470,
          child: ListView.separated(
            primary: false,
            itemBuilder: (context, index) {
              return Container(
                width: 300,
                margin: EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.asset(
                        recomendations[index].iconPath,
                        width: 50,
                        height: 50,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recomendations[index].name,
                            style: TextStyle(
                              color: Color(0xff174A41),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            recomendations[index].description,
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
            itemCount: recomendations.length,
            separatorBuilder: (context, index) => SizedBox(
              width: 0,
            ),
            scrollDirection: Axis.vertical,
          ),
        ),
      ],
    );
  }

  Column _carbonSections() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                  'Your Carbon Emissions',
                  style: TextStyle(
                      color: Color(0xff174A41),
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.start,
                ),
                Text(
                  'Last measured Jan 1, 2024, 13:45:01 ',
                  style: TextStyle(
                      color: Color(0xff174A41),
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 15,
      ),
      Container(
          padding: EdgeInsets.all(0),
          height: 240,
          child: Image.asset('assets/carbons/status.png')),
    ]);
  }

  Widget _topField() {
    return Container(
        margin: EdgeInsets.only(left: 25, right: 25),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Color(0xffF9FAEF)),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Image.asset('assets/profile/ai.png'),
          const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              'It’s time to reveal ✨',
              style: TextStyle(
                  color: Color(0xff174A41),
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
            Text(
              'Retake Emission Quiz',
              style: TextStyle(
                  color: Color(0xff174A41),
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            )
          ]),
          Image.asset('assets/icons/next_bordered.png')
        ]));
  }

  AppBar _appBar() {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Text(
          'Offset Measures 👣',
          style: TextStyle(
              color: Color(0xff174A41),
              fontSize: 22,
              fontWeight: FontWeight.w600),
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: false,
    );
  }
}
