import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../utils/utils_index.dart';
import '../screen_index.dart';

class TradeList extends StatefulWidget {
  const TradeList({super.key, this.type, this.adId});
  final String? type;
  final String? adId;

  @override
  State<TradeList> createState() => _TradeListState();
}

class _TradeListState extends State<TradeList> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    logger.f(
        'TradeList didChangeDependencies: ${widget.type} ${widget.adId} ${widget.key} ${widget.hashCode}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trades')),
      body: Column(
        children: [
          Expanded(
            child: AnimatedListView(
                itemCount: 100,
                itemBuilder: (context, index) {
                  return TradeCard(
                    tradeNumber: 'YCWKP6722XSN',
                    withUser: 'userAway',
                    type: index % 2 == 0 ? 'Buy' : 'Sell',
                    currency: 'INR',
                    paymentMethod: 'Bank Transfer',
                    rate: '${1100.02 * (index + 1)} INR / ETH',
                    cryptoAmount: '${0.10005000 * index} ETH',
                    status: index % 3 == 0
                        ? 'Completed'
                        : index % 3 == 2
                            ? 'Running'
                            : 'Pending',
                    requestedOn: DateTime.now()
                        .subtract(Duration(days: index))
                        .toString(),
                    useDivider: true,
                  );
                }),
          ),
        ],
      ),
    );
  }
}
