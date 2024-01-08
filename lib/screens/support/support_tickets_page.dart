import 'package:coinxfiat/constants/constants_index.dart';
import 'package:coinxfiat/store/store_index.dart';
import 'package:coinxfiat/widgets/widget_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../model/model_index.dart';
import '../../routes/route_index.dart';
import '../../utils/utils_index.dart';
import 'support_index.dart';

class SupportTicketsPage extends StatefulWidget {
  const SupportTicketsPage({super.key});

  @override
  State<SupportTicketsPage> createState() => _SupportTicketsPageState();
}

class _SupportTicketsPageState extends State<SupportTicketsPage> {
  @override
  void initState() {
    supportStore.setLoadingSupportTickets(true);
    super.initState();
    supportStore.getTickets();
  }

  @override
  void dispose() {
    supportStore.setSupportTickets([]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text('Support'),
          actions: [
            IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) => CreateSupportTicketPage(
                      onCreate: (ticket) async {
                        List<Ticket> tickets = [...supportStore.supportTickets];
                        tickets.insert(0, ticket);
                        supportStore.setSupportTickets(tickets);
                        Navigator.pop(context);
                        goRouter.push(
                          Paths.chat(ticket.ticket ?? 'no_id'),
                          extra: {
                            'title': 'Ticket ${ticket.ticket.validate()}',
                            'lastSeen': ticket.lastReply.validate(),
                          },
                        );
                      },
                    ),
                    isScrollControlled: false,
                  );
                },
                icon: const Icon(Icons.add))
          ],
        ),
        body: AnimatedListView(
          onSwipeRefresh: () async {
            await supportStore.getTickets();
          },
          emptyWidget: Padding(
            padding: const EdgeInsets.all(DEFAULT_PADDING),
            child: Center(
              child: supportStore.loadingSupportTickets
                  ? LoaderWidget()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        assetLottie(MyLottie.support, height: 200),
                        10.height,
                        Text(
                            'You have no raised any ticket yet\nCreate one now and get help from our support team.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.balooChettan2(fontSize: 14)),
                        10.height,
                        TextButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: (context) => CreateSupportTicketPage(
                                  onCreate: (ticket) async {
                                    supportStore.supportTickets
                                        .insert(0, ticket);
                                  },
                                ),
                                isScrollControlled: false,
                              );
                            },
                            child: Text('Create Ticket',
                                style: primaryTextStyle(size: 16))),
                      ],
                    ),
            ),
          ),
          listAnimationType: ListAnimationType.FadeIn,
          itemBuilder: (_, index) {
            Ticket ticket = supportStore.supportTickets[index];
            return _TicketTile(ticket: ticket);
          },
          itemCount: supportStore.supportTickets.length,
        ),
      ),
    );
  }
}

class _TicketTile extends StatelessWidget {
  const _TicketTile({
    super.key,
    required this.ticket,
  });

  final Ticket ticket;

  @override
  Widget build(BuildContext context) {
    bool read = ticket.status == 1;

    return ListTile(
      onTap: () {
        context.push(Paths.chat(ticket.ticket ?? 'no_id'), extra: {
          'title': 'Ticket ${ticket.ticket.validate()}',
          'lastSeen': ticket.lastReply.validate(),
        });
      },
      leading: CircleAvatar(
          backgroundColor: context.primaryColor,
          child: const Text('T', style: TextStyle(color: Colors.white))),
      title: Text('Ticket ${ticket.ticket.validate()}'),
      subtitle: Row(
        children: [
          ///read unread
          FaIcon(read ? Icons.done_all : Icons.check_circle_outline,
              color: read ? Colors.green : Colors.grey.shade400, size: 12),
          5.width,
          Expanded(
              child: Text(ticket.subject.validate(),
                  maxLines: 1, overflow: TextOverflow.ellipsis)),
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
                  ticket.updatedAt.validate(), 'dd MMM yyyy'),
              style: primaryTextStyle(color: Colors.grey.shade400, size: 10)),
        ],
      ),
    );
  }
}
