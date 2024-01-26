part of journal;

abstract class EntriesData {
  Future<List<Entry>> getEntries({EntryStatus? status});
  Future<Entry> getEntry({required int entryId});
  Future<List<Message>> getEntryMessages({required int entryId});
  Future<List<Topic>> getTopics();
  Future<Entry> createEntry(
      {required String topicTitle, required DateTime now, EntryStatus status});
  Future<Message> addMessageToEntry(
      {required int entryId,
      required String content,
      required ChatRole role,
      required DateTime timestamp});
  Future<Entry> updateEntryXp(
      {required int entryId, required int awardedExperiencePoints});
  static EntriesData sqlite(sqflite.Database db) {
    return _EntriesDataSqflite(db: db);
  }
}

class _EntriesDataSqflite implements EntriesData {
  final sqflite.Database db;

  _EntriesDataSqflite({required this.db});

  @override
  Future<List<Entry>> getEntries({EntryStatus? status}) async {
    final dbResult = await db.rawQuery("""
      SELECT 
        journal_entry.id AS id, 
        journal_entry.status AS status, 
        journal_entry.time_started AS time_started,
        journal_entry.awarded_experience_points AS awarded_experience_points, 
        topic.title AS topic_title, 
        topic.lead AS topic_lead,
        topic.starter AS topic_starter
      FROM journal_entry 
      LEFT JOIN journal_topic AS topic ON topic.title = journal_entry.topic_title
      ${status == null ? "" : "WHERE journal_entry.status = ${status.name}"}
      """);
    return dbResult
        .map((row) => Entry(
            id: row['id'] as int,
            topic: Topic(
                title: row['topic_title'] as String,
                lead: row['topic_lead'] as String,
                starter: row['topic_starter'] as String),
            status: EntryStatusExt.parse(row['status'] as String) ??
                EntryStatus.active,
            started: DateTime.parse(row['time_started'] as String),
            awardedExperiencePoints: row['awarded_experience_points'] as int))
        .toList();
  }

  @override
  Future<List<Message>> getEntryMessages({required int entryId}) async {
    final dbResult = await db.rawQuery(
        "SELECT role, content, timestamp FROM journal_entry_message WHERE entry_id = ? ORDER BY timestamp",
        [entryId]);
    return dbResult
        .map((row) => Message(
            role: ChatRoleExt.parse(row['role'] as String)!,
            content: row['content'] as String,
            timestamp: DateTime.parse(row['timestamp'] as String)))
        .toList();
  }

  @override
  Future<Message> addMessageToEntry(
      {required int entryId,
      required ChatRole role,
      required String content,
      required DateTime timestamp}) async {
    final insertedId = await db.rawInsert(
        "INSERT INTO journal_entry_message(entry_id, role, content, timestamp) VALUES (?, ?, ?, ?)",
        [entryId, role.name, content, timestamp.toIso8601String()]);
    final inserted = await db.rawQuery(
        "SELECT role, content, timestamp FROM journal_entry_message WHERE id = ?",
        [insertedId]);
    final row = inserted.first;
    return Message(
        role: ChatRoleExt.parse(row['role'] as String)!,
        content: row['content'] as String,
        timestamp: DateTime.parse(row['timestamp'] as String));
  }

  @override
  Future<Entry> createEntry(
      {required String topicTitle,
      required DateTime now,
      EntryStatus status = EntryStatus.active}) async {
    final insertedId = await db.rawInsert(
        "INSERT INTO journal_entry(topic_title, status, time_started) VALUES (?, ?, ?)",
        [topicTitle, status.name, now.toIso8601String()]);
    final inserted = await db.rawQuery("""
        SELECT 
          journal_entry.id AS id, 
          journal_entry.status AS status, 
          journal_entry.time_started AS time_started, 
          journal_entry.awarded_experience_points AS awarded_experience_points,
          topic.title AS topic_title, 
          topic.lead AS topic_lead,
          topic.starter AS topic_starter
        FROM journal_entry 
        LEFT JOIN journal_topic AS topic ON topic.title = journal_entry.topic_title
        WHERE journal_entry.id = ?
      """, [insertedId]);
    final row = inserted.first;
    return Entry(
        id: row['id'] as int,
        topic: Topic(
            title: row['topic_title'] as String,
            lead: row['topic_lead'] as String,
            starter: row['topic_starter'] as String),
        status:
            EntryStatusExt.parse(row['status'] as String) ?? EntryStatus.active,
        started: DateTime.parse(row['time_started'] as String),
        awardedExperiencePoints: row['awarded_experience_points'] as int);
  }

  @override
  Future<List<Topic>> getTopics() async {
    final dbResult =
        await db.rawQuery("SELECT title, lead, starter FROM journal_topic");
    return dbResult
        .map((row) => Topic(
            title: row['title'] as String,
            lead: row['lead'] as String,
            starter: row['starter'] as String))
        .toList();
  }

  @override
  Future<Entry> updateEntryXp(
      {required int entryId, required int awardedExperiencePoints}) {
    return db.transaction((txn) async {
      await txn.rawUpdate(
          "UPDATE journal_entry SET awarded_experience_points = ? WHERE id = ?",
          [awardedExperiencePoints, entryId]);
      final inserted = await _getEntry(txn, entryId: entryId);
      return inserted;
    });
  }

  @override
  Future<Entry> getEntry({required int entryId}) {
    return db.transaction((txn) async {
      return _getEntry(txn, entryId: entryId);
    });
  }

  Future<Entry> _getEntry(sqflite_api.Transaction txn, {required int entryId}) async {
    final inserted = await txn.rawQuery("""
          SELECT 
            journal_entry.id AS id, 
            journal_entry.status AS status, 
            journal_entry.time_started AS time_started, 
            journal_entry.awarded_experience_points AS awarded_experience_points,
            topic.title AS topic_title, 
            topic.lead AS topic_lead,
            topic.starter AS topic_starter
          FROM journal_entry 
          LEFT JOIN journal_topic AS topic ON topic.title = journal_entry.topic_title
          WHERE journal_entry.id = ?
        """, [entryId]);
    final row = inserted.first;
    return Entry(
        id: row['id'] as int,
        topic: Topic(
            title: row['topic_title'] as String,
            lead: row['topic_lead'] as String,
            starter: row['topic_starter'] as String),
        status:
            EntryStatusExt.parse(row['status'] as String) ?? EntryStatus.active,
        started: DateTime.parse(row['time_started'] as String),
        awardedExperiencePoints: row['awarded_experience_points'] as int);
  }
}
