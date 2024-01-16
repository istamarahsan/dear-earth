part of journal;

enum ChatStatus { active, accepted }

extension ChatStatusExt on ChatStatus {
  static ChatStatus? parse(String str) {
    return ChatStatus.values.firstWhereOrNull((e) => e.name == str);
  }
}

class Chat {
  final int id;
  final ChatStarter starter;
  final ChatStatus status;
  final DateTime started;

  const Chat({
    required this.id,
    required this.starter,
    this.status = ChatStatus.active,
    required this.started
  });
}