part of journal;

enum EntryStatus { active, accepted }

extension EntryStatusExt on EntryStatus {
  static EntryStatus? parse(String str) {
    return EntryStatus.values.firstWhereOrNull((e) => e.name == str);
  }
}

class Entry {
  final int id;
  final Topic topic;
  final EntryStatus status;
  final DateTime started;
  final int awardedExperiencePoints;

  const Entry({
    required this.id,
    required this.topic,
    this.status = EntryStatus.active,
    required this.started,
    required this.awardedExperiencePoints,
  });
}