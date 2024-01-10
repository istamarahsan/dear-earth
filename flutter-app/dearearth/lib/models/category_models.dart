import 'package:flutter/material.dart';

class CategoryModel{
  String name;
  String iconPath;
  Color boxColor;

  CategoryModel({
    required this.name,
    required this.iconPath,
    required this.boxColor,
  });

  static List<CategoryModel> getCategories() {
    List<CategoryModel> categories = [];

      // categories.add(
      //   CategoryModel(
      //     name: 'Salad',
      //     iconPath: 'assets/categories/salad.png',
      //     boxColor: const Color(0xff92A3FD),
      //   )
      // );
      // categories.add(
      //   CategoryModel(
      //     name: 'Cake',
      //     iconPath: 'assets/categories/pancakes.png',
      //     boxColor: const Color(0xffC58BF2),
      //   )
      // );
      // categories.add(
      //   CategoryModel(
      //     name: 'Pie',
      //     iconPath: 'assets/categories/pie.png',
      //     boxColor: const Color(0xff92A3FD),
      //   )
      // );
      // categories.add(
      //   CategoryModel(
      //     name: 'Chips',
      //     iconPath: 'assets/categories/chips.png',
      //     boxColor: const Color(0xffC58BF2),
      //   )
      // );

      return categories;
  }
}