import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../component/component_index.dart';
import '../../utils/utils_index.dart';

class SupportChatPage extends StatefulWidget {
  const SupportChatPage({super.key, this.title, this.lastSeen});
  final String? title;
  final DateTime? lastSeen;
  @override
  State<SupportChatPage> createState() => _SupportChatPageState();
}

class _SupportChatPageState extends State<SupportChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomChatWidget(
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
