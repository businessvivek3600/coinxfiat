import 'package:coinxfiat/component/component_index.dart';
import 'package:coinxfiat/utils/utils_index.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../constants/constants_index.dart';
import '../../../routes/route_index.dart';

class WalletFragment extends StatefulWidget {
  const WalletFragment({super.key});

  @override
  State<WalletFragment> createState() => _WalletFragmentState();
}

class _WalletFragmentState extends State<WalletFragment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Wallet'),
          centerTitle: true,
          elevation: 0,
        ),
        body: Column(
          children: [
            ///Wallets
            _walletList(context),

            ///buy and sell
            const Expanded(child: _BuySellHistory()),
          ],
        ));
  }

  Widget _walletList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 10.height,
        // Text('Wallets', style: boldTextStyle(size: 20, color: Colors.grey))
        //     .paddingLeft(DEFAULT_PADDING),
        Container(
          height: context.height() * 0.15,
          margin:
              const EdgeInsets.only(left: 0, right: 0, top: DEFAULT_PADDING),
          child: ListView(
            padding: const EdgeInsets.only(left: DEFAULT_PADDING),
            scrollDirection: Axis.horizontal,
            children: [
              ///Bitcoin
              WalletCard(
                title: 'Bitcoin',
                subTitle: 'BTC',
                amount: '0.0000978738',
                image: MyPng.coinDummy,
                onTap: () => context.pushNamed(
                  Routes.walletDetails,
                  queryParameters: {'title': 'Bitcoin', 'subTitle': 'BTC'},
                ),
              ),

              ///Ethereum
              WalletCard(
                title: 'Ethereum',
                subTitle: 'ETH',
                amount: '38468320000',
                image: MyPng.coinDummy,
                onTap: () => context.pushNamed(
                  Routes.walletDetails,
                  queryParameters: {'title': 'Ethereum', 'subTitle': 'ETH'},
                ),
              ),

              ///Tether
              WalletCard(
                title: 'Tether',
                subTitle: 'USDT',
                amount: '3572.000',
                image: MyPng.coinDummy,
                onTap: () => context.pushNamed(
                  Routes.walletDetails,
                  queryParameters: {'title': 'Tether', 'subTitle': 'USDT'},
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BuySellHistory extends StatefulWidget {
  const _BuySellHistory();

  @override
  State<_BuySellHistory> createState() => _BuySellHistoryState();
}

class _BuySellHistoryState extends State<_BuySellHistory>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCoinType = 'All';
  bool loading = false;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_tabControllerListener);
    super.initState();
    afterBuildCreated(() {});
  }

  _tabControllerListener() async {
    setState(() => loading = true);
    3
        .seconds
        .delay
        .then((value) => setState(() => loading = false))
        .catchError((e) => log(e.toString()));
  }

  _onCoinTypeSelected(String coinType) async {
    loading = true;
    setState(() => _selectedCoinType = coinType);
    3
        .seconds
        .delay
        .then((value) => setState(() => loading = false))
        .catchError((e) => log(e.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        10.height,

        ///tab bar
        Row(
          children: [
            Container(
              constraints: const BoxConstraints(maxHeight: 40, maxWidth: 200),
              decoration: boxDecorationWithRoundedCorners(
                borderRadius: BorderRadius.circular(DEFAULT_RADIUS),
                backgroundColor: Colors.grey.withOpacity(0.2),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                indicatorPadding: const EdgeInsets.all(DEFAULT_PADDING / 3),
                indicatorSize: TabBarIndicatorSize.tab,
                splashBorderRadius: BorderRadius.circular(DEFAULT_RADIUS),
                tabs: [
                  Tab(child: Text('Buy', style: boldTextStyle())),
                  Tab(child: Text('Sell', style: boldTextStyle())),
                ],
              ),
            ).paddingOnly(
                left: DEFAULT_PADDING,
                right: DEFAULT_PADDING,
                top: DEFAULT_PADDING),

            ///filter
            const Spacer(),
            Container(
              height: 40,
              width: 40,
              decoration: boxDecorationWithRoundedCorners(
                borderRadius: BorderRadius.circular(10),
                backgroundColor: Colors.grey.withOpacity(0.2),
              ),
              child: Center(
                  child: Badge(
                isLabelVisible: isFilter,
                child: const Icon(Icons.filter_list),
              )),
            )
                .paddingOnly(
                    left: DEFAULT_PADDING,
                    right: DEFAULT_PADDING,
                    top: DEFAULT_PADDING)
                .onTap(() => _showFilter(context)),
          ],
        ),

        /// wallet chips
        Container(
          height: 40,
          margin: const EdgeInsets.only(
              left: DEFAULT_PADDING, right: DEFAULT_PADDING, top: 10),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ...[
                'All',
                'Bitcoin',
                'Ethereum',
                'Tether',
              ].map(
                (e) {
                  String? image = MyPng.coinDummy;
                  bool isSelected = _selectedCoinType == e;

                  return Chip(
                    label: Text(e, style: boldTextStyle()),
                    avatar: SizedBox(
                        width: 20,
                        height: 20,
                        child: assetImages(MyPng.coinDummy)),
                    backgroundColor: !isSelected
                        ? Colors.grey.withOpacity(0.2)
                        : Colors.blue.withOpacity(0.2),
                    labelPadding: const EdgeInsets.only(left: 10, right: 10),
                    padding: const EdgeInsets.all(0),
                    labelStyle: boldTextStyle(),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  )
                      .onTap(() => _onCoinTypeSelected(e),
                          borderRadius: BorderRadius.circular(100))
                      .paddingOnly(right: DEFAULT_PADDING / 2);
                },
              ),
            ],
          ),
        ),

        _buildAppliedFilterChips(context),

        ///tab bar view
        Expanded(
          child: loading
              ? const Center(child: CircularProgressIndicator.adaptive())
              : TabBarView(
                  controller: _tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    _BuyTradeList(typeIndex: 1),
                    _BuyTradeList(typeIndex: 0),
                  ],
                ),
        ),
      ],
    );
  }

  final usernameQuery = 'ad_filter_username_or_email';
  final cryptoCurrency = 'ad_filter_crypto_currency';
  final fiatCurrency = 'ad_filter_fiat_currency';
  final startDateTimeKey = 'ad_filter_start_date';
  final endDateTimeKey = 'ad_filter_end_date';
  bool isFilter = false;
  bool nameFilter = false;
  bool cryptoFilter = false;
  bool fiatFilter = false;
  Map<FilterItem, dynamic> appliedFilter = {};

  applyFilter(bool val, Map<FilterItem, dynamic> data) {
    isFilter = val;
    appliedFilter = data;
    logger.w('Filter Data',
        error: data.entries
            .map((e) =>
                '\n${e.key.tag} ${e.key.initialValue.runtimeType} : ${_getFilterValueByKey(e.key.tag)}')
            .toList(),
        tag: 'ad_filter');
    _checkFilter();
  }

  dynamic _getFilterValueByKey(String tag) {
    bool contains = appliedFilter.keys
        .any((element) => element.tag == tag && element.initialValue != null);
    if (contains) {
      final value = appliedFilter.keys
          .firstWhere((element) => element.tag == tag)
          .initialValue;
      switch (value.runtimeType) {
        case DateTime:
          print('datetime $tag ${value.runtimeType}');
          return value;
        case FilterDataQuery:
          return value.value;
        case FilterDataRadioItem:
          return value;
        case FilterDataMultiChoice:
          return value.value.join(',');
        case String:
          return (value as String).validate();
        default:
          return value.toString();
      }
    }
    return null;
  }

  _checkFilter() {
    nameFilter = _hasValue(usernameQuery, ['', null]);
    cryptoFilter = _hasValue(cryptoCurrency, null);
    fiatFilter = _hasValue(fiatCurrency, null);
    isFilter = nameFilter || cryptoFilter || fiatFilter;
    setState(() {});
  }

  _clearFilterByKey(String tag) {
    appliedFilter.keys
        .where((element) => element.tag == tag)
        .toList()
        .forEach((element) {
      if (element.tag == usernameQuery) {
        element.initialValue = '';
      } else if (element.tag == cryptoCurrency) {
        element.initialValue = null;
      } else if (element.tag == fiatCurrency) {
        element.initialValue = null;
      } else if (element.tag == startDateTimeKey) {
        element.initialValue = null;
      } else if (element.tag == endDateTimeKey) {
        element.initialValue = null;
      }
    });
    _checkFilter();
  }

  _hasValue(String tag, [dynamic defaultValue]) {
    bool contains = appliedFilter.keys.any((element) => element.tag == tag);
    if (contains) {
      FilterItem item =
          appliedFilter.keys.firstWhere((element) => element.tag == tag);
      if (tag == usernameQuery) {
        //   print('query ${item.initialValue.runtimeType}');
        //   bool has = item.initialValue != null &&
        //       item.initialValue.toString().isNotEmpty;
        //   print('has $has');
        return item.initialValue != null &&
            item.initialValue.toString().isNotEmpty;
      } else if (tag == cryptoCurrency) {
        return item.initialValue != null;
      } else if (tag == fiatCurrency) {
        return item.initialValue != null;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  AnimatedCrossFade _buildAppliedFilterChips(BuildContext context) {
    return AnimatedCrossFade(
      crossFadeState:
          isFilter ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      firstCurve: Curves.fastLinearToSlowEaseIn,
      secondCurve: Curves.fastLinearToSlowEaseIn,
      duration: const Duration(milliseconds: 500),
      secondChild: const SizedBox(),
      firstChild: SizedBox(
        height: nameFilter || cryptoFilter || fiatFilter ? 50 : 0,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            ///Currency Code
            if (nameFilter)
              FilterChipItem(
                tag: usernameQuery,
                label: capText(
                    _getFilterValueByKey(usernameQuery).toString().validate(),
                    context,
                    color: Colors.white),
                subtitle: 'Currency Code',
                icon: const FaIcon(FontAwesomeIcons.moneyBill,
                    size: 15, color: Colors.white),
                color: Colors.grey.shade500,
                textColor: Colors.white,
                onTap: () => _showFilter(context, launchFrom: usernameQuery),
                onClear: (tag) => _clearFilterByKey(tag),
              ).paddingOnly(left: DEFAULT_PADDING),

            /// type sell|buy
            if (cryptoFilter && _getFilterValueByKey(cryptoCurrency) != null)
              FilterChipItem(
                tag: cryptoCurrency,
                label: capText(
                    _getFilterValueByKey(cryptoCurrency)!
                        .label
                        .toString()
                        .validate(),
                    context,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                subtitle: 'Type',
                icon: const FaIcon(FontAwesomeIcons.sellsy,
                    size: 15, color: Colors.white),
                color: sellColor,
                textColor: Colors.white,
                onTap: () => _showFilter(context, launchFrom: cryptoCurrency),
                onClear: (tag) => _clearFilterByKey(tag),
              ).paddingOnly(left: DEFAULT_PADDING),

            ///status enable|disable
            if (fiatFilter && _getFilterValueByKey(fiatCurrency) != null)
              FilterChipItem(
                tag: fiatCurrency,
                label: capText(
                    _getFilterValueByKey(fiatCurrency)
                        .label
                        .toString()
                        .validate(),
                    context,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                subtitle: 'Status',
                icon: const FaIcon(FontAwesomeIcons.toggleOn,
                    size: 15, color: Colors.white),
                color: runningColor,
                onTap: () => _showFilter(context, launchFrom: fiatCurrency),
                onClear: (tag) => _clearFilterByKey(tag),
              ).paddingOnly(left: DEFAULT_PADDING),

            if (_getFilterValueByKey(startDateTimeKey) != null)
              FilterChipItem(
                tag: startDateTimeKey,
                label: capText(
                    MyDateUtils.formatDateAsToday(
                        _getFilterValueByKey(startDateTimeKey)
                            .toString()
                            .validate()),
                    context,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                subtitle: 'Start Date',
                icon: const FaIcon(FontAwesomeIcons.calendarDays,
                    size: 15, color: Colors.white),
                color: Colors.blue,
                textColor: Colors.white,
                onTap: () => _showFilter(context, launchFrom: startDateTimeKey),
                onClear: (tag) => _clearFilterByKey(tag),
              ).paddingOnly(left: DEFAULT_PADDING),

            if (_getFilterValueByKey(endDateTimeKey) != null)
              FilterChipItem(
                tag: endDateTimeKey,
                label: capText(
                    MyDateUtils.formatDateAsToday(
                        _getFilterValueByKey(endDateTimeKey)
                            .toString()
                            .validate()),
                    context,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                subtitle: 'End Date',
                icon: const FaIcon(FontAwesomeIcons.calendarDays,
                    size: 15, color: Colors.white),
                color: Colors.blue,
                textColor: Colors.white,
                onTap: () => _showFilter(context, launchFrom: endDateTimeKey),
                onClear: (tag) => _clearFilterByKey(tag),
              ).paddingOnly(left: DEFAULT_PADDING),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _showFilter(BuildContext context, {String? launchFrom}) {
    List<FilterDataRadioItem> cryptos = [
      /// ETH, BTC, USDT(TRC20)
      FilterDataRadioItem(
          key: 'ad_filter_crypto_eth',
          label: 'ETH',
          icon: const FaIcon(FontAwesomeIcons.ethereum,
              size: 15, color: Colors.white)),
      FilterDataRadioItem(
          key: 'ad_filter_crypto_btc',
          label: 'BTC',
          icon: const FaIcon(FontAwesomeIcons.bitcoin,
              size: 15, color: Colors.white)),
      FilterDataRadioItem(
          key: 'ad_filter_crypto_usdt',
          label: 'USDT(TRC20)',
          icon: const FaIcon(FontAwesomeIcons.dollarSign,
              size: 15, color: Colors.white)),
    ];

    List<FilterDataRadioItem> fiats = [
      /// USD, INR, NGN
      FilterDataRadioItem(
          key: 'ad_filter_fiat_usd',
          label: 'USD',
          icon: const FaIcon(FontAwesomeIcons.dollarSign,
              size: 15, color: Colors.white)),
      FilterDataRadioItem(
          key: 'ad_filter_fiat_inr',
          label: 'INR',
          icon: const FaIcon(FontAwesomeIcons.rupeeSign,
              size: 15, color: Colors.white)),
      FilterDataRadioItem(
          key: 'ad_filter_fiat_ngn',
          label: 'NGN',
          icon: const FaIcon(FontAwesomeIcons.moneyBill,
              size: 15, color: Colors.white)),
    ];

    ///dummy filter item
    List<FilterItem> filterItem = [
      ///currency code
      FilterItem(
        tag: usernameQuery,
        label: 'Username',
        subtitle: 'Or email',
        icon:
            const FaIcon(FontAwesomeIcons.user, size: 15, color: Colors.white),
        color: Colors.blue,
        textColor: Colors.white,
        type: FilterType.query,
        initialValue: _getFilterValueByKey(usernameQuery),
      ),

      ///crypto currency
      FilterItem(
        tag: cryptoCurrency,
        label: 'Crypto Currency',
        subtitle: 'ETH, BTC...',
        icon: const FaIcon(FontAwesomeIcons.sellsy,
            size: 15, color: Colors.white),
        color: sellColor,
        textColor: Colors.white,
        type: FilterType.radio,
        initialValue: _getFilterValueByKey(cryptoCurrency),
      ),

      ///fiat currency
      FilterItem(
        tag: fiatCurrency,
        label: 'Fiat Currency',
        subtitle: 'USD, INR...',
        icon: const FaIcon(FontAwesomeIcons.toggleOn,
            size: 15, color: Colors.white),
        color: runningColor,
        textColor: Colors.white,
        type: FilterType.radio,
        initialValue: _getFilterValueByKey(fiatCurrency),
      ),
/*
      FilterItem(
        tag: startDateTimeKey,
        label: "Start Date",
        subtitle: 'The start date of the advertisement',
        icon: const FaIcon(FontAwesomeIcons.calendarDays,
            size: 15, color: Colors.white),
        color: Colors.blue,
        textColor: Colors.white,
        type: FilterType.date,
        initialValue: _getFilterValueByKey(startDateTimeKey),
      ),
      FilterItem(
        tag: endDateTimeKey,
        label: "End Date",
        subtitle: 'The end date of the advertisement',
        icon: const FaIcon(FontAwesomeIcons.calendarDays,
            size: 15, color: Colors.white),
        color: Colors.blue,
        textColor: Colors.white,
        type: FilterType.date,
        initialValue: _getFilterValueByKey(endDateTimeKey),
      ),
      */
    ];

    ///dummy filter data for each filter item and type withsame tag
    List<FilterData> filterData = [
      ///query1
      FilterDataQuery(query: usernameQuery, tag: usernameQuery, value: 'ABC'),

      ///type
      FilterDataRadio(key: cryptoCurrency, tag: cryptoCurrency, value: cryptos),

      ///status

      FilterDataRadio(key: fiatCurrency, tag: fiatCurrency, value: fiats),
      /*
      //date

      FilterDateData(
        key: startDateTimeKey,
        tag: 'ad_filter_start_date',
        title: 'Start Date',
        value: DateTime.now().subtract(const Duration(days: 5)),
      ),
      FilterDateData(
        key: endDateTimeKey,
        tag: 'ad_filter_end_date',
        title: 'End Date',
        value: DateTime.now().subtract(const Duration(days: 1)),
      ),
      */
    ];

    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        backgroundColor: Colors.transparent,
        builder: (context) => BottomSheetFilter(
              key: const Key('ad_filter'),
              title: 'Wallet Filter',
              subTitle: 'Filter your wallet',
              topRadius: 10,
              topPadding: context.height() * 0.3,
              filterItem: filterItem,
              filterData: filterData,
              launchFrom: launchFrom,
              onApplyFilter: (val, data) async => applyFilter(val, data),
              onClearFilter: (val, data) async => applyFilter(val, data),
              onResetFilter: (val, data) async => applyFilter(val, data),
            ));
  }
}

class _BuyTradeList extends StatelessWidget {
  const _BuyTradeList({super.key, this.typeIndex = 0});
  final int typeIndex;

  @override
  Widget build(BuildContext context) {
    return AnimatedListView(
      listAnimationType: ListAnimationType.FadeIn,
      padding:
          const EdgeInsets.only(top: DEFAULT_PADDING, bottom: DEFAULT_PADDING),
      itemCount: 100,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Colors.grey.withOpacity(0.2)))),
          child: _TradeCard(
            typeIndex: typeIndex,
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
            requestedOn:
                DateTime.now().subtract(Duration(days: index)).toString(),
            onActionPressed: () {
              print('trade card pressed');
            },
          ),
        );
      },
      // separatorBuilder: (context, index) =>
      //     Divider(color: Colors.grey.withOpacity(0.2), thickness: 1, height: 0),
    );
  }
}

class _TradeCard extends StatelessWidget {
  final String? tradeNumber;
  final String? withUser;
  final String? type;
  final String? currency;
  final String? paymentMethod;
  final String? rate;
  final String? cryptoAmount;
  final String? status;
  final String? requestedOn;
  final VoidCallback? onActionPressed;
  final int typeIndex;

  const _TradeCard({
    super.key,
    this.tradeNumber,
    this.withUser,
    this.type,
    this.currency,
    this.paymentMethod,
    this.rate,
    this.cryptoAmount,
    this.status,
    this.requestedOn,
    this.onActionPressed,
    this.typeIndex = 1,
  });

  @override
  Widget build(BuildContext context) {
    int statusIndex = status.validate().toLowerCase() == 'pending'
        ? 0
        : status.validate().toLowerCase() == 'running'
            ? 1
            : 2;
    return Stack(
      children: [
        Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DEFAULT_RADIUS * 3),
          ),
          child: Padding(
            padding: const EdgeInsets.all(DEFAULT_PADDING),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // height10(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Badge(
                      alignment: Alignment.bottomRight,
                      smallSize: DEFAULT_PADDING / 2,
                      child: CircleAvatar(
                          radius: DEFAULT_PADDING,
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(
                              'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png')),
                    ),
                    width10(),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        bodyLargeText(withUser.validate(), context,
                            style: boldTextStyle()),
                        RichText(
                            text: TextSpan(
                          text: '4 Trades',
                          style: primaryTextStyle(
                              size: (LABEL_TEXT_SIZE * 0.8).toInt()),
                          children: const [
                            TextSpan(text: '  |  '),
                            TextSpan(text: 'Completion Rate:'),
                            TextSpan(
                                text: ' 75%',
                                style: TextStyle(color: waitingColor)),
                          ],
                        )),
                      ],
                    ),
                  ],
                ),
                height10(),

                ///payment method, rate
                Container(
                  decoration: BoxDecoration(
                      color: context.dividerColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(DEFAULT_RADIUS * 5)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: DEFAULT_PADDING,
                      vertical: DEFAULT_PADDING / 2),
                  child: Wrap(
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      const FaIcon(FontAwesomeIcons.buildingColumns,
                          size: LABEL_TEXT_SIZE * 0.7),
                      width10(),
                      bodyMedText(paymentMethod.validate(), context,
                          style: boldTextStyle(
                              size: (LABEL_TEXT_SIZE * 0.8).toInt())),
                      width10(),
                      const FaIcon(FontAwesomeIcons.chevronRight,
                          size: LABEL_TEXT_SIZE * 0.7),
                      width10(),
                      bodyMedText(rate.validate(), context,
                          style: boldTextStyle(
                              size: (LABEL_TEXT_SIZE * 0.8).toInt())),
                    ],
                  ),
                ),
                height10(),
                Wrap(
                  runAlignment: WrapAlignment.spaceBetween,
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    ///Trade amount
                    bodyLargeText(cryptoAmount.validate(), context,
                        style: boldTextStyle(color: context.primaryColor)),

                    ///Payment window
                    width10(),
                    bodyMedText('30 minutes', context,
                        style: boldTextStyle(color: context.accentColor)),
                  ],
                ),
              ],
            ),
          ),
        ),

        ///launch icon
        Positioned(
          top: DEFAULT_PADDING / 2,
          right: DEFAULT_PADDING,
          child: Container(
            decoration: BoxDecoration(
                color: (typeIndex == 1 ? completedColor : redColor)
                    .withOpacity(0.1),
                borderRadius: BorderRadius.circular(DEFAULT_RADIUS * 2)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const FaIcon(FontAwesomeIcons.sellcast,
                    size: LABEL_TEXT_SIZE * 0.9),
                10.width,
                bodyMedText(typeIndex == 0 ? 'Sell' : 'Buy', context,
                    style:
                        boldTextStyle(size: (LABEL_TEXT_SIZE * 0.8).toInt())),
              ],
            )
                .paddingSymmetric(
                    horizontal: DEFAULT_PADDING / 2,
                    vertical: DEFAULT_PADDING / 3)
                .onTap(() {
              context.push(Paths.buySell(
                  typeIndex == 1 ? 'buy' : 'sell', tradeNumber.validate()));
            }),
          ),
        ),
      ],
    ).onTap(onActionPressed);
  }
}
