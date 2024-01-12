import 'package:flutter/material.dart';

class ExploreChangeMakers {
  String iconPath;

  ExploreChangeMakers({
    required this.iconPath,
  });

  static List<ExploreChangeMakers> getMakers() {
    List<ExploreChangeMakers> makers = [];

    makers.add(ExploreChangeMakers(
      iconPath: 'assets/makers/1.png',
    ));

    makers.add(ExploreChangeMakers(
      iconPath: 'assets/makers/2.png',
    ));

    makers.add(ExploreChangeMakers(
      iconPath: 'assets/makers/3.png',
    ));
    

    return makers;
  }
}
