import 'package:coinxfiat/services/service_index.dart';
import 'package:coinxfiat/utils/utils_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../component/component_index.dart';
import '../../../constants/constants_index.dart';
import '../../../model/model_index.dart';
import '../../../routes/route_index.dart';
import '../../../store/store_index.dart';
import '../../screen_index.dart';

class DashboardFragment extends StatefulWidget {
  const DashboardFragment({super.key});

  @override
  State<DashboardFragment> createState() => _DashboardFragmentState();
}

class _DashboardFragmentState extends State<DashboardFragment>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late double defaultTopPadding;
  double _topPadding = 250;
  int currentIndex = 0;

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void initState() {
    super.initState();
    dashboardStore.getDashboardData();

// appStore
    afterBuildCreated(() {
      defaultTopPadding = context.height() * 0.3;
      _topPadding = defaultTopPadding;
      setState(() {});
    });
    _scrollController.addListener(() => _listenForScroll());
  }

  void _listenForScroll() {
    if (_scrollController.offset >= 0 &&
        _scrollController.offset <= defaultTopPadding) {
      setState(
          () => _topPadding = defaultTopPadding - _scrollController.offset);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(() => _listenForScroll());
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Stack(
        children: [
          Container(color: context.scaffoldBackgroundColor),

          /// This is the main content
          _Header(setDefaultHight: (double hight) {}),

          /// This is the trade counts card list in horizontal
          _RestBody(
            topPadding:
                _topPadding >= kToolbarHeight ? _topPadding : kToolbarHeight,
            scrollController: _scrollController,
            loading: dashboardStore.isLoading,
          ),
        ],
      ),
    );
  }
}

class _RestBody extends StatelessWidget {
  const _RestBody({
    super.key,
    required bool loading,
    required double topPadding,
    required ScrollController scrollController,
  })  : _topPadding = topPadding,
        _loading = loading,
        _scrollController = scrollController;

