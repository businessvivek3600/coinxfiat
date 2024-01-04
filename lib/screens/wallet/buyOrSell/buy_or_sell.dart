import 'package:coinxfiat/utils/utils_index.dart';
import 'package:coinxfiat/widgets/widget_index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../component/component_index.dart';
import '../../../constants/constants_index.dart';
import '../../../model/model_index.dart';
import '../../../routes/route_index.dart';
import '../../../services/service_index.dart';
import '../../screen_index.dart';

class BuyOrSellRequestPage extends StatefulWidget {
  const BuyOrSellRequestPage(
      {super.key, required this.selling, this.requestId});
  final bool selling;
  final String? requestId;

  @override
  State<BuyOrSellRequestPage> createState() => _BuyOrSellRequestPageState();
}

class _BuyOrSellRequestPageState extends State<BuyOrSellRequestPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  ValueNotifier<bool> feedbackable = ValueNotifier<bool>(true);
  ValueNotifier<BuySellTrade> buySellTrade =
      ValueNotifier<BuySellTrade>(BuySellTrade());
  ValueNotifier<bool> loading = ValueNotifier<bool>(true);
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _getBuySellTrade();
  }

  Future<void> _getBuySellTrade() async {
    if (widget.requestId == null) {
      toast('Trade not found', bgColor: Colors.red, gravity: ToastGravity.TOP);
      return;
    }

    loading.value = true;
    final res = await Apis.getBuySellTradeRequestApi(
        widget.selling ? 'sell' : 'buy', widget.requestId!);
    if (res.$1) {
      buySellTrade.value = tryCatch<BuySellTrade>(
              () => BuySellTrade.fromJson(res.$2['advertisment'])) ??
          BuySellTrade();
      feedbackable.value =
          tryCatch<bool>(() => res.$2['feedbackable'] == 'true') ?? false;
    }
    loading.value = false;
  }

  _handleSheetMinimized(bool val) {
    if (val) {
      _tabController.animateTo(0);
      hideKeyboard(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: loading,
        builder: (context, loading, _) {
          return ValueListenableBuilder<BuySellTrade>(
              valueListenable: buySellTrade,
              builder: (context, buySellTrade, _) {
                return Scaffold(
                  // backgroundColor: Colors.black,
                  appBar: AppBar(
                      elevation: 0,
                      title: Text(
                          '${!widget.selling ? 'Buy' : 'Sell'} ${loading ? '' : buySellTrade.cryptoCurrency?.name.validate() ?? ''}'),
                      bottom: PreferredSize(
                          preferredSize: const Size.fromHeight(50),
                          child: Container(
                              color: context.primaryColor,
                              child: _Tabbar(
                                tabController: _tabController,
                                loading: loading,
                                buySellTrade: buySellTrade,
                              )))),
                  body: ListView(
                    clipBehavior: Clip.hardEdge,
                    // shrinkWrap: true,
                    children: [
                      _TabView(
                        tabController: _tabController,
                        loading: loading,
                        buySellTrade: buySellTrade,
                      ),
                      10.height,
                      _details(context,
                          loading: loading, buySellTrade: buySellTrade),
                      20.height,
                      // 10.height,
                      _feedbacks(context,
                          loading: loading,
                          feedbackable: feedbackable,
                          feedbacks: buySellTrade.feedbacks),
                    ],
                  ),
                  bottomSheet: _BuySellField(
                      selling: widget.selling,
                      onSheetChange: _handleSheetMinimized),
                );
              });
        });
  }

  Widget _feedbacks(
    BuildContext context, {
    required bool loading,
    required ValueNotifier<bool> feedbackable,
    required List<AdFeedback> feedbacks,
  }) {
    return ValueListenableBuilder<bool>(
        valueListenable: feedbackable,
        builder: (context, feedbackable, _) {
          return Container(
            padding: const EdgeInsets.all(DEFAULT_PADDING),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(DEFAULT_RADIUS),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Feedbacks on This Advertisement', style: boldTextStyle()),
                10.height,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AnimatedSwitcher(
                      duration: 700.milliseconds,
                      switchInCurve: Curves.easeIn,
                      layoutBuilder: (currentChild, previousChildren) =>
                          ScaleTransition(
                        scale: currentChild != null
                            ? const AlwaysStoppedAnimation(1)
                            : const AlwaysStoppedAnimation(0.9),
                        child: currentChild,
                      ),
                      transitionBuilder: (child, animation) => FadeTransition(
                        opacity: animation,
                        child: FadeTransition(
                          opacity: animation,
                          // sizeFactor: animation,
                          // position: Tween<Offset>(
                          //         begin: const Offset(1, 0), end: Offset.zero)
                          //     .animate(animation),
                          child: child,
                        ),
                      ),
                      child: [
                        _empty(context),
                        _list(feedbacks, loading),
                      ][feedbacks.isEmpty && !loading ? 0 : 1],
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  AnimatedListView _list(List<AdFeedback> feedbacks, bool loading) {
    return AnimatedListView(
      padding: const EdgeInsets.only(bottom: 60),
      itemCount: feedbacks.length,
      shrinkWrap: true,
      listAnimationType: ListAnimationType.FadeIn,
      itemBuilder: (context, index) {
        AdFeedback trade = feedbacks[index];
        bool last = index == feedbacks.length - 1;
        bool liked = trade.position.validate().toLowerCase().contains('like');
        return UserFeedBackCard(
          loading: loading,
          liked: liked,
          last: last,
          trade: trade,
        );
      },
    );
  }

  Column _empty(BuildContext context) {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(FontAwesomeIcons.solidCommentDots,
                color: Colors.grey, size: 15),
          ],
        ),
        5.height,
        Text('No feedback yet',
            style: secondaryTextStyle(
                color: isDarkMode(context) ? Colors.white : Colors.black)),
      ],
    );
  }

  Container _details(BuildContext context,
      {required bool loading, required BuySellTrade buySellTrade}) {
    return Container(
      padding: const EdgeInsets.all(DEFAULT_PADDING),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(DEFAULT_RADIUS),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Rate:', style: boldTextStyle()),
              Text(
                  '${loading ? '' : '${(buySellTrade.rate).convertDouble(8)} ${buySellTrade.fiatCurrency?.code ?? ''} / ${buySellTrade.cryptoCurrency?.code ?? ''}'} ',
                  style: boldTextStyle()),
            ],
          ),
          10.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Payment Method: ', style: boldTextStyle()),
              Expanded(
                child: Text(
                    buySellTrade.gateways
                        .map((e) => e.name)
                        .toList()
                        .join(' | ')
                        .validate(),
                    textAlign: TextAlign.end,
                    style: boldTextStyle(color: inProgressColor)),
              ),
            ],
          ),
          10.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Trade Limits:', style: boldTextStyle()),
              Text(
                  loading
                      ? ''
                      : '${buySellTrade.minimumLimit.convertDouble(8)} - ${buySellTrade.maximumLimit.convertDouble(0)} ${buySellTrade.fiatCurrency?.code ?? ''}',
                  style: boldTextStyle(color: context.primaryColor)),
            ],
          ),
          10.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Payment Window:', style: boldTextStyle()),
              Text(buySellTrade.paymentWindow?.name ?? '',
                  style: boldTextStyle()),
            ],
          ),
        ],
      ),
    );
  }
}

