import 'package:flutter/material.dart';

class ExploreShops {
  String name;
  String description;
  String iconPath;
  String price;
  String exp;

  ExploreShops({
    required this.name,
    required this.description,
    required this.iconPath,
    required this.price,
    required this.exp,
  });

  static List<ExploreShops> getShops() {
    List<ExploreShops> shops = [];

    shops.add(ExploreShops(
      name: 'iPhone Case',
      description: 'Pela Case',
      iconPath: 'assets/shops/Iphone_Case.png',
      price: 'Rp200.000',
      exp: '700',
    ));
    shops.add(ExploreShops(
      name: 'Sling Bag',
      description: 'Rice Love',
      iconPath: 'assets/shops/Sling Bag.png',
      price: 'Rp450.000',
      exp: '1900',
    ));
    shops.add(ExploreShops(
      name: 'Bamboo Straw Set',
      description: 'Zero Waste Indonesia',
      iconPath: 'assets/shops/Bamboo Straw Set.png',
      price: 'Rp11.000',
      exp: '50',
    ));
    shops.add(ExploreShops(
      name: 'Travel Backpack',
      description: 'Rice Love',
      iconPath: 'assets/shops/Travel Backpack.png',
      price: 'Rp680.000',
      exp: '2300',
    ));

    return shops;
  }
}
