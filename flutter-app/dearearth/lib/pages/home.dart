import 'package:collection/collection.dart';
import 'package:dearearth/journal/journal.dart';
import 'package:dearearth/pages/chat.dart';
import 'package:dearearth/models/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pocketbase/pocketbase.dart';

extension _DateTimeExt on DateTime {
  bool onLocalSameDay(DateTime other) {
    final thisLocal = toLocal();
    final otherLocal = other.toLocal();

    return thisLocal.day == otherLocal.day &&
        thisLocal.month == otherLocal.month &&
        thisLocal.year == otherLocal.year;
  }
}

class HomePage extends StatefulWidget {
  final PocketBase pb;
  final EntriesData entriesData;
  final ChatbotService chatbotService;
  const HomePage(
      {super.key,
      required this.pb,
      required this.entriesData,
      required this.chatbotService});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Entry>? activeEntries;
  List<Topic>? availableTopics;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    widget.entriesData
        .getEntries()
        .then((entries) =>
            entries.where((it) => it.status == EntryStatus.active).toList())
        .then((entries) async {
      final allTopics = await widget.entriesData.getTopics();
      final availableTopics = allTopics
          .where((topic) =>
              entries.none((entry) => entry.topic.title == topic.title))
          .toList();
      setState(() {
        activeEntries = entries;
        this.availableTopics = availableTopics;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _appBar(),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          const SizedBox(
            height: 10,
          ),
          _progressField(),
          const SizedBox(
            height: 30,
          ),
          _headerSection(context),
          const SizedBox(
            height: 30,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (activeEntries?.isNotEmpty ?? false)
                  ? const Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 25, right: 25),
                          child: Text(
                            'Ongoing Topics',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    )
                  : Container(),
              Column(
                children: activeEntries
                        ?.mapIndexed((i, entry) => TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                        pb: widget.pb,
                                        entriesData: widget.entriesData,
                                        chatbotService: widget.chatbotService,
                                        entry: activeEntries![i])),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              margin:
                                  const EdgeInsets.only(left: 15, right: 15),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 253, 255, 237),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xff4F956F)
                                        .withOpacity(0.3),
                                    spreadRadius: 0,
                                    blurRadius: 2,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 20),
                                  SizedBox(
                                      width: 200,
                                      child: Text(entry.topic.lead)),
                                  const SizedBox(width: 30),
                                  Image.asset("assets/icons/next_bordered.png")
                                ],
                              ),
                            )))
                        .toList() ??
                    [],
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          _topicsSections(),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  Column _topicsSections() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      availableTopics?.isEmpty == true
          ? Container()
          : const Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 25, right: 25),
                  child: Text(
                    'Topics for you',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
      const SizedBox(
        height: 15,
      ),
      Container(
        padding: const EdgeInsets.all(0),
        height: 240,
        child: availableTopics == null
            ? const SizedBox.shrink()
            : ListView.separated(
                itemBuilder: (context, index) {
                  return Container(
                      width: 210,
                      margin: index == availableTopics!.length - 1
                          ? const EdgeInsets.only(left: 25, right: 25)
                          : const EdgeInsets.only(left: 25),
                      decoration: BoxDecoration(
                          color: const Color(0xff385323),
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20, bottom: 20),
                              child: Column(
                                children: [
                                  Text(
                                    availableTopics![index].title,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    availableTopics![index].lead,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 30, right: 30),
                              child: TextButton(
                                onPressed: () async {
                                  final createdChat = await widget.entriesData
                                      .createEntry(
                                          topicTitle:
                                              availableTopics![index].title,
                                          now: DateTime.now());
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatPage(
                                            pb: widget.pb,
                                            entriesData: widget.entriesData,
                                            chatbotService:
                                                widget.chatbotService,
                                            entry: createdChat)),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15),
                                  backgroundColor: const Color(0xffF9FAEF),
                                ),
                                child: const Text('Interact'),
                              ),
                            ),
                          ],
                        ),
                      ));
                },
                itemCount: availableTopics!.length,
                separatorBuilder: (context, index) => const SizedBox(
                  width: 0,
                ),
                scrollDirection: Axis.horizontal,
              ),
      ),
    ]);
  }

  Container _headerSection(BuildContext context) {
    final now = DateTime.now();
    return activeEntries == null ||
            activeEntries!.any((it) => it.started.onLocalSameDay(now))
        ? Container()
        : Container(
            margin: const EdgeInsets.only(left: 25, right: 25),
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: const Color(0xffF9FAEF),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat.yMd(Intl.systemLocale).format(DateTime.now()),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Image.asset('assets/header/world.png')
                  ],
                ),
                const SizedBox(height: 15),
                const Row(
                  children: [
                    Flexible(
                      child: Text(
                        'Write today’s love letter',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 24),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                const Row(
                  children: [
                    Flexible(
                      child: Text(
                        'Love the Earth, learn anything about the Earth. Express your commitment',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    TextButton(
                      onPressed: () async {
                        if (availableTopics!.isEmpty) {
                          return;
                        }
                        final createdEntry = await widget.entriesData
                            .createEntry(
                                topicTitle: availableTopics!.first.title,
                                now: DateTime.now());
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatPage(
                                  pb: widget.pb,
                                  entriesData: widget.entriesData,
                                  chatbotService: widget.chatbotService,
                                  entry: createdEntry)),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        backgroundColor: const Color(0xff48672F),
                      ),
                      child: const Text('Interact'),
                    ),
                  ],
                ),
              ],
            ),
          );
  }

  Container _progressField() {
    return Container(
      padding: const EdgeInsets.only(left: 25, right: 25),
      child: Row(
        children: [
          Container(
            padding:
                const EdgeInsets.only(left: 12, right: 12, top: 10, bottom: 10),
            decoration: BoxDecoration(
                color: const Color(0xffF8F9FA),
                borderRadius: BorderRadius.circular(40)),
            child: Row(
              children: [
                Row(
                  children: [
                    Image.asset(
                      "assets/icons/exp.png",
                      width: 20,
                      height: 20,
                    ),
                    Text(
                        "${(widget.pb.authStore.model as RecordModel).getIntValue('experiencePoints')} xp",
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        )),
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                Row(
                  children: [
                    Image.asset(
                      "assets/icons/leaf.png",
                      width: 20,
                      height: 20,
                    ),
                    const Text("0",
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Image.asset(
                    "assets/icons/next.png",
                    width: 20,
                    height: 20,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Container(
            padding: const EdgeInsets.all(0),
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                // Progress bar
                Container(
                  padding: const EdgeInsets.all(0),
                  child: buildProgressBar(0,
                      const BoxConstraints(minWidth: 150.0, maxWidth: 160.0)),
                ),

                // Background image
                Container(
                  decoration: BoxDecoration(
                      color: const Color(0xffF8F9FA),
                      border:
                          Border.all(color: const Color(0xffDAE7C9), width: 3),
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
        title: const Padding(
          padding: EdgeInsets.only(left: 8),
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
        centerTitle: false);
  }
}
