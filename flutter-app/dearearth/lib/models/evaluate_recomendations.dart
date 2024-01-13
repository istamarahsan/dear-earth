import 'package:flutter/material.dart';

class EvaluateRecomendations {
  String iconPath;
  String name;
  String description;

  EvaluateRecomendations({
    required this.iconPath,
    required this.name,
    required this.description,
  });

  static List<EvaluateRecomendations> getRecomendations() {
    List<EvaluateRecomendations> recomendations = [];

    recomendations.add(EvaluateRecomendations(
      name: 'Cut Red Meat',
      description: 'Aim to eat red meat only once or twice a week, replacing it with plant-based proteins like beans, lentils, and tofu.',
      iconPath: 'assets/recomendations/Reduce Driving.png',
    ));
    recomendations.add(EvaluateRecomendations(
      name: 'Stream at lower resolution',
      description: 'Choose 720p or even 480p resolution for watching videos instead of high-definition options.',
      iconPath: 'assets/recomendations/Stream at lower resolution.png',
    ));
    recomendations.add(EvaluateRecomendations(
      name: 'Shorten Showers',
      description: 'Aim for 5-minute showers instead of 10 or longer. This can save around 30 liters of water and the energy needed to heat it.',
      iconPath: 'assets/recomendations/Shorten Showers.png',
    ));
    recomendations.add(EvaluateRecomendations(
      name: 'Avoid Single-Use Items',
      description: 'Avoid single-use items: Bring your own reusable water bottle, grocery bags, and coffee mug to avoid generating unnecessary waste.',
      iconPath: 'assets/recomendations/Avoid Single-Use Items.png',
    ));
    
    recomendations.add(EvaluateRecomendations(
      name: 'Reduce Driving',
      description: 'Aim to eat red meat only once or twice a week, replacing it with plant-based proteins like beans, lentils, and tofu.',
      iconPath: 'assets/recomendations/Cut Red Meat.png',
    ));
    

    return recomendations;
  }
}