  final double _topPadding;
  final ScrollController _scrollController;
  final bool _loading;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: 500.milliseconds,
      left: 0,
      right: 0,
      bottom: 0,
      top: _topPadding,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(DEFAULT_RADIUS * 2),
          topRight: Radius.circular(DEFAULT_RADIUS * 2),
        ),
        child: Container(
          decoration: BoxDecoration(
              color: context.scaffoldBackgroundColor,
              border: Border(
                  top: BorderSide(
                      color: getTheme(context).colorScheme.secondary,
                      width: DEFAULT_RADIUS))),
          child: AnimatedScrollView(
            fadeInConfiguration: FadeInConfiguration(
                delay: 100.microseconds,
                duration: 100.milliseconds,
                curve: Curves.fastOutSlowIn),
            listAnimationType: ListAnimationType.FadeIn,
            padding: EdgeInsets.zero,
            controller: _scrollController,
            disposeScrollController: false,
            children: [
              height10(),
              _countList(context),

              ///dummy container
              titleLargeText('My Wallets', context).paddingAll(DEFAULT_PADDING),
              _walletList(context, loading: _loading),

              ///Last 10 Trade Lists
              height10(),
              Row(
                children: [
                  titleLargeText('Last 10 Trades', context).paddingOnly(
                      left: DEFAULT_PADDING, right: DEFAULT_PADDING),
                  const Spacer(),
                  bodyMedText('View All', context,
                          style: boldTextStyle(color: context.primaryColor))
                      .paddingOnly(right: DEFAULT_PADDING)
                      .onTap(() => context.push(Paths.tradeList('all', null))),
                ],
              ),
              height10(),
              ..._last10Trades(context, loading: _loading),
              height50(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _last10Trades(BuildContext context, {required bool loading}) {
    List<Trade> trades = dashboardStore.tradeList;
    return trades.isNotEmpty
        ? trades.take(10).indexed.map((e) {
            Trade trade = e.$2;
            return TradeCard(
              loading: loading,
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
            );
          }).toList()
        : [
            SizedBox(
              height: context.height() * 0.2,
              child: Center(
                child: bodyMedText('No Trade Found', context),
              ),
            )
          ];
  }

  Widget _walletList(BuildContext context, {required bool loading}) {
    return Container(
      height: context.height() * 0.15,
      margin: const EdgeInsets.only(left: 0, right: 0),
      child: ListView(
        padding: const EdgeInsets.only(left: DEFAULT_PADDING),
        scrollDirection: Axis.horizontal,
        children: [
          ...dashboardStore.walletList.indexed.map((e) {
            Wallet wallet = e.$2;
            return WalletCard(
              loading: loading,
              title: wallet.crypto?.name ?? '',
              subTitle: wallet.crypto?.code ?? '',
              amount: wallet.balance.convertDouble(8),
              image: wallet.crypto?.imageUrl ?? '',
              onTap: () => context.push(
                Paths.walletDetails(
                  wallet.crypto?.code ?? '',
                  title: wallet.crypto?.name ?? '',
                  address: wallet.walletAddress ?? '',
                  bal: wallet.balance.convertDouble(8).toString(),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Container _countList(BuildContext context) {
    return Container(
      height: context.height() * 0.1,
      constraints: const BoxConstraints(minHeight: 120),
      child: ListView(
        padding: const EdgeInsets.only(right: DEFAULT_PADDING),
        scrollDirection: Axis.horizontal,
        children: [
          ///trade count card
          _countCard(context, 'Trade\nCount', dashboardStore.totalTrade,
              MyPng.icDocument, Colors.pink,
              onTap: () {}),

          ///Running Trades
          _countCard(context, 'Running\nTrades', dashboardStore.runningTrade,
              FontAwesomeIcons.solidCircleCheck, runningColor,
              onTap: () {}),

          ///Completed Trades
          _countCard(
              context,
              'Completed\nTrades',
              dashboardStore.completedTrade,
              FontAwesomeIcons.sellsy,
              Colors.greenAccent.shade700,
              onTap: () {}),

          ///Complete Trades
          _countCard(context, 'Total\nReferral', dashboardStore.totalReferral,
              FontAwesomeIcons.users, Colors.cyanAccent.shade700,
              onTap: () {}),
        ],
      ),
    );
  }

  Widget _countCard(BuildContext context, String title, dynamic value,
      dynamic icon, Color color,
      {void Function()? onTap}) {
    return Stack(
      children: [
        Container(
          constraints: const BoxConstraints(minWidth: 120),
          decoration: BoxDecoration(
            color: context.dividerColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(DEFAULT_RADIUS),
          ),
          margin: const EdgeInsets.only(left: DEFAULT_PADDING, right: 0),
          padding: const EdgeInsets.all(DEFAULT_PADDING / 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              titleLargeText(title, context, textAlign: TextAlign.center),
              bodyMedText(value.toString(), context),
            ],
          ),
        ).onTap(onTap),

        ///icon
        Positioned(
          bottom: DEFAULT_PADDING / 2,
          right: DEFAULT_PADDING / 2,
          height: DEFAULT_PADDING * 2,
          width: DEFAULT_PADDING * 2,
          child: icon is String
              ? assetImages(icon, color: color)
              : icon is IconData
                  ? FaIcon(icon, color: color)
                  : Container(),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({super.key, required this.setDefaultHight});
  final Function(double h) setDefaultHight;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: context.height() * 0.4,
      child: Container(
          decoration: BoxDecoration(
            // color: context.primaryColor,
            gradient: appBarGradient(context),
          ),
          constraints: BoxConstraints(maxWidth: context.width()),
          child: Column(
            children: [
              SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  // color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: defaultBoxShadow(),
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                ),
                                child: CircleAvatar(
                                  radius: DEFAULT_PADDING,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: Image.network(
                                    'https://www.ihna.edu.au/blog/wp-content/uploads/2022/10/user-dummy.png',
                                    fit: BoxFit.cover,
                                  ).image,
                                  onBackgroundImageError: (e, s) {
                                    // logger.i('error: $e', tag: 'profile home');
                                    // logger.i('stack: $s', tag: 'profile home');
                                  },
                                ).onTap(() {
                                  dashboardScaffoldKey.currentState
                                      ?.openDrawer();
                                }),
                              ),
                              width10(),
                              bodyLargeText(
                                  'Hi, ${appStore.userFullName}', context,
                                  color: Colors.white),
                            ],
                          ),
                          height10(context.height() * 0.02),

                          ///description
                          titleLargeText(
                              'Trade Cryptos Seamlessly: Commission-Free, Peer-to-Peer, Your Marketplace.t',
                              context,
                              color: Colors.white),
                          height10(),
                          capText(
                              MyDateUtils.formatDate(
                                  DateTime.now(), 'dd-MMMM yyyy hh:mm a'),
                              context,
                              color: Colors.white70),
                        ],
                      ).paddingOnly(
                          left: DEFAULT_PADDING, right: DEFAULT_PADDING),
                    ),

                    ///image file
                    width10(),
                    Expanded(
                        flex: 1,
                        child: assetImages(MyPng.referandearn).onTap(() {
                          AuthService().login('email', 'password');
                        })),
                  ],
                ).paddingOnly(top: DEFAULT_PADDING),
              ),
            ],
          )),
    );
  }
}
