import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'package:dearearth/pages/home.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // Set your custom theme here
        primarySwatch: Colors.green,
        // Add more customizations if needed
      ),
      home: const ChatPage(),
    );
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<types.Message> _messages = [];
  final _user = const types.User(
    id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
  );

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
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
              onPressed: () {// Contoh: Menghapus SnackBar sebelum pindah
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(),
                  ),
                );
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
        author: _user,
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
        author: _user,
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

  void _handleSendPressed(types.PartialText message) {
    final userMessage = message.text;

    // Add user message
    final userTextMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: userMessage,
    );
    _addMessage(userTextMessage);

    // Simulate receiver's response
    final receiverResponse = "$userMessage";
    final receiverTextMessage = types.TextMessage(
      author: const types.User(id: 'receiver_user'),
      createdAt: DateTime.now().millisecondsSinceEpoch + 1,
      id: const Uuid().v4(),
      text: receiverResponse,
    );
    _addMessage(receiverTextMessage);
  }

  void _loadMessages() async {
    // Add a hello message when the user enters the chat page
    final helloMessage = types.TextMessage(
      author: const types.User(id: 'system_user'),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: 'Hello! Welcome to the chat!',
    );

    setState(() {
      _messages = [helloMessage];
    });

    // Load messages from the JSON file
    final response = await rootBundle.loadString('assets/messages.json');
    final messages = (jsonDecode(response) as List)
        .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
        .toList();

    setState(() {
      _messages.addAll(messages);
    });
  }

  @override
  Widget build(BuildContext context) => Material(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: _appBar(context),
          body: Chat(
            messages: _messages,
            onAttachmentPressed: _handleAttachmentPressed,
            onMessageTap: _handleMessageTap,
            onPreviewDataFetched: _handlePreviewDataFetched,
            onSendPressed: _handleSendPressed,
            showUserAvatars: true,
            showUserNames: true,
            user: _user,
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

AppBar _appBar(BuildContext context) {
  return AppBar(
    title: Padding(
      padding: const EdgeInsets.only(left: 0),
      child: Row(
        children: [
          Stack(
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
          SizedBox(
            width: 10,
          ),
          Container(
            width: 2,
            height: 38,
            decoration: BoxDecoration(color: Color(0xff48672f)),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
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
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        // Navigate to the homepage when the back arrow is pressed
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      },
    ),
    actions: [
      GestureDetector(
        onTap: () {},
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(right: 20, top: 10, bottom: 10),
          padding: EdgeInsets.only(right: 15, top: 8, bottom: 8, left: 15),
          decoration: BoxDecoration(
              color: Color(0xff48672f),
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
              SizedBox(
                width: 5,
              ),
              Text(
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
