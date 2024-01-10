import 'package:flutter/material.dart';

class PopularTopics {
  String name;
  String description;
  String iconPath;
  Color boxColor;
  bool boxIsSelected;

  PopularTopics({
    required this.name,
    required this.description,
    required this.iconPath,
    required this.boxColor,
    required this.boxIsSelected,
  });

  static List<PopularTopics> getTopics() {
    List<PopularTopics> topics = [];

    topics.add(PopularTopics(
      name: 'Stop Scrolling!',
      description: 'scrolling aimlessly leaves digital carbon footprints 😱',
      iconPath: 'assets/topics/stop_scrolling.png',
      boxColor: const Color(0xff385323),
      boxIsSelected: true,
    ));

    topics.add(PopularTopics(
      name: 'Stop Scrolling!',
      description: 'scrolling aimlessly leaves digital carbon footprints 😱',
      iconPath: 'assets/topics/stop_scrolling.png',
      boxColor: const Color(0xffDAE7C9),
      boxIsSelected: true,
    ));

    topics.add(PopularTopics(
      name: 'Stop Scrolling!',
      description: 'scrolling aimlessly leaves digital carbon footprints 😱',
      iconPath: 'assets/topics/stop_scrolling.png',
      boxColor: const Color(0xff385323),
      boxIsSelected: true,
    ));
    

    return topics;
  }
}
