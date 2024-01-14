part of journal;

abstract class ChatsData {
  Future<List<Chat>> getChats({ChatStatus? status});
  Future<List<ChatMessage>> getChatMessages({required int chatId});
  Future<List<ChatSubmission>> getChatSubmissions({required int chatId});
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
      SELECT chat.id AS id, chat.status AS status, starter.name AS starter_name, starter.content AS starter_content
      FROM chat 
      LEFT JOIN chat_starter AS starter ON chat_starter.name = chat.starter_name
      ${status == null ? "" : "chat.status = ${status.name}"}
      """);
    return collection
        .groupBy(dbResult, (row) => row['id'] as String)
        .values
        .map((chatDetailRows) => Chat(
            id: chatDetailRows[0]['id'] as int,
            starter: ChatStarter(
                name: chatDetailRows[0]['starter_name'] as String,
                content: chatDetailRows[0]['starter_content'] as String),
            status:
                ChatStatusExt.parse(chatDetailRows[0]['status'] as String) ??
                    ChatStatus.active))
        .toList();
  }
  
  @override
  Future<List<ChatMessage>> getChatMessages({required int chatId}) {
    // TODO: implement getChatMessages
    throw UnimplementedError();
  }
  
  @override
  Future<List<ChatSubmission>> getChatSubmissions({required int chatId}) {
    // TODO: implement getChatSubmissions
    throw UnimplementedError();
  }
}
