import 'package:coinxfiat/constants/constants_index.dart';
import 'package:coinxfiat/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../routes/route_index.dart';

class SupportTicketsPage extends StatefulWidget {
  const SupportTicketsPage({super.key});

  @override
  State<SupportTicketsPage> createState() => _SupportTicketsPageState();
}

class _SupportTicketsPageState extends State<SupportTicketsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support tickets'),
      ),
      body: AnimatedListView(
          listAnimationType: ListAnimationType.FadeIn,
          itemBuilder: (context, index) {
            int total = 3 * index;
            return ListTile(
              onTap: () {
                context.pushNamed(Routes.chat, queryParameters: {
                  'title': 'Ticket $index',
                  'lastSeen': DateTime.now().toString(),
                });
              },
              leading: const CircleAvatar(child: Text('T')),
              title: Text('Ticket $index'),
              subtitle: Row(
                children: [
                  ///read unread
                  FaIcon(
                    index.isEven ? Icons.done_all : Icons.check_circle_outline,
                    color: index.isEven ? Colors.green : Colors.grey.shade400,
                    size: 12,
                  ),
                  5.width,
                  Expanded(child: Text('Ticket $index description')),
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
                        style: primaryTextStyle(color: Colors.white, size: 8)),
                  ),
                  1.height,
                  //time
                  Text(
                      MyDateUtils.formatDateAsToday(
                          DateTime.now().subtract(Duration(hours: total * 4)),
                          'dd MMM yyyy'),
                      style: primaryTextStyle(
                          color: Colors.grey.shade400, size: 10)),
                ],
              ),
            );
          },
          itemCount: 10),
    );
  }
}
