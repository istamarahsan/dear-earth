import 'package:dearearth/models/explore_change_maker.dart';
import 'package:dearearth/models/explore_impacts.dart';
import 'package:dearearth/models/explore_shop.dart';
import 'package:flutter/material.dart';

class ExplorePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<ExploreImpacts> impacts = [];
  List<ExploreShops> shops = [];
  List<ExploreChangeMakers> makers = [];

  TextEditingController _searchController = TextEditingController();

  void __getInitialInfo() {
    impacts = ExploreImpacts.getImpacts();
    shops = ExploreShops.getShops();
    makers = ExploreChangeMakers.getMakers();
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
          _searchField(),
          const SizedBox(
            height: 30,
          ),
          _impactSections(),
          const SizedBox(
            height: 30,
          ),
          _shopSections(),
          // _topicsSections(),
          const SizedBox(
            height: 30,
          ),
          _makerSections(),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  Column _makerSections() {
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
                  'Connect with Changemakers 📣',
                  style: TextStyle(
                      color: Color(0xff174A41),
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.start,
                ),
                Text(
                  'Join local environmental intitatives',
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
      const SizedBox(
        height: 15,
      ),
      Container(
        padding: EdgeInsets.all(0),
        height: 150,
        child: ListView.separated(
          itemBuilder: (context, index) {
            return Container(
              width: 300,
              margin: () {
                if (index == makers.length - 1) {
                  return EdgeInsets.only(left: 25, right: 25);
                } else {
                  return EdgeInsets.only(left: 25);
                }
              }(),
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(makers[index].iconPath),
                    fit: BoxFit.cover, // adjust as needed
                  ),
                  borderRadius: BorderRadius.circular(15)),
            );
          },
          itemCount: makers.length,
          separatorBuilder: (context, index) => SizedBox(
            width: 0,
          ),
          scrollDirection: Axis.horizontal,
        ),
      ),
    ]);
  }

  Column _shopSections() {
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
                  'Your Gateway to Impact 🤩',
                  style: TextStyle(
                      color: Color(0xff174A41),
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.start,
                ),
                Text(
                  'Unlocking environmental actions to join',
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
      const SizedBox(
        height: 15,
      ),
      Container(
        padding: EdgeInsets.all(0),
        height: 300,
        child: ListView.separated(
          itemBuilder: (context, index) {
            return Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                  color: Color(0xffD9DBD0),
                  borderRadius: BorderRadius.circular(30)),
              margin: () {
                if (index == shops.length - 1) {
                  return EdgeInsets.only(left: 25, right: 25);
                } else {
                  return EdgeInsets.only(left: 25);
                }
              }(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(shops[index].iconPath),
                          fit: BoxFit.cover, // adjust as needed
                        ),
                        borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                color: Color(0xff48672f),
                                borderRadius: BorderRadius.circular(40)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icons/exp_white.png',
                                  height: 20,
                                  width: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  shops[index].exp,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15,right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5,),
                        Text(
                          shops[index].name,
                          style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(height: 5,),
                        Text(
                          shops[index].description,
                          style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(height: 5,),
                        Text(
                          shops[index].price,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          itemCount: shops.length,
          separatorBuilder: (context, index) => SizedBox(
            width: 0,
          ),
          scrollDirection: Axis.horizontal,
        ),
      ),
    ]);
  }

  Column _impactSections() {
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
                  'Your Gateway to Impact 🤩',
                  style: TextStyle(
                      color: Color(0xff174A41),
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.start,
                ),
                Text(
                  'Unlocking environmental actions to join',
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
      const SizedBox(
        height: 15,
      ),
      Container(
        padding: EdgeInsets.all(0),
        height: 240,
        child: ListView.separated(
          itemBuilder: (context, index) {
            return Container(
              width: 200,
              margin: () {
                if (index == impacts.length - 1) {
                  return EdgeInsets.only(left: 25, right: 25);
                } else {
                  return EdgeInsets.only(left: 25);
                }
              }(),
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(impacts[index].iconPath),
                    fit: BoxFit.cover, // adjust as needed
                  ),
                  borderRadius: BorderRadius.circular(15)),
            );
          },
          itemCount: impacts.length,
          separatorBuilder: (context, index) => SizedBox(
            width: 0,
          ),
          scrollDirection: Axis.horizontal,
        ),
      ),
    ]);
  }

  Widget _searchField() {
    return Container(
      margin: EdgeInsets.only(left: 25,right: 25),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          labelText: "NGO, Advocacy group, eco-products, ...",
          hintText: "NGO, Advocacy group, eco-products, ...",
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        onChanged: (value) {
          // Handle search input changes here
          // You can use the value to filter or search data
          print("Search input: $value");
        },
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Text(
          'Co-Link Earthian 🌍🤝',
          style: TextStyle(
              color: Color(0xff174A41),
              fontSize: 22,
              fontWeight: FontWeight.w600),
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: false,
      actions: [
        GestureDetector(
          onTap: () {},
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(right: 20, top: 10, bottom: 10),
            padding: EdgeInsets.only(right: 15, top: 8, bottom: 8, left: 15),
            decoration: BoxDecoration(
                color: Color(0xffF8F9FA),
                borderRadius: BorderRadius.circular(40)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/exp.png',
                  height: 20,
                  width: 20,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  '595 xp',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
