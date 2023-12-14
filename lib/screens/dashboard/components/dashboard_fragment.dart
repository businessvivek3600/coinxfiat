import 'package:coinxfiat/utils/utils_index.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../component/component_index.dart';
import '../../../constants/constants_index.dart';
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
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: context.scaffoldBackgroundColor),

        /// This is the main content
        _Header(setDefaultHight: (double hight) {}),

        /// This is the trade counts card list in horizontal
        _RestBody(
            topPadding:
                _topPadding >= kToolbarHeight ? _topPadding : kToolbarHeight,
            scrollController: _scrollController),
      ],
    );
  }
}

class _RestBody extends StatelessWidget {
  const _RestBody({
    super.key,
    required double topPadding,
    required ScrollController scrollController,
  })  : _topPadding = topPadding,
        _scrollController = scrollController;

  final double _topPadding;
  final ScrollController _scrollController;

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
            listAnimationType: ListAnimationType.FadeIn,
            padding: EdgeInsets.zero,
            controller: _scrollController,
            children: [
              height10(),
              _countList(context),

              ///dummy container
              titleLargeText('My Wallets', context).paddingAll(DEFAULT_PADDING),
              _walletList(context),

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
                      .onTap(() {}),
                ],
              ),
              height10(),
              ..._last10Trades(context),
              height50(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _last10Trades(BuildContext context) {
    return List.generate(
      10,
      (index) => TradeCard(
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
        requestedOn: DateTime.now().subtract(Duration(days: index)).toString(),
        onActionPressed: () {
          print('trade card pressed');
        },
      ),
    );
  }

  Widget _walletList(BuildContext context) {
    return Container(
      height: context.height() * 0.15,
      margin: const EdgeInsets.only(left: 0, right: 0),
      child: ListView(
        padding: const EdgeInsets.only(left: DEFAULT_PADDING),
        scrollDirection: Axis.horizontal,
        children: const [
          ///Bitcoin
          WalletCard(
            title: 'Bitcoin',
            subTitle: 'BTC',
            amount: '0.0000978738',
            image: MyPng.coinDummy,
          ),

          ///Ethereum
          WalletCard(
            title: 'Ethereum',
            subTitle: 'ETH',
            amount: '38468320000',
            image: MyPng.coinDummy,
          ),

          ///Tether
          WalletCard(
            title: 'Tether',
            subTitle: 'USDT',
            amount: '3572.000',
            image: MyPng.coinDummy,
          ),
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
          _countCard(
              context, 'Trade\nCount', '10', MyPng.icDocument, Colors.pink,
              onTap: () {}),

          ///Running Trades
          _countCard(context, 'Running\nTrades', '5',
              FontAwesomeIcons.solidCircleCheck, runningColor,
              onTap: () {}),

          ///Completed Trades
          _countCard(context, 'Completed\nTrades', '29',
              FontAwesomeIcons.sellsy, Colors.greenAccent.shade700,
              onTap: () {}),

          ///Complete Trades
          _countCard(context, 'Total\nReferral', '23', FontAwesomeIcons.users,
              Colors.cyanAccent.shade700,
              onTap: () {}),
        ],
      ),
    );
  }

  Widget _countCard(BuildContext context, String title, String value,
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
              bodyMedText(value, context),
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
                              CircleAvatar(
                                radius: DEFAULT_PADDING,
                                backgroundColor: Colors.transparent,
                                backgroundImage: const NetworkImage(
                                    'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png'),
                                onBackgroundImageError: (e, s) {
                                  logger.i('error: $e', tag: 'profile home');
                                  logger.i('stack: $s', tag: 'profile home');
                                },
                              ).onTap(() {
                                dashboardScaffoldKey.currentState?.openDrawer();
                              }),
                              width10(),
                              bodyLargeText('Hi, John Doe', context,
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
                          print('refer and earn tapped');
                        })),
                  ],
                ).paddingOnly(top: DEFAULT_PADDING),
              ),
            ],
          )),
    );
  }
}