class _BuySellField extends StatelessWidget {
  _BuySellField({
    super.key,
    required this.selling,
    required this.onSheetChange,
  });

  final bool selling;
  final void Function(bool val) onSheetChange;
  final ValueNotifier<String> _selectedPaymentMethod =
      ValueNotifier<String>('');
  final ValueNotifier<String> _selectedAccount = ValueNotifier<String>('');

  @override
  Widget build(BuildContext context) {
    final List<Pair> paymentMethods = [
      ///bank transfer,paytm,google pay,phonepe,upi,imps,neft,rtgs,other
      Pair(key: 'bank_transfer', text: 'Bank Transfer'),
      Pair(key: 'cash_deposit', text: 'Cash Deposit'),
      Pair(key: 'upi', text: 'UPI'),
      Pair(key: 'paytm', text: 'Paytm'),
      Pair(key: 'google_pay', text: 'Google Pay'),
      Pair(key: 'phonepe', text: 'PhonePe'),
      Pair(key: 'imps', text: 'IMPS'),
      Pair(key: 'neft', text: 'NEFT'),
      Pair(key: 'rtgs', text: 'RTGS'),
      Pair(key: 'other', text: 'Other'),
    ];
    Map<String, List<Pair>> paymentAccounts = {
      'bank_transfer': [
        Pair(key: 'bank_1', text: 'Bank 1'),
        Pair(key: 'bank_2', text: 'Bank 2'),
        Pair(key: 'bank_3', text: 'Bank 3'),
      ],
      'cash_deposit': [
        Pair(key: 'cash_deposit_1', text: 'Cash Deposit 1'),
        Pair(key: 'cash_deposit_2', text: 'Cash Deposit 2'),
        Pair(key: 'cash_deposit_3', text: 'Cash Deposit 3'),
      ],
      'upi': [
        Pair(key: 'upi_1', text: 'UPI 1'),
        Pair(key: 'upi_2', text: 'UPI 2'),
        Pair(key: 'upi_3', text: 'UPI 3'),
      ],
      'paytm': [
        Pair(key: 'paytm_1', text: 'Paytm 1'),
        Pair(key: 'paytm_2', text: 'Paytm 2'),
        Pair(key: 'paytm_3', text: 'Paytm 3'),
      ],
      'google_pay': [
        Pair(key: 'google_pay_1', text: 'Google Pay 1'),
        Pair(key: 'google_pay_2', text: 'Google Pay 2'),
        Pair(key: 'google_pay_3', text: 'Google Pay 3'),
      ],
      'phonepe': [
        Pair(key: 'phonepe_1', text: 'PhonePe 1'),
        Pair(key: 'phonepe_2', text: 'PhonePe 2'),
        Pair(key: 'phonepe_3', text: 'PhonePe 3'),
      ],
      'imps': [
        Pair(key: 'imps_1', text: 'IMPS 1'),
        Pair(key: 'imps_2', text: 'IMPS 2'),
        Pair(key: 'imps_3', text: 'IMPS 3'),
      ],
      'neft': [
        Pair(key: 'neft_1', text: 'NEFT 1'),
        Pair(key: 'neft_2', text: 'NEFT 2'),
        Pair(key: 'neft_3', text: 'NEFT 3'),
      ],
      'rtgs': [
        Pair(key: 'rtgs_1', text: 'RTGS 1'),
        Pair(key: 'rtgs_2', text: 'RTGS 2'),
        Pair(key: 'rtgs_3', text: 'RTGS 3'),
      ],
      'other': [
        Pair(key: 'other_1', text: 'Other 1'),
        Pair(key: 'other_2', text: 'Other 2'),
        Pair(key: 'other_3', text: 'Other 3'),
      ],
    };
    return ValueListenableBuilder<String>(
        valueListenable: _selectedPaymentMethod,
        builder: (context, selectedPaymentMethod, child) {
          return ValueListenableBuilder<String>(
              valueListenable: _selectedAccount,
              builder: (context, selectedAccount, child) {
                return ControlledBottomSheet(
                    // sheetMinimized: _sheetMinimized,
                    minimizedHeight: 100,
                    maximizedHeight: selling ? 550 : 350,
                    listener: onSheetChange,
                    header: (_, notifier, val) => Text(
                        'How much you wish to buy?',
                        style: boldTextStyle()),
                    builder: (context, notifier, sheetMinimized) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(DEFAULT_PADDING),
                        physics: sheetMinimized
                            ? const NeverScrollableScrollPhysics()
                            : const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: CustomTextField(
                                  titleText: 'I Will Pay',
                                  hintText: '0.00',
                                  keyboardType: TextInputType.number,
                                  suffixIcon: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('USD', style: boldTextStyle()),
                                    ],
                                  ).paddingSymmetric(horizontal: 10),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d+\.?\d{0,}'))
                                  ],
                                )),
                                10.width,

                                ///
                                Expanded(
                                    child: CustomTextField(
                                  titleText: 'And Receive',
                                  hintText: '0.00',
                                  keyboardType: TextInputType.number,
                                  suffixIcon: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('USDT(TRC20)',
                                          style: boldTextStyle())
                                    ],
                                  ).paddingSymmetric(horizontal: 10),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d+\.?\d{0,}'))
                                  ],
                                )),
                              ],
                            ),
                            Text('Trade Minimum limit 1000 INR',
                                style:
                                    boldTextStyle(color: context.primaryColor)),
                            10.height,

                            ///if selling Select Payment Method
                            if (selling)
                              SearchRequestDropdown(
                                initialItems: paymentMethods,
                                onRequest: (query) async => paymentMethods
                                    .where((element) => element.text
                                        .toLowerCase()
                                        .contains(query.toLowerCase()))
                                    .toList(),
                                titleText: 'Select Payment Method',
                                hintText: 'Select Payment Method',
                                onChanged: (value) {
                                  _selectedPaymentMethod.value = value!.key;
                                  _selectedAccount.value = '';
                                },
                                sideWidget: IconButton.filled(
                                    color: context.primaryColor,
                                    onPressed: () => context
                                        .push(Paths.sellAddGateway('uuts')),
                                    icon: const FaIcon(FontAwesomeIcons.plus)),
                              ),
                            10.height,

                            ///if selling Select Information
                            if (selling)
                              SearchRequestDropdown(
                                initialItems: paymentAccounts[
                                        _selectedPaymentMethod.value] ??
                                    [],
                                onRequest: (query) async => 1
                                    .seconds
                                    .delay
                                    .then((value) => paymentMethods
                                        .where((element) => element.text
                                            .toLowerCase()
                                            .contains(query.toLowerCase()))
                                        .toList()),
                                titleText: 'Select Information',
                                hintText: 'Select Information',
                              ),
                            10.height,

                            const CustomTextField(
                              hintText:
                                  'Write your contact message and other info for the trade here',
                              maxLines: 3,
                              textInputAction: TextInputAction.newline,
                              keyboardType: TextInputType.multiline,
                            ),
                            10.height,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: ElevatedButton(
                                  onPressed: () {},
                                  child: Text('Send Trade Request',
                                      style: boldTextStyle(color: whiteColor)),
                                )),
                              ],
                            ),
                          ],
                        ),
                      ).onTap(() => hideKeyboard(context));
                    });
              });
        });
  }
}

