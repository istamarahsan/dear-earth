// ignore_for_file: prefer_const_constructors
import 'dart:convert';

import 'package:dearearth/journal/journal.dart';
import 'package:dearearth/pages/chat.dart';
import 'package:dearearth/models/popular_topics.dart';
import 'package:dearearth/models/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pocketbase/pocketbase.dart';

class HomePage extends StatefulWidget {
  final PocketBase pb;
  final ChatsData chatsData;
  final ChatbotService chatbotService;
  const HomePage(
      {super.key,
      required this.pb,
      required this.chatsData,
      required this.chatbotService});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<PopularTopics> topics = [];
  Chat? chat;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    topics = PopularTopics.getTopics();
    widget.chatsData
        .getChats()
        .then((value) => value.firstOrNull)
        .then((value) => setState(() {
              chat = value;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _appBar(),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          SizedBox(
            height: 10,
          ),
          _progressField(),
          SizedBox(
            height: 30,
          ),
          _headerSection(context),
          SizedBox(
            height: 30,
          ),
          _topicsSections(),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  Column _topicsSections() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: EdgeInsets.only(left: 25, right: 25),
        child: Text(
          'Topics for you',
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      SizedBox(
        height: 15,
      ),
      Container(
        padding: EdgeInsets.all(0),
        height: 240,
        child: ListView.separated(
          itemBuilder: (context, index) {
            return Container(
                width: 210,
                margin: () {
                  if (index == topics.length - 1) {
                    return EdgeInsets.only(left: 25, right: 25);
                  } else {
                    return EdgeInsets.only(left: 25);
                  }
                }(),
                decoration: BoxDecoration(
                    color: topics[index].boxColor,
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, top: 20, bottom: 20),
                        child: Column(
                          children: [
                            Text(
                              topics[index].name,
                              style: TextStyle(
                                  color: index % 2 == 0
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              topics[index].description,
                              style: TextStyle(
                                color: index % 2 == 0
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 30, right: 30),
                        child: Image.asset(topics[index].iconPath),
                      ),
                    ],
                  ),
                ));
          },
          itemCount: topics.length,
          separatorBuilder: (context, index) => SizedBox(
            width: 0,
          ),
          scrollDirection: Axis.horizontal,
        ),
      ),
    ]);
  }

  Container _headerSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 25, right: 25),
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Color(0xffF9FAEF),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'JAN 7, 2024',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Image.asset('assets/header/world.png')
            ],
          ),
          SizedBox(height: 15),
          Row(
            children: const [
              Flexible(
                child: Text(
                  'Write today’s love letter',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Row(
            children: const [
              Flexible(
                child: Text(
                  'Love the Earth, learn anything about the Earth. Express your commitment',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Row(
            children: [
              TextButton(
                onPressed: () async {
                  if (chat == null) {
                    final createdChat = await widget.chatsData.createChat(
                        starterName: 'debug_starter', now: DateTime.now());
                    setState(() {
                      chat = createdChat;
                    });
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatPage(
                              pb: widget.pb,
                              chatsData: widget.chatsData,
                              chatbotService: widget.chatbotService,
                              chat: chat!)),
                    );
                  }
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.only(left: 15, right: 15),
                  backgroundColor: Color(0xff48672F),
                ),
                child: Text(chat != null ? 'Continue' : 'Interact'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container _progressField() {
    return Container(
      padding: EdgeInsets.only(left: 25, right: 25),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.only(left: 12, right: 12, top: 10, bottom: 10),
            decoration: BoxDecoration(
                color: Color(0xffF8F9FA),
                borderRadius: BorderRadius.circular(40)),
            child: Row(
              children: [
                Row(
                  children: [
                    Image.asset(
                      "assets/icons/notif.png",
                      width: 20,
                      height: 20,
                    ),
                    Text("595 xp",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        )),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Row(
                  children: [
                    Image.asset(
                      "assets/icons/leaf.png",
                      width: 20,
                      height: 20,
                    ),
                    Text("10",
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600)),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Image.asset(
                    "assets/icons/next.png",
                    width: 20,
                    height: 20,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: 20,
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
                      50, BoxConstraints(minWidth: 150.0, maxWidth: 160.0)),
                ),

                // Background image
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xffF8F9FA),
                      border: Border.all(color: Color(0xffDAE7C9), width: 3),
                      borderRadius: BorderRadius.circular(40)),
                  child: Image.asset(
                    'assets/icons/gift.png', // Replace with your image URL
                    width: 30,
                    height: 30,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Text(
          'Magic Journal 🍃✨',
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/notif.png',
                    height: 30,
                    width: 30,
                  ),
                ],
              )),
        ),
      ],
    );
  }
}
