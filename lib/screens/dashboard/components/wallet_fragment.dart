import 'package:coinxfiat/component/component_index.dart';
import 'package:coinxfiat/utils/utils_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../constants/constants_index.dart';
import '../../../model/model_index.dart';
import '../../../routes/route_index.dart';
import '../../../services/service_index.dart';
import '../../../store/store_index.dart';
import '../../screen_index.dart';

class WalletFragment extends StatefulWidget {
  const WalletFragment({super.key});

  @override
  State<WalletFragment> createState() => _WalletFragmentState();
}

class _WalletFragmentState extends State<WalletFragment> {
  ValueNotifier<List<Crypto>> newCryptoList = ValueNotifier([]);
  @override
  void initState() {
    super.initState();
    afterBuildCreated(() async {
      getWallets();
    });
  }

  Future<void> getWallets() async {
    await Apis.getWalletsApi().then((value) {
      p('wallets ${value}');
      newCryptoList.value = value.$1;
      if (value.$2.isNotEmpty) {
        dashboardStore.setWalletList(value.$2);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Scaffold(
          appBar: AppBar(
            title: const Text('Wallet'),
            centerTitle: true,
            elevation: 0,
            actions: [
              /// add wallet

              ValueListenableBuilder<List<Crypto>>(
                  valueListenable: newCryptoList,
                  builder: (_, cryptos, __) {
                    return IconButton(
                      onPressed: () =>
                          _showSelectCryptoDialog(context, cryptos),
                      icon: const FaIcon(FontAwesomeIcons.plus),
                    ).visible(cryptos.isNotEmpty);
                  }),
            ],
          ),
          body: Column(
            children: [
              ///Wallets
              if (dashboardStore.walletList.isNotEmpty)
                _walletList(context, dashboardStore.walletList)
              else
                const SizedBox(),

              ///buy and sell
              const Expanded(child: _BuySellHistory()),
            ],
          )),
    );
  }

  Widget _walletList(BuildContext context, List<Wallet> walletList) {
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
              ...walletList.indexed.map((e) {
                Wallet wallet = e.$2;
                return WalletCard(
                  loading: dashboardStore.isLoading,
                  title: wallet.crypto?.name ?? '',
                  subTitle: wallet.crypto?.code ?? '',
                  amount: wallet.balance.convertDouble(8),
                  image: wallet.crypto?.imageUrl ?? '',
                  onTap: () => context.push(
                    Paths.walletDetails(
                      // null,
                      wallet.crypto?.code,
                      title: wallet.crypto?.name ?? '',
                      address: wallet.walletAddress ?? '',
                      bal: wallet.balance.validate().toString(),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }

  void _showSelectCryptoDialog(BuildContext context, List<Crypto> cryptos) {
    showDialog(
      context: context,
      builder: (context) =>
          _SelectWalletDialogWidget(cryptos: cryptos, onSuccess: getWallets),
    );
  }
}

class _SelectWalletDialogWidget extends StatelessWidget {
  _SelectWalletDialogWidget({required this.cryptos, this.onSuccess});
  final List<Crypto> cryptos;
  final ValueNotifier<Crypto?> selectedCrypto = ValueNotifier(null);
  final Future<dynamic> Function()? onSuccess;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Wallet'),
      content: ValueListenableBuilder<Crypto?>(
          valueListenable: selectedCrypto,
          builder: (_, crypto, __) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  runSpacing: DEFAULT_PADDING,
                  spacing: DEFAULT_PADDING,
                  children: [
                    ...cryptos.map((e) {
                      bool isSelected = crypto?.id == e.id;
                      return Container(
                        width: 100,
                        padding: const EdgeInsets.all(DEFAULT_PADDING / 2),
                        decoration: boxDecorationWithRoundedCorners(
                          borderRadius: BorderRadius.circular(DEFAULT_RADIUS),
                          backgroundColor: Colors.grey.withOpacity(0.1),
                          border: isSelected
                              ? Border.all(
                                  color: Colors.blue.withOpacity(0.5), width: 2)
                              : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            netImages(
                              e.imageUrl.validate(),
                              placeholder: MyPng.coinDummy,
                              fit: BoxFit.cover,
                              width: 40,
                              height: 40,
                            ),
                            Text(e.name.validate(),
                                style: boldTextStyle(size: 12),
                                textAlign: TextAlign.center),
                          ],
                        ),
                      ).onTap(() => selectedCrypto.value = e);
                    }).toList(),
                  ],
                ),
                Text('Please select a wallet to add',
                        style: secondaryTextStyle())
                    .paddingTop(DEFAULT_PADDING / 2)
                    .visible(crypto == null),
                height20(),
                Row(
                  children: [
                    DynamicButton.outline(
                      text: 'Cancel',
                      onPressed: () => Navigator.pop(context),
                    ).expand(),
                    width10(),
                    DynamicButton(
                      text: 'Add Wallet',
                      onPressed: crypto == null
                          ? null
                          : () async {
                              appStore.setLoading(true);
                              await Apis.addWalletApi(id: crypto.id.toString())
                                  // await 3.seconds.delay
                                  .then((value) async {
                                appStore.setLoading(false);
                                if (value.$1) {
                                  await onSuccess?.call().then((_) {
                                    Navigator.pop(context);
                                    toast(
                                        value.$3 ?? 'Wallet added successfully',
                                        bgColor: Colors.green,
                                        gravity: ToastGravity.TOP);
                                  });
                                }
                              });
                            },
                    ),
                  ],
                ),
              ],
            );
          }),
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
  List<BuySellTrade> buySellTrades = [];
  List<Crypto> cryptos = [];
  List<Crypto> fiats = [];
  List<Gateways> gateways = [];

  bool loading = true;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_tabControllerListener);
    super.initState();
    afterBuildCreated(() {
      buySellTradesApi().then((value) => setState(() => loading = false));
    });
  }

