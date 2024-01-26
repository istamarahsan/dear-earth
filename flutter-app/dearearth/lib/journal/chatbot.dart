part of journal;

class ChatbotResponse {
  final String content;
  final int awardedExperiencePoints;
  final int awardedActionPoints;
  ChatbotResponse(
      {required this.content,
      required this.awardedExperiencePoints,
      required this.awardedActionPoints});
}

class ChatbotService {
  final PocketBase pb;
  ChatbotService({required this.pb});

  Future<ChatbotResponse> send(
      Entry chat, String message, List<Message>? chatHistory) async {
    final token = pb.authStore.token;
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    final baseMessage = {"role": "USER", "content": message};
    final response = await http.post(pb.buildUrl("/api/dearearth/chat"),
        headers: headers,
        body: jsonEncode({
          "topic": chat.topic.title,
          "history": chatHistory == null
              ? baseMessage
              : [
                  ...(chatHistory.map((it) => {
                        "role": it.role.name.toUpperCase(),
                        "content": it.content
                      })),
                  baseMessage
                ],
          "submission": null
        }));
    if (response.statusCode != 200) {
      throw Exception(
          "Request to chat service failed with status code ${response.statusCode}");
    }
    final decoded = jsonDecode(response.body);
    return ChatbotResponse(
        content: decoded["content"] as String,
        awardedExperiencePoints: decoded["awardedXp"] as int,
        awardedActionPoints: decoded["awardedAp"] as int);
  }
}