class _Tabbar extends StatelessWidget {
  const _Tabbar({
    required TabController tabController,
    required this.loading,
    required this.buySellTrade,
  }) : _tabController = tabController;

  final TabController _tabController;
  final bool loading;
  final BuySellTrade buySellTrade;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: _tabController,
      indicatorColor: whiteColor,
      labelColor: Colors.white,
      unselectedLabelColor: whiteColor.withOpacity(0.5),
      labelStyle: boldTextStyle(),
      indicator: ArrowDownTabBarIndicator(color: context.primaryColor),
      tabs: [
        Tab(
          icon: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(
                  child: Text('Offered by ', textAlign: TextAlign.center)),
              5.width,
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 10,
                child: netImages(
                  buySellTrade.user?.imgPath ?? '',
                  placeholder: MyPng.dummyUser,
                ),
              ),
            ],
          ),
        ),
        const Tab(text: 'Terms of trade'),
        const Tab(text: 'Payment details'),
      ],
    );
  }
}

class _TabView extends StatefulWidget {
  const _TabView({
    required TabController tabController,
    required this.loading,
    required this.buySellTrade,
  }) : _tabController = tabController;
  final TabController _tabController;
  final bool loading;
  final BuySellTrade buySellTrade;
  @override
  State<_TabView> createState() => _TabViewState();
}

