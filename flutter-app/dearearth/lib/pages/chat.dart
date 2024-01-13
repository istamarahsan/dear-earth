import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'package:dearearth/main.dart';
import 'package:pocketbase/pocketbase.dart';

class ChatPage extends StatefulWidget {
  final PocketBase pb;
  final String chatId;
  const ChatPage({super.key, required this.pb, required this.chatId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  types.User modelUser = const types.User(id: "model");
  types.User currentUser = const types.User(id: "user");
  List<types.Message> _messages = [];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _fetchAndLoadChatHistory();
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _fetchAndLoadChatHistory() async {
    final chatRecord = await widget.pb
        .collection('chats')
        .getOne(widget.chatId, expand: 'starter,history');
    final starterRecord = chatRecord.expand["starter"]![0];
    final chatHistoryRecords = chatRecord.expand["history"] ?? [];
    chatHistoryRecords.sort(
        (a, b) => a.getIntValue("order").compareTo(b.getIntValue("order")));

    final starterMessage = types.TextMessage(
        id: starterRecord.id,
        author: modelUser,
        createdAt: DateTime.parse(chatRecord.created).millisecondsSinceEpoch,
        text: starterRecord.getStringValue("content"));
    final chatHistoryMessages = chatHistoryRecords.map((it) =>
        types.TextMessage(
            id: it.id,
            author: it.getIntValue("order") % 2 == 0 ? modelUser : currentUser,
            createdAt: DateTime.parse(it.created).millisecondsSinceEpoch,
            text: it.getStringValue("content")));
    setState(() {
      _messages.clear();
      _messages.insertAll(
          0, [starterMessage, ...chatHistoryMessages].reversed.toList());
    });
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('File'),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Contoh: Menghapus SnackBar sebelum pindah
                  Navigator.pop(context);
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: currentUser,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      _addMessage(message);
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: currentUser,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      _addMessage(message);
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });
  }

  void _handleSendPressed(types.PartialText message) async {
    final userMessage = message.text;

    // Add user message
    final userTextMessage = types.TextMessage(
      author: currentUser,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: userMessage,
    );
    _addMessage(userTextMessage);

    final endpoint =
        widget.pb.buildUrl("/api/dearearth/chat/respond/${widget.chatId}");
    final response = await http.post(endpoint,
        headers: {
          "Authorization": "Bearer ${widget.pb.authStore.token}",
          "Content-Type": "application/json"
        },
        body: jsonEncode({"content": message.text}));
    if (response.statusCode != HttpStatus.ok) {
      print("error: ${response.toString()}");
      return;
    }
    final responseText = jsonDecode(response.body)["content"];
    _addMessage(types.TextMessage(
        author: modelUser, id: const Uuid().v4(), text: responseText));
  }

  @override
  Widget build(BuildContext context) => Material(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: _appBar(
            context,
            onBackPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => DearEarthApp(
                    pb: widget.pb,
                  ),
                ),
              );
            },
          ),
          body: Chat(
            messages: _messages,
            onAttachmentPressed: _handleAttachmentPressed,
            onMessageTap: _handleMessageTap,
            onPreviewDataFetched: _handlePreviewDataFetched,
            onSendPressed: _handleSendPressed,
            showUserAvatars: true,
            showUserNames: true,
            user: currentUser,
          ),
        ),
      );
}

class CustomMessageContainer extends StatelessWidget {
  const CustomMessageContainer({
    Key? key,
    required this.alignment,
    required this.child,
  }) : super(key: key);

  final CrossAxisAlignment alignment;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.bottomEnd,
      child: Container(
        margin: const EdgeInsets.all(8),
        child: Align(
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }
}

AppBar _appBar(BuildContext context, { void Function()? onBackPressed }) {
  return AppBar(
    title: Padding(
      padding: const EdgeInsets.only(left: 0),
      child: Row(
        children: [
          const Stack(
            alignment: Alignment.center,
            children: [
              Text(
                'JAN\n',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff48672f),
                ),
              ),
              Positioned(
                top: 14, // Adjust this value as needed
                child: Text(
                  '07',
                  style: TextStyle(
                    fontSize: 20, // Set a different font size for '07'
                    fontWeight: FontWeight.w600,
                    color: Color(0xff48672f),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            width: 2,
            height: 38,
            decoration: const BoxDecoration(color: Color(0xff48672f)),
          ),
          const SizedBox(
            width: 10,
          ),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Dear Earth, I will",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Text(
                "Unplug it Now!",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    backgroundColor: Colors.white,
    elevation: 0.0,
    centerTitle: false,
    leading: IconButton(
        icon: const Icon(Icons.arrow_back), onPressed: onBackPressed),
    actions: [
      GestureDetector(
        onTap: () {},
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(right: 20, top: 10, bottom: 10),
          padding:
              const EdgeInsets.only(right: 15, top: 8, bottom: 8, left: 15),
          decoration: BoxDecoration(
              color: const Color(0xff48672f),
              borderRadius: BorderRadius.circular(40)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/exp_white.png',
                height: 20,
                width: 20,
              ),
              const SizedBox(
                width: 5,
              ),
              const Text(
                '595 xp',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              )
            ],
          ),
        ),
      ),
    ],
  );
}