  Future<void> buySellTradesApi() async {
    await Apis.buySellTradesApi(
      type: _tabController.index == 0 ? 'buy' : 'sell',
      cryptoId: (cryptos
                  .firstWhere((element) => element.name == _selectedCoinType,
                      orElse: () => Crypto(id: null, name: 'All'))
                  .id ??
              '')
          .toString(),
      username: _getFilterValueByKey(usernameQuery).toString().validate(),
      fiat: ((_getFilterValueByKey(fiatCurrency)?.key ?? '') as String)
          .split('$fiatCurrency/')
          .last,
      paymentMethod:
          ((_getFilterValueByKey(paymentMethod)?.key ?? '') as String)
              .split('$paymentMethod/')
              .last,
    ).then((value) {
      /// list
      tryCatch(() {
        ///list
        buyselltradesFromApi(value.$2['lists']?['data'] ?? []);
        p('buySellTrades ${buySellTrades.length}');

        ///filter items
        cryptosFromApi(value.$2['cryptos'] ?? []);
        p('cryptos ${cryptos.length}');
        fiatsFromApi(value.$2['fiats'] ?? []);
        p('fiats ${fiats.length}');
        gatewaysFromApi(value.$2['gateways'] ?? []);
        p('gateways ${gateways.length}');
        log(' buySellTrades ${buySellTrades.length} cryptos ${cryptos.length} fiats ${fiats.length} gateways ${gateways.length}');
      }, 'buySellTradesApi');
    });
  }

  _tabControllerListener() async {
    if (_tabController.indexIsChanging) {
      _selectedCoinType = 'All';
      log('tab index ${_tabController.index}');
      setState(() => loading = true);
      applyFilter(false, {});
      await buySellTradesApi()
          .then((value) => setState(() => loading = false))
          .catchError((e) => log(e.toString()));
    }
  }

  _onCoinTypeSelected(int coinType) async {
    loading = true;
    setState(() => _selectedCoinType = cryptos
        .firstWhere(
          (element) => element.id == coinType,
          orElse: () => Crypto(id: null, name: 'All'),
        )
        .name
        .validate());
    buySellTradesApi()
        .then((value) => setState(() => loading = false))
        .catchError((e) => log(e.toString()));
  }

