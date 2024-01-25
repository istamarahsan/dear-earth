part of journal;

class ChatbotService {
  final PocketBase pb;
  ChatbotService({required this.pb});

  Future<String> send(
      Chat chat, String message, List<ChatMessage>? chatHistory) async {
    final token = pb.authStore.token;
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    final baseMessage = {"role": "USER", "content": message};
    final response = await http.post(pb.buildUrl("/api/dearearth/chat"),
        headers: headers,
        body: jsonEncode({
          "topic": chat.starter.name,
          "history": chatHistory == null
              ? baseMessage
              : [
                  ...(chatHistory.map((it) => {
                        "role": it.role.name.toUpperCase(),
                        "content": it.content
                      })),
                  baseMessage
                ],
        }));
    if (response.statusCode != 200) {
      throw Exception(
          "Request to chat service failed with status code ${response.statusCode}");
    }
    return jsonDecode(response.body)["content"];
  }
}
