import 'package:flutter/material.dart';

class DietModel {
  String name;
  String iconPath;
  String level;
  String duration;
  String calorie;
  Color boxColor;
  bool viewIsSelected;

  DietModel({
    required this.name,
    required this.iconPath,
    required this.level,
    required this.duration,
    required this.calorie,
    required this.boxColor,
    required this.viewIsSelected,
  });

  static List<DietModel> getDiets() {
    List<DietModel> diets = [];

    diets.add(DietModel(
      name: 'Honey Pancake',
      iconPath: 'assets/recomendations/honey-pancake.png',
      level: 'Easy',
      duration: '30mins',
      calorie: '180kCal',
      boxColor: const Color(0xff92A3FD),
      viewIsSelected: true,
    ));

    diets.add(DietModel(
      name: 'Canai Bread',
      iconPath: 'assets/recomendations/canai-bread.png',
      level: 'Medium',
      duration: '20mins',
      calorie: '230kCal',
      boxColor: const Color(0xffC58BF2),
      viewIsSelected: false,
    ));

    diets.add(DietModel(
      name: 'Salad Green',
      iconPath: 'assets/recomendations/salad-green.png',
      level: 'High',
      duration: '25mins',
      calorie: '150kCal',
      boxColor: const Color(0xff92A3FD),
      viewIsSelected: false,
    ));

    return diets;
  }
}