class _TabViewState extends State<_TabView> {
  int _selectedIndex = 0;
  set selectedIndex(int index) => setState(() => _selectedIndex = index);
  @override
  void initState() {
    super.initState();
    afterBuildCreated(
        () => widget._tabController.addListener(_handleTabSelection));
  }

  @override
  dispose() {
    widget._tabController.removeListener(_handleTabSelection);
    super.dispose();
  }

  void _handleTabSelection() =>
      setState(() => _selectedIndex = widget._tabController.index);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedSwitcher(
          duration: 700.milliseconds,
          switchInCurve: Curves.easeIn,
          layoutBuilder: (currentChild, previousChildren) => ScaleTransition(
            scale: currentChild != null
                ? const AlwaysStoppedAnimation(1)
                : const AlwaysStoppedAnimation(0.9),
            child: currentChild,
          ),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: getOffset(
                    _selectedIndex, widget._tabController.previousIndex),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          ),
          child: [
            _SellerInfo(
                buySellTrade: widget.buySellTrade, loading: widget.loading),
            Container(
                key: const ValueKey(1),
                constraints: const BoxConstraints(maxHeight: 300),
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(DEFAULT_PADDING),
                  children: [
                    htmlView(
                        context, widget.buySellTrade.termsOfTrade.validate())
                  ],
                )),
            Container(
                key: const ValueKey(2),
                constraints: const BoxConstraints(maxHeight: 300),
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(DEFAULT_PADDING),
                  children: [
                    htmlView(
                        context, widget.buySellTrade.paymentDetails.validate())
                  ],
                )),
          ][_selectedIndex],
        ),
      ],
    );
  }

  Offset getOffset(int index, int previousIndex) {
    if (index > previousIndex) {
      return const Offset(1, 0);
    } else if (index < previousIndex) {
      return const Offset(-1, 0);
    } else {
      return Offset.zero;
    }
  }
}

