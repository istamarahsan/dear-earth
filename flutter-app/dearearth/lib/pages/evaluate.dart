import 'package:flutter/material.dart';

class EvaluatePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _appBar(),
      body: ListView(
        children: [
          SizedBox(
            height: 10,
          ),
          _searchField(),
          SizedBox(
            height: 30,
          ),
          // _headerSection(context),
          SizedBox(
            height: 30,
          ),
          // _topicsSections(),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  Widget _searchField() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        labelText: "Search",
        hintText: "Search for something...",
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onChanged: (value) {
        // Handle search input changes here
        // You can use the value to filter or search data
        print("Search input: $value");
      },
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
