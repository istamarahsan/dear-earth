part of journal;

enum ChatRole { model, user }

extension ChatRoleExt on ChatRole {
  static ChatRole? parse(String str) {
    return ChatRole.values.firstWhereOrNull((e) => e.name == str);
  }
}

class ChatMessage {
  final ChatRole role;
  final String content;
  final DateTime timestamp;

  const ChatMessage({
    required this.role,
    required this.content,
    required this.timestamp
  });
}
