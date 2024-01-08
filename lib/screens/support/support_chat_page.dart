import 'package:coinxfiat/model/model_index.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../component/component_index.dart';
import '../../constants/constants_index.dart';
import '../../routes/route_index.dart';
import '../../services/service_index.dart';
import '../../store/store_index.dart';
import '../../utils/utils_index.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import '../screen_index.dart';

class SupportChatPage extends StatefulWidget {
  const SupportChatPage({super.key, this.title, this.lastSeen, this.id});
  final String? id;
  final String? title;
  final DateTime? lastSeen;
  @override
  State<SupportChatPage> createState() => _SupportChatPageState();
}

class _SupportChatPageState extends State<SupportChatPage> {
  final ValueNotifier<List<types.Message>> messages =
      ValueNotifier<List<types.Message>>([]);
  final ValueNotifier<bool> _loading = ValueNotifier(true);
  ValueNotifier<Ticket?> ticket = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    getChatMessages();
  }

  @override
  void dispose() {
    _loading.dispose();
    messages.dispose();
    super.dispose();
  }

  Future<void> getChatMessages([dynamic chatId, int perPage = 20]) async {
    _loading.value = chatId == null;
    await Apis.getTicketMessagesByIdApi(widget.id.validate(), null)
        .then((value) async {
      if (value.$1) {
        ticket.value = tryCatch(() => Ticket.fromJson(value.$2['ticket']));
        final messageList = <types.Message>[];
        for (var e in ((tryCatch(() => value.$2['messages'] ?? [])) as List)) {
          var message = tryCatch(() => messageFromJson(e), 'getChatMessages');
          if (message == null) continue;
          messageList.add(message);
        }
        await (perPage * 10).milliseconds.delay;
        if (messageList.isNotEmpty) {
          for (var message in messageList) {
            bool contains =
                messages.value.any((element) => element.id == message.id);
            if (!contains) {
              // chatId == null
              //     ?
              messages.value.add(message);
              // : messages.value.insert(0, message);
            } else {
              var index = messages.value
                  .indexWhere((element) => element.id == message.id);
              messages.value[index] = message;
            }
          }
        }

        // messages.value.insertAll(0, messageList);
        pl('messages: ${messages.value.length}', 'getChatMessages');
      }
      pl('tickets: ${messages.value.length}');
    });
    _loading.value = false;
  }

  Future<bool> sendMessage(dynamic message) async {
    if (message is String && message.isEmpty) return false;
    final formData = FormData.fromMap({
      "message": message is! String ? '' : message,
    });
    if (message is XFile || message is PlatformFile) {
      formData.files.add(MapEntry(
          'attachment',
          await MultipartFile.fromFile(message.path ?? '',
              filename: message.name)));
    }
    pl('sending message: $message ${formData.fields}}');

    await Apis.replyTicket(formData, widget.id.validate()).then((value) {
      pl('pushTradeMessageApi: $value');
      if (value.$1) setState(() {});
      // myChannel!.trigger(
      //   PusherEvent(channelName: channelName, eventName: 'new-message', data: {
      //     "id": 3553,
      //     "trades_id": 186,
      //     "chatable_type": "App\\Models\\User",
      //     "chatable_id": 8,
      //     "description": "dfdfdf",
      //     "attachment":
      //         "assets/uploads/attachments/65968caed70d61704365230.png",
      //     "is_read": 0,
      //     "is_read_admin": 0,
      //     "created_at": "2024-01-04T10:47:10.000000Z",
      //     "updated_at": "2024-01-04T10:47:11.000000Z",
      //     "formatted_date": "Jan 04, 2024 04:17 PM",
      //     "chatable": {
      //       "id": 8,
      //       "username": "SumitSharma",
      //       "phone": "870079956563",
      //       "image": null,
      //       "fullname": " ",
      //       "mobile": " 870079956563",
      //       "imgPath":
      //           "https://p2p.coinxfiat.com/assets/admin/images/default.png",
      //       "last_seen": true,
      //       "total_trade": 4
      //     }
      //   }),
      // );
    });
    return true;
  }

  types.Message? messageFromJson(Map<String, dynamic> json) {
    if (json['attachment'].toString().validate().isEmpty &&
        json['message'].toString().validate().isEmpty) return null;
    int createdAt =
        DateTime.tryParse(json['created_at'] ?? '')?.millisecondsSinceEpoch ??
            0;
    String id = json['id'].toString().validate();
    types.Status status =
        json['is_read'] == 1 ? types.Status.seen : types.Status.sent;
    String username = json['admin_id'] == null ? 'Admin' : '';
    String url =
        'https://ui-avatars.com/api/?size=256&name=$username&background=ffc107&color=fff&=true';
    Uri imageUrl = Uri.file(url);
    types.User user = types.User.fromJson({
      "firstName": username.capitalizeEachWord(),
      "id": (json['admin_id'] ?? '').toString().validate(),
      "lastName": '',
      'imageUrl': imageUrl.data,
    });
    String text = json['message'].toString().validate();

    ///text message
    if (json['attachment'].toString().validate().isEmpty) {
      return types.TextMessage(
        author: user,
        createdAt: createdAt,
        id: id,
        text: text,
        status: status,
      );

      ///others
    } else {
      bool isImage = json['attachment'].toString().validate().isImage ||
          json['attachment'].toString().validate().split('.').last == 'png';
      bool isVideo = json['attachment'].toString().validate().isVideo;
      bool isAudio = json['attachment'].toString().validate().isAudio;
      String attachment = json['attachment'].toString().validate();
      bool replied = text.isNotEmpty;
      pl('id:=> $id is  isImage: $isImage, isVideo: $isVideo, isAudio: $isAudio  hasReplied: $replied');
      if (isImage) {
        return types.ImageMessage(
          author: user,
          createdAt: createdAt,
          status: status,
          // height: image.height.toDouble(),
          id: id,
          name: '',
          size: 100,
          // uri: 'https://wallpapers.com/images/featured/hd-a5u9zq0a0ymy2dug.jpg',
          uri: AppConst.siteUrl + attachment,
          // width: image.width.toDouble(),
          remoteId: id,
          repliedMessage: replied
              ? types.TextMessage(
                  author: user,
                  createdAt: createdAt,
                  id: id,
                  text: text,
                  status: status,
                )
              : null,
        );
      }
      return types.FileMessage(
        author: user,
        status: status,
        createdAt: createdAt,
        id: id,
        mimeType: lookupMimeType(attachment),
        name: '',
        size: 100,
        uri: attachment,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: _loading,
        builder: (_, loading, ch) {
          return ValueListenableBuilder<Ticket?>(
              valueListenable: ticket,
              builder: (_, ticket, c) {
                bool inValid = ticket == null;
                return Scaffold(
                  appBar: _ChatPageAppBar(
                      title: widget.title, lastSeen: widget.lastSeen),
                  body: loading
                      ? Center(
                          child: assetLottie(MyLottie.chatLoading,
                              width: 100, height: 70))
                      : inValid
                          ? errorWidget(context)
                          : CustomChatWidget(
                              user: types.User(id: appStore.userId.toString()),
                              messagesList: messages,
                              onSendPressed: sendMessage,
                              loading: _loading,
                              showUserAvatar: true,
                              onLoadMore: () async {
                                await getChatMessages(
                                    int.tryParse(messages.value.last.id), 20);
                              },
                              // appBar: (messages, user) => _ChatPageAppBar(
                              //     title: widget.title,
                              //     lastSeen: widget.lastSeen),
                            ),
                );
              });
        });
  }

  Column errorWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        assetLottie(MyLottie.support),
        10.height,
        Text(
          'The support ticket may have been closed or deleted.',
          style: GoogleFonts.asapCondensed(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        10.height,
        Text(
          'Please contact support for more information.',
          style: GoogleFonts.asapCondensed(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        10.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                finish(context);
              },
              child: Text(
                'Go Back',
                style: GoogleFonts.asapCondensed(
                    fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            10.width,
            TextButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => CreateSupportTicketPage(
                    onCreate: (ticket) async {
                      // List<Ticket> tickets = [...supportStore.supportTickets];
                      Navigator.pop(context);
                      supportStore.supportTickets.insert(0, ticket);
                      supportStore
                          .setSupportTickets(supportStore.supportTickets);
                      pl('tickets: ${ticket.ticket} ${supportStore.supportTickets.length} ${supportStore.loadingSupportTickets}');
                      await 1.seconds.delay.then((value) {
                        goRouter.push(
                          Paths.chat(ticket.ticket ?? 'no_id'),
                          extra: {
                            'title': 'Ticket ${ticket.ticket.validate()}',
                            'lastSeen': ticket.lastReply.validate(),
                            'anim': RouteTransition.fomRight.name,
                          },
                        );
                      });
                    },
                  ),
                  isScrollControlled: false,
                );
              },
              child: Text(
                'Create a new ticket',
                style: GoogleFonts.asapCondensed(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
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
