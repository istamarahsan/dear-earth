import 'package:flutter/material.dart';

class ExploreImpacts {
  String iconPath;

  ExploreImpacts({
    required this.iconPath,
  });

  static List<ExploreImpacts> getImpacts() {
    List<ExploreImpacts> impacts = [];

    impacts.add(ExploreImpacts(
      iconPath: 'assets/impacts/1.png',
    ));

    impacts.add(ExploreImpacts(
      iconPath: 'assets/impacts/2.png',
    ));

    impacts.add(ExploreImpacts(
      iconPath: 'assets/impacts/3.png',
    ));
    
    impacts.add(ExploreImpacts(
      iconPath: 'assets/impacts/4.png',
    ));
    

    return impacts;
  }
}
