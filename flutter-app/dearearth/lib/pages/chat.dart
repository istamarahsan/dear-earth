import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dearearth/journal/journal.dart' as journal;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as chat;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:bubble/bubble.dart';

import 'package:dearearth/main.dart';
import 'package:pocketbase/pocketbase.dart';

class ChatPage extends StatefulWidget {
  final PocketBase pb;
  final journal.ChatbotService chatbotService;
  final journal.Entry entry;
  final journal.EntriesData entriesData;
  const ChatPage(
      {super.key,
      required this.pb,
      required this.chatbotService,
      required this.entry,
      required this.entriesData});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  chat.User modelUser = const chat.User(id: "model");
  chat.User currentUser = const chat.User(id: "user");
  final List<chat.Message> _messages = [];
  int xp = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    xp = widget.entry.awardedExperiencePoints;
    _fetchAndLoadChatHistory();
  }

  void _addMessage(chat.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _fetchAndLoadChatHistory() async {
    final messages =
        await widget.entriesData.getEntryMessages(entryId: widget.entry.id);
    final messagesAreSorted = messages.isSortedBy((msg) => msg.timestamp);
    final messagesSorted = messagesAreSorted
        ? messages
        : messages.sortedBy((msg) => msg.timestamp).toList();
    final starterMessage = chat.TextMessage(
        author: modelUser,
        id: widget.entry.started.toIso8601String(),
        createdAt: widget.entry.started.millisecondsSinceEpoch,
        text: widget.entry.topic.starter);
    final convertedMessages = messagesSorted
        .map((e) => chat.TextMessage(
            author: e.role == journal.ChatRole.model ? modelUser : currentUser,
            id: e.timestamp.toIso8601String(),
            createdAt: e.timestamp.millisecondsSinceEpoch,
            text: e.content))
        .toList();
    setState(() {
      _messages.clear();
      _messages.insertAll(
          0, [starterMessage, ...convertedMessages].reversed.toList());
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
      final message = chat.FileMessage(
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

      final message = chat.ImageMessage(
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

  void _handleMessageTap(BuildContext _, chat.Message message) async {
    if (message is chat.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as chat.FileMessage).copyWith(
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
              (_messages[index] as chat.FileMessage).copyWith(
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
    chat.TextMessage message,
    chat.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as chat.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });
  }

  void _handleSendPressed(chat.PartialText message) async {
    final now = DateTime.now();

    _addMessage(chat.TextMessage(
        author: currentUser,
        id: now.toIso8601String(),
        createdAt: now.millisecondsSinceEpoch,
        text: message.text));

    final chatHistory =
        await widget.entriesData.getEntryMessages(entryId: widget.entry.id);
    final response = await widget.chatbotService
        .send(widget.entry, message.text, chatHistory);

    await widget.entriesData.addMessageToEntry(
        entryId: widget.entry.id,
        content: message.text,
        role: journal.ChatRole.user,
        timestamp: now);
    final modelResponse = await widget.entriesData.addMessageToEntry(
        entryId: widget.entry.id,
        content: response.content,
        role: journal.ChatRole.model,
        timestamp: DateTime.now());

    _addMessage(chat.TextMessage(
        author: modelUser,
        id: modelResponse.timestamp.toIso8601String(),
        createdAt: modelResponse.timestamp.millisecondsSinceEpoch,
        text: modelResponse.content));

    if (response.awardedExperiencePoints > 0) {
      setState(() {
        xp += response.awardedExperiencePoints;
      });
      await widget.entriesData.updateEntryXp(
          entryId: widget.entry.id,
          awardedExperiencePoints: widget.entry.awardedExperiencePoints +
              response.awardedExperiencePoints);
    }
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
                      chatbotService: widget.chatbotService,
                      entriesData: widget.entriesData),
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
            showUserAvatars: false,
            showUserNames: false,
            user: currentUser,
            bubbleBuilder: _bubbleBuilder,
          ),
        ),
      );

  Widget _bubbleBuilder(
    Widget child, {
    required message,
    required nextMessageInGroup,
  }) {
    return Bubble(
      color: currentUser.id != message.author.id ||
              message.type == chat.MessageType.image
          ? const Color(0xfff5f5f7)
          : const Color(0xff48672f),
      margin: nextMessageInGroup
          ? const BubbleEdges.symmetric(horizontal: 6)
          : null,
      nip: nextMessageInGroup
          ? BubbleNip.no
          : currentUser.id != message.author.id
              ? BubbleNip.leftBottom
              : BubbleNip.rightBottom,
      child: DefaultTextStyle.merge(
        style: const TextStyle(color: Colors.black),
        child: child,
      ),
    );
  }

  AppBar _appBar(BuildContext context, {void Function()? onBackPressed}) {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.only(left: 0),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  '${_shortMonthName(widget.entry.started).toUpperCase()}\n',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff48672f),
                  ),
                ),
                Positioned(
                  top: 14, // Adjust this value as needed
                  child: Text(
                    widget.entry.started.day < 10
                        ? "0${widget.entry.started.day}"
                        : widget.entry.started.day.toString(),
                    style: const TextStyle(
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.entry.topic.title,
                  style: const TextStyle(
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
                Text(
                  '$xp xp',
                  style: const TextStyle(
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

String _shortMonthName(DateTime dateTime) {
  const monthNames = {
    1: 'Jan',
    2: 'Feb',
    3: 'Mar',
    4: 'Apr',
    5: 'May',
    6: 'Jun',
    7: 'Jul',
    8: 'Aug',
    9: 'Sep',
    10: 'Oct',
    11: 'Nov',
    12: 'Dec',
  };
  return monthNames[dateTime.month]!;
}
