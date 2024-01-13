import 'package:flutter/material.dart';

class ProfileJourneys {
  String iconPath;
  String name;
  String description;
  String date;
  String month;

  ProfileJourneys({
    required this.iconPath,
    required this.name,
    required this.description,
    required this.date,
    required this.month,
  });

  static List<ProfileJourneys> getJourneys() {
    List<ProfileJourneys> journeys = [];

    journeys.add(ProfileJourneys(
      name: 'Unplug it Now!',
      description: 'Dear Earth, I often left my devices unplugged since I thought there aren’t any negative effects.',
      date: '07',
      month: 'JAN',
      iconPath: 'assets/journeys/Unplug it Now!.png',
    ));
    journeys.add(ProfileJourneys(
      name: 'Stop Scrolling',
      description: "Earth, I confess I've been a data-hogging scroll monster, adding to your digital burdens. But my love is real, and I'm changing, and so is my productivity.",
      date: '06',
      month: 'JAN',
      iconPath: 'assets/journeys/Stop Scrolling.png',
    ));
    // journeys.add(ProfileJourneys(
    //   name: 'Delete Emails',
    //   description: 'Remember all those emails I swore I would read someday? Yeah, not gonna happen. Hitting "delete" on that inbox clutter feels like cleaning out my attic –',
    //   date: '05',
    //   month: 'JAN',
    //   iconPath: 'assets/journeys/Delete Emails.png',
    // ));

    return journeys;
  }
}
