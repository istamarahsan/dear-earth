part of journal;

abstract class ChatsData {
  Future<List<Chat>> getChats({ChatStatus? status});
  Future<List<ChatMessage>> getChatMessages({required int chatId});
  Future<Chat> createChat(
      {required String starterName, required DateTime now, ChatStatus status});
  Future<ChatMessage> addMessageToChat(
      {required int chatId,
      required String content,
      required ChatRole role,
      required DateTime timestamp});
  static ChatsData sqlite(sqflite.Database db) {
    return _ChatsDataSql(db: db);
  }
}

class _ChatsDataSql implements ChatsData {
  final sqflite.Database db;

  _ChatsDataSql({required this.db});

  @override
  Future<List<Chat>> getChats({ChatStatus? status}) async {
    final dbResult = await db.rawQuery("""
      SELECT 
        chat.id AS id, 
        chat.status AS status, 
        chat.time_started AS time_started, 
        starter.name AS starter_name, 
        starter.content AS starter_content
      FROM chat 
      LEFT JOIN chat_starter AS starter ON starter.name = chat.starter_name
      ${status == null ? "" : "chat.status = ${status.name}"}
      """);
    return dbResult
        .map((row) => Chat(
            id: row['id'] as int,
            starter: ChatStarter(
                name: row['starter_name'] as String,
                content: row['starter_content'] as String),
            status: ChatStatusExt.parse(row['status'] as String) ??
                ChatStatus.active,
            started: DateTime.parse(row['time_started'] as String)))
        .toList();
  }

  @override
  Future<List<ChatMessage>> getChatMessages({required int chatId}) async {
    final dbResult = await db.rawQuery(
        "SELECT role, content, timestamp FROM chat_message WHERE chat_id = ? ORDER BY timestamp",
        [chatId]);
    return dbResult
        .map((row) => ChatMessage(
            role: ChatRoleExt.parse(row['role'] as String)!,
            content: row['content'] as String,
            timestamp: DateTime.parse(row['timestamp'] as String)))
        .toList();
  }

  @override
  Future<ChatMessage> addMessageToChat(
      {required int chatId,
      required ChatRole role,
      required String content,
      required DateTime timestamp}) async {
    final insertedId = await db.rawInsert(
        "INSERT INTO chat_message(chat_id, role, content, timestamp) VALUES (?, ?, ?, ?)",
        [chatId, role.name, content, timestamp.toIso8601String()]);
    final inserted = await db.rawQuery(
        "SELECT role, content, timestamp FROM chat_message WHERE id = ?",
        [insertedId]);
    final row = inserted.first;
    return ChatMessage(
        role: ChatRoleExt.parse(row['role'] as String)!,
        content: row['content'] as String,
        timestamp: DateTime.parse(row['timestamp'] as String));
  }

  @override
  Future<Chat> createChat(
      {required String starterName,
      required DateTime now,
      ChatStatus status = ChatStatus.active}) async {
    final insertedId = await db.rawInsert(
        "INSERT INTO chat(starter_name, status, time_started) VALUES (?, ?, ?)",
        [starterName, status.name, now.toIso8601String()]);
    final inserted = await db.rawQuery("""
        SELECT 
          chat.id AS id, 
          chat.status AS status, 
          chat.time_started AS time_started, 
          starter.name AS starter_name, 
          starter.content AS starter_content 
        FROM chat 
        LEFT JOIN chat_starter AS starter ON starter.name = chat.starter_name 
        WHERE chat.id = ?
        """, [insertedId]);
    final row = inserted.first;
    return Chat(
        id: row['id'] as int,
        starter: ChatStarter(
            name: row['starter_name'] as String,
            content: row['starter_content'] as String),
        status:
            ChatStatusExt.parse(row['status'] as String) ?? ChatStatus.active,
        started: DateTime.parse(row['time_started'] as String));
  }
}