class _SellerInfo extends StatelessWidget {
  const _SellerInfo(
      {super.key, required this.buySellTrade, required this.loading});
  final BuySellTrade buySellTrade;
  final bool loading;

  ///verified icon check
  final FaIcon verifiedIcon =
      const FaIcon(FontAwesomeIcons.circleCheck, color: Colors.green, size: 15);

  ///not verified icon cross
  final FaIcon notVerifiedIcon =
      const FaIcon(FontAwesomeIcons.circleXmark, color: Colors.red, size: 15);
  @override
  Widget build(BuildContext context) {
    final Sender? user = buySellTrade.user;
    return Container(
      key: const ValueKey(0),
      padding: const EdgeInsets.all(DEFAULT_PADDING),
      decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///image and name, thumbs up and down
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              /// image
              Container(
                height: 50,
                width: 50,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: netImages(
                  'MyPng.dummyUser',
                  placeholder: MyPng.dummyUser,
                  fit: BoxFit.cover,
                ),
              ),
              10.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user?.fullName ?? '', style: boldTextStyle()),
                  10.height,
                  Row(
                    children: [
                      Row(
                        children: [
                          ///thumbs up
                          const FaIcon(FontAwesomeIcons.thumbsUp,
                              color: Colors.green, size: 15),
                          5.width,
                          Text(buySellTrade.likeCount.validate().toString(),
                              style: secondaryTextStyle(
                                  color: isDarkMode(context)
                                      ? Colors.white
                                      : Colors.black)),
                        ],
                      ),
                      10.width,
                      Row(
                        children: [
                          ///thumbs down
                          const FaIcon(FontAwesomeIcons.thumbsDown,
                              color: Colors.red, size: 15),
                          5.width,
                          Text(buySellTrade.dislikeCount.validate().toString(),
                              style: secondaryTextStyle(
                                  color: isDarkMode(context)
                                      ? Colors.white
                                      : Colors.black)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          /// (email verified,  Mobile Number Verified,Identity Verified , Address Verified) with green check mark if verified or red cross if not verified
          10.height,
          Builder(builder: (context) {
            return Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _verifiedInfo(
                    context, 'Email Verified', user?.emailVerification == 1,
                    loading: loading),
                5.height,
                _verifiedInfo(context, 'Mobile Number Verified',
                    user?.smsVerification == 1,
                    loading: loading),
                5.height,
                _verifiedInfo(
                    context, 'Identity Verified', user?.identityVerify == 0,
                    loading: loading),
                5.height,
                _verifiedInfo(
                    context, 'Address Verified', user?.addressVerify == 0,
                    loading: loading),
              ],
            );
          }),
          10.height,
        ],
      ),
    );
  }

  Widget _verifiedInfo(BuildContext context, String text, bool isVerified,
      {required bool loading}) {
    return Row(
      children: [
        loading
            ? const CupertinoActivityIndicator(radius: 5)
            : isVerified
                ? verifiedIcon
                : notVerifiedIcon,
        10.width,
        Text(text),
      ],
    );
  }
}