  @override
  void dispose() {
    _tabController.removeListener(_tabControllerListener);
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        10.height,

        ///tab bar
        _buildBuySellTabBar(context),

        /// wallet chips
        _buildCryptoChips(),

        _buildAppliedFilterChips(context),

        ///tab bar view
        Expanded(
          child: loading
              ? const Center(child: CircularProgressIndicator.adaptive())
              : TabBarView(
                  controller: _tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _BuyTradeList(
                        typeIndex: 1,
                        tradeList: buySellTrades,
                        loading: loading),
                    _BuyTradeList(
                        typeIndex: 0,
                        tradeList: buySellTrades,
                        loading: loading),
                  ],
                ),
        ),
      ],
    );
  }

  Row _buildBuySellTabBar(BuildContext context) {
    return Row(
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
                borderRadius: BorderRadius.circular(10), color: Colors.white),
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
                        child: const Icon(Icons.filter_list))))
            .paddingOnly(
                left: DEFAULT_PADDING,
                right: DEFAULT_PADDING,
                top: DEFAULT_PADDING)
            .onTap(() => _showFilter(context)),
      ],
    );
  }

  Container _buildCryptoChips() {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(
          left: DEFAULT_PADDING, right: DEFAULT_PADDING, top: 10),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ...cryptos.map(
            (e) {
              String image = e.imageUrl.validate();
              bool isSelected = _selectedCoinType == e.name;

              return Chip(
                label: Text(e.name.validate().capitalizeFirstLetter(),
                    style: boldTextStyle()),
                avatar: SizedBox(
                  // width: 20,
                  // height: 20,
                  child: netImages(image, placeholder: MyPng.coinDummy),
                ),
                backgroundColor: !isSelected
                    ? Colors.grey.withOpacity(0.2)
                    : Colors.blue.withOpacity(0.2),
                labelPadding: const EdgeInsets.only(left: 10, right: 10),
                padding: const EdgeInsets.all(0),
                labelStyle: boldTextStyle(),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              )
                  .onTap(() => _onCoinTypeSelected(e.id.validate()),
                      borderRadius: BorderRadius.circular(100))
                  .paddingOnly(right: DEFAULT_PADDING / 2);
            },
          ),
        ],
      ),
    );
  }

  buyselltradesFromApi(List<dynamic> data) {
    buySellTrades.clear();
    tryCatch(() => buySellTrades =
        data.map<BuySellTrade>((e) => BuySellTrade.fromJson(e)).toList());
  }

  cryptosFromApi(List<dynamic> data) => tryCatch(() =>
      cryptos = data.map<Crypto>((e) => Crypto.fromJson(e)).toList()
        ..insert(0, Crypto(id: null, name: 'All')));

  fiatsFromApi(List<dynamic> data) => tryCatch(
      () => fiats = data.map<Crypto>((e) => Crypto.fromJson(e)).toList());

  gatewaysFromApi(List<dynamic> data) => tryCatch(() =>
      gateways = data.map<Gateways>((e) => Gateways.fromJson(e)).toList());

  final usernameQuery = 'ad_filter_username_or_email';
  final cryptoCurrency = 'ad_filter_crypto_currency';
  final fiatCurrency = 'ad_filter_fiat_currency';
  final paymentMethod = 'ad_filter_payment_method';
  final startDateTimeKey = 'ad_filter_start_date';
  final endDateTimeKey = 'ad_filter_end_date';
  bool isFilter = false;
  bool nameFilter = false;
  bool cryptoFilter = false;
  bool fiatFilter = false;
  bool paymentMethodFilter = false;
  Map<FilterItem, dynamic> appliedFilter = {};

  applyFilter(bool val, Map<FilterItem, dynamic> data) {
    isFilter = val;
    appliedFilter = data;
    logger.w('Filter Data',
        error: data.entries
            .map((e) =>
                '\n${e.key.tag} ${e.key.initialValue.runtimeType} : ${_getFilterValueByKey(e.key.tag)}')
            .toList(),
        tag: 'BuySellHistory ad_filter');
    setState(() => loading = true);
    buySellTradesApi()
        .then((value) => setState(() => loading = false))
        .catchError((e) => log(e.toString()));
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
          p('datetime $tag ${value.runtimeType}');
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
    paymentMethodFilter = _hasValue(paymentMethod, null);
    isFilter = nameFilter || fiatFilter || paymentMethodFilter;
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
      } else if (element.tag == paymentMethod) {
        element.initialValue = null;
      } else if (element.tag == startDateTimeKey) {
        element.initialValue = null;
      } else if (element.tag == endDateTimeKey) {
        element.initialValue = null;
      }
    });
    applyFilter(true, appliedFilter);
  }

  _hasValue(String tag, [dynamic defaultValue]) {
    bool contains = appliedFilter.keys.any((element) => element.tag == tag);
    p('hasValue $tag $contains');
    if (contains) {
      FilterItem item =
          appliedFilter.keys.firstWhere((element) => element.tag == tag);
      if (tag == usernameQuery) {
        //   p('query ${item.initialValue.runtimeType}');
        //   bool has = item.initialValue != null &&
        //       item.initialValue.toString().isNotEmpty;
        //   p('has $has');
        return item.initialValue != null &&
            item.initialValue.toString().isNotEmpty;
      } else if (tag == cryptoCurrency) {
        return item.initialValue != null;
      } else if (tag == fiatCurrency) {
        return item.initialValue != null;
      } else if (tag == paymentMethod) {
        return item.initialValue != null;
      } else if (tag == startDateTimeKey) {
        return item.initialValue != null;
      } else if (tag == endDateTimeKey) {
        return item.initialValue != null;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  AnimatedCrossFade _buildAppliedFilterChips(BuildContext context) {
    p('isFilter $isFilter');
    p('paymentMethodFilter ${paymentMethodFilter && _getFilterValueByKey(paymentMethod) != null}');
    return AnimatedCrossFade(
      crossFadeState:
          isFilter ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      firstCurve: Curves.fastLinearToSlowEaseIn,
      secondCurve: Curves.fastLinearToSlowEaseIn,
      duration: const Duration(milliseconds: 500),
      secondChild: const SizedBox(),
      firstChild: SizedBox(
        height: nameFilter ||
                //  cryptoFilter
                paymentMethodFilter ||
                fiatFilter
            ? 50
            : 0,
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

            /// type crypto currency
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

            ///status fiat currency
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

            ///payment method
            if (paymentMethodFilter &&
                _getFilterValueByKey(paymentMethod) != null)
              FilterChipItem(
                tag: paymentMethod,
                label: capText(
                    _getFilterValueByKey(paymentMethod)
                        .label
                        .toString()
                        .validate(),
                    context,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                subtitle: 'Payment Method',
                icon: const FaIcon(FontAwesomeIcons.moneyBill,
                    size: 15, color: Colors.white),
                color: Colors.grey.shade500,
                textColor: Colors.white,
                onTap: () => _showFilter(context, launchFrom: paymentMethod),
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
    List<FilterDataRadioItem> cryptoItems = [
      /// ETH, BTC, USDT(TRC20)
      ...cryptos.map((e) => FilterDataRadioItem(
          key: '$cryptoCurrency/${e.id ?? ""}',
          label: e.name.validate(),
          icon: netImages(e.imageUrl.validate(),
              placeholder: MyPng.paypalLogo, width: 15, color: Colors.white))),
    ];

    List<FilterDataRadioItem> fiatItems = [
      ...fiats.map((e) => FilterDataRadioItem(
          key: '$fiatCurrency/${e.id ?? ""}',
          label: e.name.validate(),
          icon: netImages(e.imageUrl.validate(),
              placeholder: MyPng.paypalLogo, width: 15, color: Colors.white))),
    ];

    ///payment methods
    List<FilterDataRadioItem> paymentMethods = [
      ...gateways.map((e) => FilterDataRadioItem(
          key: '$paymentMethod/${e.id ?? ''}',
          label: e.name.validate(),
          icon: netImages(e.imageUrl.validate(),
              placeholder: MyPng.paypalLogo, width: 15, color: Colors.white))),
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

      ///payment method
      FilterItem(
        tag: paymentMethod,
        label: 'Payment Method',
        subtitle: 'UPI, Bank Transfer...',
        icon: const FaIcon(FontAwesomeIcons.moneyBill,
            size: 15, color: Colors.white),
        color: Colors.grey.shade500,
        textColor: Colors.white,
        type: FilterType.multiChoice,
        initialValue: _getFilterValueByKey(paymentMethod),
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

      // ///crypto currency
      // FilterDataRadio(key: cryptoCurrency, tag: cryptoCurrency, value: cryptos),

      ///fiat currency
      FilterDataRadio(key: fiatCurrency, tag: fiatCurrency, value: fiatItems),

      ///payment method
      FilterDataRadio(
          key: paymentMethod, tag: paymentMethod, value: paymentMethods),
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
      ),
    );
  }
}

class _BuyTradeList extends StatelessWidget {
  const _BuyTradeList(
      {this.typeIndex = 0, required this.tradeList, required this.loading});
  final int typeIndex;
  final List<BuySellTrade> tradeList;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return AnimatedListView(
      listAnimationType: ListAnimationType.FadeIn,
      padding:
          const EdgeInsets.only(top: DEFAULT_PADDING, bottom: DEFAULT_PADDING),
      itemCount: tradeList.length,
      itemBuilder: (context, index) {
        BuySellTrade trade = tradeList[index];
        return Container(
          decoration: BoxDecoration(
              border: index >= tradeList.length - 1
                  ? null
                  : Border(
                      bottom: BorderSide(color: Colors.grey.withOpacity(0.2)))),
          child: _TradeCard(
            loading: loading,
            typeIndex: typeIndex,
            tradeNumber: trade.id.validate().toString(),
            withUser: trade.user?.username.validate(),
            type: typeIndex == 0 ? 'Buy' : 'Sell',
            currency: trade.fiatCurrency?.code.validate(),
            paymentMethods: trade.gateways,
            rate:
                '${(trade.rate).convertDouble(8)} ${trade.fiatCurrency?.code ?? ''} / ${trade.cryptoCurrency?.code ?? ''}',
            status: trade.status,
            totalTrades: trade.user?.totalTrade ?? 0,
            completedTrade: trade.user?.completedTrade ?? 0,
            requestedOn: trade.createdAt,
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
  final List<Gateways> paymentMethods;
  final int? paymentWindow;
  final int totalTrades;
  final int completedTrade;
  final String? rate;
  final int? status;
  final String? requestedOn;
  final VoidCallback? onActionPressed;
  final int typeIndex;
  final bool loading;

  const _TradeCard({
    this.loading = false,
    this.tradeNumber,
    this.withUser,
    this.type,
    this.currency,
    this.paymentMethods = const [],
    this.rate,
    this.status,
    this.requestedOn,
    this.onActionPressed,
    this.typeIndex = 1,
    this.paymentWindow,
    this.totalTrades = 0,
    this.completedTrade = 0,
  });

  @override
  Widget build(BuildContext context) {
    int statusIndex = status ?? 0;
    return Skeletonizer(
      enabled: loading,
      child: Stack(
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
                        backgroundColor: Colors.green,
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
                            text: '$totalTrades Trades',
                            style: primaryTextStyle(
                                size: (LABEL_TEXT_SIZE * 0.8).toInt()),
                            children: [
                              const TextSpan(text: '  |  '),
                              const TextSpan(text: 'Completion Rate:'),
                              TextSpan(
                                  text:
                                      ' ${((completedTrade / totalTrades) * 100).convertDouble(1)}%',
                                  style: const TextStyle(color: waitingColor)),
                            ],
                          )),
                        ],
                      ),
                    ],
                  ),
                  height10(),
                  if (paymentMethods.isNotEmpty)
                    getPaymentMethods(
                            paymentMethods: paymentMethods, loading: false)
                        .paddingBottom(DEFAULT_PADDING / 2),

                  ///payment method, rate

                  Container(
                    decoration: BoxDecoration(
                        color: context.dividerColor.withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(DEFAULT_RADIUS * 5)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: DEFAULT_PADDING,
                        vertical: DEFAULT_PADDING / 2),
                    child: Wrap(
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        bodyMedText(rate.validate(), context,
                            style: boldTextStyle()),
                      ],
                    ),
                  ),
                  height10(),
                  Wrap(
                    runAlignment: WrapAlignment.spaceBetween,
                    alignment: WrapAlignment.spaceBetween,
                    children: [
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
      ).onTap(onActionPressed?.call),
    );
  }
}
