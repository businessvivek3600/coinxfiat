import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

import '../utils/utils_index.dart';

class CustomChatWidget extends StatefulWidget {
  const CustomChatWidget({super.key, this.appBar, this.hideInput = true});
  final PreferredSizeWidget Function(
      List<types.Message> messages, types.User user)? appBar;
  final bool hideInput;
  @override
  State<CustomChatWidget> createState() => _CustomChatWidgetState();
}

class _CustomChatWidgetState extends State<CustomChatWidget> {
  List<types.Message> _messages = [];
  final _user = const types.User(
    id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
  );

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
                onPressed: () => Navigator.pop(context),
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
    final result = await FilePicker.platform.pickFiles(type: FileType.any);

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
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage);
  }

  void _loadMessages() async {
    try {
      // final response = await rootBundle.loadString(jsonEncode(chatJson));
      final messages = chatJson.map((e) => types.Message.fromJson(e)).toList();

      setState(() {
        _messages = messages;
      });
    } catch (e) {
      logger.e(
        'Failed to load messages. See console for details.',
        error: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: widget.appBar?.call(_messages, _user),
        body: Chat(
          messages: _messages,
          onAttachmentPressed: _handleAttachmentPressed,
          onMessageTap: _handleMessageTap,
          onPreviewDataFetched: _handlePreviewDataFetched,
          onSendPressed: _handleSendPressed,
          showUserAvatars: true,
          showUserNames: true,
          user: _user,
          customBottomWidget: widget.hideInput ? null : SizedBox.shrink(),
        ),
      );
}

var chatJson = [
  {
    "author": {
      "firstName": "Matthew",
      "id": "82091008-a484-4a89-ae75-a22bf8d6f3ac",
      "lastName": "White"
    },
    "createdAt": 1655624465000,
    "id": "1a2b3c4d-5e6f-7g8h-9i10j11k12l",
    "status": "seen",
    "text": "Just booked tickets for a Madrid city tour! 🏰✈️",
    "type": "text"
  },
  {
    "author": {
      "firstName": "Janice",
      "id": "e52552f4-835d-4dbe-ba77-b076e659774d",
      "imageUrl":
          "https://i.pravatar.cc/300?u=e52552f4-835d-4dbe-ba77-b076e659774d",
      "lastName": "King"
    },
    "createdAt": 1655624466000,
    "id": "m1n2o3p4q5r6s7t8u9v0w1x2y3z4",
    "status": "seen",
    "text": "That sounds amazing! Take lots of pictures! 📸",
    "type": "text"
  },
  {
    "author": {
      "firstName": "John",
      "id": "4c2307ba-3d40-442f-b1ff-b271f63904ca",
      "lastName": "Doe"
    },
    "createdAt": 1655624467000,
    "id": "a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6",
    "status": "seen",
    "text": "I love Madrid! Have you visited the Prado Museum yet?",
    "type": "text"
  },
  {
    "author": {
      "firstName": "Matthew",
      "id": "82091008-a484-4a89-ae75-a22bf8d6f3ac",
      "lastName": "White"
    },
    "createdAt": 1655624468000,
    "id": "b1c2d3e4f5g6h7i8j9k0l1m2n3o4p5q6r7s8t9u0v1w2x3y4z5",
    "status": "seen",
    "text": "Yes, the Prado Museum is on my list! Can't wait to explore it. 🎨",
    "type": "text"
  },
  {
    "author": {
      "firstName": "Janice",
      "id": "e52552f4-835d-4dbe-ba77-b076e659774d",
      "imageUrl":
          "https://i.pravatar.cc/300?u=e52552f4-835d-4dbe-ba77-b076e659774d",
      "lastName": "King"
    },
    "createdAt": 1655624469000,
    "id": "c1d2e3f4g5h6i7j8k9l0m1n2o3p4q5r6s7t8u9v0w1x2y3z4",
    "status": "seen",
    "text": "The architecture in Madrid is breathtaking. Enjoy your trip! 🌆",
    "type": "text"
  }
];
