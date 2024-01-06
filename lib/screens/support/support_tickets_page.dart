import 'dart:io';

import 'package:coinxfiat/constants/constants_index.dart';
import 'package:coinxfiat/utils/date_utils.dart';
import 'package:coinxfiat/utils/my_logger.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../model/model_index.dart';
import '../../routes/route_index.dart';
import '../../services/service_index.dart';
import '../../utils/utils_index.dart';

class SupportTicketsPage extends StatefulWidget {
  const SupportTicketsPage({super.key});

  @override
  State<SupportTicketsPage> createState() => _SupportTicketsPageState();
}

class _SupportTicketsPageState extends State<SupportTicketsPage> {
  ValueNotifier<bool> loading = ValueNotifier(true);
  ValueNotifier<List<Ticket>> tickets = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    getTickets();
  }

  @override
  void dispose() {
    loading.dispose();
    tickets.dispose();
    super.dispose();
  }

  void getTickets() async {
    loading.value = true;
    await Apis.getTicketsApi(1).then((value) {
      if (value.$1) {
        tickets.value = tryCatch(() =>
                ((value.$2['tickets']?['data'] ?? []) as List)
                    .map<Ticket>((e) => Ticket.fromJson(e))
                    .toList()) ??
            [];
      }
      pl('tickets: ${tickets.value.length}');
    });
    loading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: loading,
        builder: (_, loading, c) {
          return ValueListenableBuilder<List<Ticket>>(
              valueListenable: tickets,
              builder: (_, tickets, t) {
                return Scaffold(
                  appBar: AppBar(
                    title: const Text('Support'),
                    actions: [
                      IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (context) =>
                                  const CreateSupportTicketPage(),
                              isScrollControlled: false,
                            );
                          },
                          icon: const Icon(Icons.add))
                    ],
                  ),
                  body: AnimatedListView(
                    listAnimationType: ListAnimationType.FadeIn,
                    itemBuilder: (_, index) {
                      Ticket ticket = tickets[index];
                      bool read = ticket.status == 1;
                      return ListTile(
                        onTap: () {
                          context.push(Paths.chat(ticket.ticket.validate()),
                              extra: {
                                'title': 'Ticket ${ticket.ticket.validate()}',
                                'lastSeen': ticket.lastReply.validate(),
                              });
                        },
                        leading: CircleAvatar(
                            backgroundColor: context.primaryColor,
                            child: const Text('T',
                                style: TextStyle(color: Colors.white))),
                        title: Text('Ticket ${ticket.ticket.validate()}'),
                        subtitle: Row(
                          children: [
                            ///read unread
                            FaIcon(
                              read
                                  ? Icons.done_all
                                  : Icons.check_circle_outline,
                              color: read ? Colors.green : Colors.grey.shade400,
                              size: 12,
                            ),
                            5.width,
                            Expanded(child: Text(ticket.subject.validate())),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            //count
                            Container(
                              padding: const EdgeInsetsDirectional.symmetric(
                                  horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Text('2',
                                  style: primaryTextStyle(
                                      color: Colors.white, size: 8)),
                            ),
                            1.height,
                            //time
                            Text(
                                MyDateUtils.formatDateAsToday(
                                    ticket.updatedAt.validate(), 'dd MMM yyyy'),
                                style: primaryTextStyle(
                                    color: Colors.grey.shade400, size: 10)),
                          ],
                        ),
                      );
                    },
                    itemCount: tickets.length,
                  ),
                );
              });
        });
  }
}

class CreateSupportTicketPage extends StatefulWidget {
  const CreateSupportTicketPage({Key? key}) : super(key: key);

  @override
  State<CreateSupportTicketPage> createState() =>
      _CreateSupportTicketPageState();
}

class _CreateSupportTicketPageState extends State<CreateSupportTicketPage> {
  String selectedDepartment = '';
  String selectedPriority = '';
  TextEditingController subject = TextEditingController(text: '');
  TextEditingController message = TextEditingController(text: '');
  final _formKey = GlobalKey<FormState>();
  ValueNotifier<XFile?> attachment = ValueNotifier(null);

  Future<XFile?> pickAttachment() async {
    final XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      attachment.value = pickedFile;
    }
    return pickedFile;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => primaryFocus?.unfocus(),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        child: Scaffold(
          body: Column(
            children: [
              AppBar(
                title: const Text('Create Ticket'),
                actions: [
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.done)),
                ],
              ),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: AnimatedScrollView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      fieldTitle('Subject'),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              enabled: true,
                              controller: subject,
                              // cursorColor: Colors.white,
                              // style: const TextStyle(color: Colors.white),
                              decoration:
                                  const InputDecoration(hintText: 'Subject'),
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Subject is required.';
                                } else if (val.length < 5) {
                                  return 'Subject should be at least 5 characters.';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      height10(),
                      fieldTitle('Message'),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              enabled: true,
                              controller: message,
                              // cursorColor: Colors.white,
                              minLines: 6,
                              maxLines: null,
                              // style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                  hintText: 'Tell us your query',
                                  contentPadding: EdgeInsets.all(8)),
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Message is required.';
                                } else if (val.length <= 20) {
                                  return 'Message should be at least 20 characters.';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      10.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          fieldTitle('Attachment'),
                          FaIcon(FontAwesomeIcons.paperclip,
                                  color: Colors.grey.shade400, size: 20)
                              .paddingAll(5)
                              .onTap(pickAttachment,
                                  borderRadius: BorderRadius.circular(100))
                        ],
                      ),
                      ValueListenableBuilder<XFile?>(
                        valueListenable: attachment,
                        builder: (_, file, c) {
                          return Visibility(
                            visible: file != null,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey.shade400, width: 3),
                                borderRadius:
                                    BorderRadius.circular(DEFAULT_RADIUS * 1.5),
                              ),
                              child: Stack(
                                children: [
                                  Image.file(File(file?.path.validate() ?? ''))
                                      .cornerRadiusWithClipRRect(DEFAULT_RADIUS)
                                      .paddingAll(3),

                                  ///delete
                                  Positioned(
                                    top: DEFAULT_PADDING / 3,
                                    right: DEFAULT_PADDING / 3,
                                    child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      DEFAULT_RADIUS),
                                            ),
                                            padding: const EdgeInsets.all(
                                                DEFAULT_PADDING / 2),
                                            child: const Icon(Icons.delete,
                                                color: Colors.red, size: 20))
                                        .paddingAll(5)
                                        .onTap(() {
                                      attachment.value = null;
                                    }),
                                  ),
                                ],
                              ),
                            ).paddingTop(10),
                          );
                        },
                      ),
                      height50(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // bottomNavigationBar: buildSubmitButton(),
        ),
      ),
    );
  }

  Widget buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 8.0, horizontal: DEFAULT_PADDING),
      child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              // provider.newTicketSubmit(subject.text, selectedDepartment,
              //     selectedPriority, message.text);
            }
          },
          child: const Text('Submit Ticket')),
    );
  }

  Widget fieldTitle(String title) {
    return Column(
      children: [
        Row(
          children: [
            bodyLargeText(title, context,
                style: boldTextStyle(color: Colors.grey.shade800))
          ],
        ),
        height10(),
      ],
    );
  }
}
