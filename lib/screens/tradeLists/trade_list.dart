import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../model/model_index.dart';
import '../../services/service_index.dart';
import '../../utils/utils_index.dart';
import '../../widgets/widget_index.dart';
import '../screen_index.dart';

class TradeList extends StatefulWidget {
  const TradeList({super.key, this.type, this.adId});
  final String? type;
  final String? adId;

  @override
  State<TradeList> createState() => _TradeListState();
}

class _TradeListState extends State<TradeList>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(true);
  ValueNotifier<List<Trade>> trades = ValueNotifier<List<Trade>>([]);
  List<String> tabs = ['All', 'Running', 'Complete'];
  late String type;
  @override
  void initState() {
    super.initState();
    if (widget.adId.validate().isEmpty) {
      int index = tabs.indexWhere(
          (element) => element.toLowerCase() == (widget.type ?? 'all'));
      index = index == -1 ? 0 : index;
      _tabController =
          TabController(length: 3, vsync: this, initialIndex: index);
    }
    afterBuildCreated(() {
      setState(() => type = widget.type ?? '');
      if (widget.adId.validate().isEmpty) {
        _tabController.addListener(() {
          type = tabs[_tabController.index].toLowerCase();
          getTrades(isRefresh: true);
        });
      }
      getTrades(isRefresh: true);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    logger.f(
        'TradeList didChangeDependencies: ${widget.type} ${widget.adId} ${widget.key} ${widget.hashCode}');
  }

  Future<void> getTrades({bool isRefresh = false}) async {
    isLoading.value = isRefresh;
    if (isRefresh) trades.value = [];
    await Apis.getTradesApi(page: 1, type: type, adId: widget.adId.validate())
        .then((value) {
      if (value.$1) {
        List<Trade> list = tryCatch<List<Trade>>(() =>
                (value.$2['trades']?['data'] ?? [])
                    .map<Trade>((e) => Trade.fromJson(e))
                    .toList()) ??
            [];
        if (isRefresh) {
          trades.value = list;
        } else {
          trades.value = [...trades.value, ...list];
        }
        pl('trades: ${trades.value.length}', 'Trade List Page');
      }
    });
    isLoading.value = false;
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    if (widget.adId.validate().isEmpty) {
      _tabController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: isLoading,
        builder: (_, isLoading, __) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Trades'),
              bottom: widget.adId.validate().isNotEmpty
                  ? null
                  : TabBar(
                      controller: _tabController,
                      indicatorColor: Colors.white,
                      labelColor: Colors.white,
                      labelStyle: boldTextStyle(),
                      tabs: tabs.map((e) => Tab(text: e)).toList(),
                    ),
            ),
            body: Column(
              children: [
                ///list
                Expanded(child: isLoading ? _loadingList() : _buildList())
              ],
            ),
          );
        });
  }

  Widget _loadingList() {
    return AnimatedListView(
      itemCount: 10,
      listAnimationType: ListAnimationType.FadeIn,
      itemBuilder: (_, index) => TradeCard(
        loading: true,
        isActive: false,
        hashSlug: '-----------',
        tradeNumber: '--------------',
        withUser: '------------',
        type: '--------',
        currency: '----------',
        paymentMethods: List.generate(3, (index) => Gateways(name: '---')),
        rate: '----------',
        cryptoAmount: '------------',
        status: 1,
        totalTrades: 0,
        completedTrade: 0,
        requestedOn: '--------------',
        onActionPressed: () {},
        useDivider: true,
      ),
    );
  }

  Widget _buildList() {
    return ValueListenableBuilder<List<Trade>>(
        valueListenable: trades,
        builder: (_, list, __) {
          if (list.isEmpty) {
            return EmptyListWidget(
              message: 'There are no trades yet',
              width: 300,
              height: 300,
              refresh: () => getTrades(isRefresh: true),
            );
          }
          return AnimatedListView(
            padding: const EdgeInsets.only(bottom: 60),
            itemCount: list.length,
            listAnimationType: ListAnimationType.FadeIn,
            itemBuilder: (context, index) {
              Trade trade = list[index];
              bool last = index == list.length - 1;
              return TradeCard(
                isActive: trade.sender?.status == 1,
                hashSlug: trade.hashSlug,
                tradeNumber: trade.tradeNumber,
                withUser: trade.sender?.username ?? 'Unknown',
                type: trade.type,
                currency: trade.currency?.code,
                paymentMethods: trade.gateways ?? [],
                rate:
                    '${(trade.rate).convertDouble(8)} ${trade.currency?.code ?? ''} / ${trade.receiverCurrency?.code ?? ''}',
                cryptoAmount:
                    '${(trade.receiveAmount.convertDouble(8))} ${trade.receiverCurrency?.code ?? ''}',
                status: trade.status,
                totalTrades: trade.sender?.totalTrade ?? 0,
                completedTrade: trade.sender?.completedTrade ?? 0,
                requestedOn: trade.createdAt,
                onActionPressed: () {},
                useDivider: true,
                isLast: last,
              );
            },
            // separatorBuilder: (context, index) => Divider(
            //     color: Colors.grey.withOpacity(0.2), thickness: 1, height: 0),
          );
        });
  }
}
