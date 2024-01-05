import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../component/component_index.dart';
import '../../utils/utils_index.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class SupportChatPage extends StatefulWidget {
  const SupportChatPage({super.key, this.title, this.lastSeen});
  final String? title;
  final DateTime? lastSeen;
  @override
  State<SupportChatPage> createState() => _SupportChatPageState();
}

class _SupportChatPageState extends State<SupportChatPage> {
  final ValueNotifier<List<types.Message>> messages =
      ValueNotifier<List<types.Message>>([]);
  final ValueNotifier<bool> loading = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomChatWidget(
        user: types.User(id: '67aad196-c1dc-4b83-9a2c-bfab56c323a8'),
        messagesList: messages,
        loading: loading,
        onSendPressed: (message) async {
          // messages.value = [...messages.value, message];
          return true;
        },
        appBar: (messages, user) =>
            _ChatPageAppBar(title: widget.title, lastSeen: widget.lastSeen),
      ),
    );
  }
}

class _ChatPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _ChatPageAppBar({
    super.key,
    this.title,
    this.lastSeen,
  });

  final String? title;
  final DateTime? lastSeen;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title ?? ''),
          if (lastSeen != null)
            Text(
                'Last seen ${MyDateUtils.formatDateAsToday(lastSeen!, 'dd MMM yyyy')}',
                style: secondaryTextStyle(color: Colors.white70)),
        ],
      ),
      centerTitle: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.call),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.videocam),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
