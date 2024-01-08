import 'dart:io';
import 'dart:math';

import 'package:coinxfiat/model/model_index.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constants/constants_index.dart';
import '../../services/service_index.dart';
import '../../store/store_index.dart';
import '../../utils/utils_index.dart';

class CreateSupportTicketPage extends StatefulWidget {
  const CreateSupportTicketPage({Key? key, required this.onCreate})
      : super(key: key);
  final Future<dynamic> Function(Ticket ticket) onCreate;

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

  Future<void> _submitTicket() async {
    hideKeyboard(context);
    appStore.setLoading(true);

    if (_formKey.currentState?.validate() ?? false) {
      FormData formData = FormData.fromMap({
        'subject': subject.text,
        'message': message.text,
        'attachment': attachment.value == null
            ? ''
            : await MultipartFile.fromFile(attachment.value!.path.validate(),
                filename: attachment.value!.name.validate()),
      });
      pl('message ${formData.files.map((e) => '${e.value.headers}\n ${e.value.contentType} \n ${e.value.filename}\n ${e.value.length} \n ${e.value.isFinalized} ').toList()}');
      await Apis.createTicketApi(formData).then((value) {
        if (value.$1) {
          toast(value.$2['message'].validate());
          Navigator.pop(context);
        }
      });
    }
    widget.onCreate.call(
      Ticket(
        id: Random().nextInt(1000),
        ticket: Random().nextInt(1000).toString(),
        subject: subject.text,
        lastReply: DateTime.now().toString(),
        status: 1,
        createdAt: DateTime.now().toString(),
      ),
    );

    appStore.setLoading(false);
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
                      onPressed: _submitTicket, icon: const Icon(Icons.done)),
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
                              textInputAction: TextInputAction.next,
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
                      ValueListenableBuilder<XFile?>(
                          valueListenable: attachment,
                          builder: (_, file, c) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    fieldTitle('Attachment'),
                                    FaIcon(
                                            file == null
                                                ? FontAwesomeIcons.plus
                                                : FontAwesomeIcons.fileImage,
                                            color: file == null
                                                ? context.primaryColor
                                                : //replace color
                                                Colors.green,
                                            size: 20)
                                        .paddingAll(5)
                                        .onTap(pickAttachment,
                                            borderRadius:
                                                BorderRadius.circular(100))
                                  ],
                                ),
                                if (file != null)
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade400,
                                          width: 1),
                                      borderRadius: BorderRadius.circular(
                                          DEFAULT_RADIUS * 1.5),
                                    ),
                                    child: Stack(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade200,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        DEFAULT_RADIUS * 1.3),
                                                border: Border.all(
                                                    color: Colors.grey.shade400,
                                                    width: 2),
                                              ),
                                              margin: const EdgeInsets.all(3),
                                              child: Image.file(
                                                File(file!.path.validate()),
                                                fit: BoxFit.cover,
                                              )
                                                  .cornerRadiusWithClipRRect(
                                                      DEFAULT_RADIUS)
                                                  .paddingAll(0),
                                            ).paddingRight(DEFAULT_PADDING),
                                            Expanded(
                                              child: Text(
                                                file.name
                                                    .validate()
                                                    .split('/')
                                                    .last,
                                                style: primaryTextStyle(
                                                    color: Colors.grey.shade400,
                                                    size: 12),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ).paddingOnly(
                                                  right: DEFAULT_PADDING),
                                            ),
                                            Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              DEFAULT_RADIUS),
                                                    ),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            DEFAULT_PADDING /
                                                                2),
                                                    child: const Icon(
                                                        Icons.delete,
                                                        color: Colors.red,
                                                        size: 20))
                                                .paddingAll(5)
                                                .onTap(() {
                                              attachment.value = null;
                                            },
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            DEFAULT_RADIUS))
                                          ],
                                        ),
                                      ],
                                    ),
                                  ).paddingTop(10),
                              ],
                            );
                          }),
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
