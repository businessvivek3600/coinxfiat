import 'package:coinxfiat/constants/constants_index.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../component/component_index.dart';
import '../../../model/model_index.dart';
import '../../../routes/route_index.dart';
import '../../../services/service_index.dart';
import '../../../store/store_index.dart';
import '../../../utils/utils_index.dart';
import '../../../widgets/widget_index.dart';
import '../../screen_index.dart';

class AdvertisementFragment extends StatefulWidget {
  const AdvertisementFragment({super.key});

  @override
  State<AdvertisementFragment> createState() => _AdvertisementFragmentState();
}

class _AdvertisementFragmentState extends State<AdvertisementFragment> {
  ValueNotifier<List<Advertisement>> advertisementList =
      ValueNotifier<List<Advertisement>>([]);
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(true);
  int currentPage = 1;
  int total = 0;
  bool hasMore = false;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      getAdvertisements(page: currentPage, isRefresh: true);
    });
  }

  Future<void> getAdvertisements({int page = 1, bool isRefresh = false}) async {
    isLoading.value = isRefresh;
    currentPage = page;
    await Apis.getAdvertisementsApi(
      page: currentPage,
      currencyCode: _getFilterValueByKey(queryKey).toString().validate(),
      type: ((_getFilterValueByKey(typeKey)?.key ?? '') as String)
          .split('$typeKey/')
          .last,
      status: ((_getFilterValueByKey(statusKey)?.key ?? '') as String)
          .split('$statusKey/')
          .last,
    ).then((value) {
      if (value.$1) {
        currentPage =
            tryCatch<int>(() => value.$2['advertises']['current_page']) ??
                currentPage;
        total = tryCatch<int>(() => value.$2['advertises']['total']) ?? total;
        List<Advertisement> list = tryCatch<List<Advertisement>>(() =>
                (value.$2['advertises']?['data'] ?? [])
                    .map<Advertisement>((e) => Advertisement.fromJson(e))
                    .toList()) ??
            [];
        if (isRefresh) {
          advertisementList.value = list;
        } else {
          advertisementList.value = [...advertisementList.value, ...list];
        }
        hasMore = advertisementList.value.length < total;
      }
      print('advertisementList ${advertisementList.value.length}');
    });
    isLoading.value = false;
  }

  Future<void> _createAd() async {
    var result = await context.push(Paths.createOrEditAd('create', null));
    pl('result $result');
    if (result != null && result is List) {
      Advertisement? ad = result[0];
      pl('new created or update ad is ad ${ad?.toJson()}');
      if (ad != null) {
        advertisementList.value = [ad, ...advertisementList.value];
      } else {
        getAdvertisements(isRefresh: true);
      }
    }
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: isLoading,
        builder: (_, isLoading, __) {
          return Scaffold(
              appBar: GradientAppBar(
                title: const Text('Advertisement'),
                actions: [
                  IconButton(
                      icon: Badge(
                          isLabelVisible: isFilter,
                          child:
                              assetImages(MyPng.icFilter, color: Colors.white)),
                      onPressed: () => _showFilter(context)),
                ],
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: _createAd,
                isExtended: true,
                icon: Text('Create', style: boldTextStyle(color: Colors.white)),
                label: const FaIcon(FontAwesomeIcons.rectangleAd),
              ),
              body: Column(
                children: [
                  ///chips filter
                  _buildAppliedFilterChips(context, isLoading),

                  ///list
                  Expanded(child: isLoading ? _emptyList() : _buildList())
                ],
              ));
        });
  }

  Widget _emptyList() {
    return AnimatedListView(
      itemCount: 10,
      itemBuilder: (_, index) => Skeletonizer(
        enabled: true,
        child: _TradeCard(
          loading: true,
          advertisementId: '-----------',
          type: '-----',
          currency: '------',
          paymentMethods:
              List.generate(3, (index) => Gateways(name: '----------')),
          rate: '------------',
          marginOrFixed: '----------',
          cryptoAmount: '---------',
          publishStatus: '---------',
          enabled: false,
          paymentWindow: '---------',
          requestedOn: '----------',
          onUpdate: (ad) async {},
        ),
      ),
    );
  }

  Widget _buildList() {
    return ValueListenableBuilder<List<Advertisement>>(
        valueListenable: advertisementList,
        builder: (_, list, __) {
          if (list.isEmpty) {
            return EmptyListWidget(
              message: isFilter
                  ? 'There are no advertisements\nwith the selected filter'
                  : 'There are no advertisements yet',
              width: 300,
              height: 300,
              refresh: () => getAdvertisements(isRefresh: true),
            ).paddingAll(DEFAULT_PADDING);
          }
          return AnimatedListView(
            onSwipeRefresh: () => getAdvertisements(isRefresh: true),
            onNextPage: !hasMore
                ? null
                : () => getAdvertisements(page: currentPage + 1),
            listAnimationType: ListAnimationType.FadeIn,
            padding: const EdgeInsets.only(bottom: 60),
            itemCount: list.length,
            itemBuilder: (context, index) {
              Advertisement item = list[index];
              bool last = index == list.length - 1;
              return Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: last
                            ? BorderSide.none
                            : BorderSide(color: Colors.grey.withOpacity(0.2)))),
                child: _TradeCard(
                  advertisementId: (item.id ?? '').toString(),
                  // withUser: item.us.validate(),
                  type: item.type.validate().toLowerCase() == 'buy'
                      ? 'Buy'
                      : 'Sell',
                  currency: item.fiatCurrency?.code.validate(),
                  paymentMethods: item.gateways ?? [],
                  rate:
                      '${item.rate.convertDouble(8)} ${item.fiatCurrency?.code.validate()} / '
                      '${item.cryptoCurrency?.code.validate()}',
                  marginOrFixed:
                      item.priceType.validate().capitalizeFirstLetter(),
                  cryptoAmount:
                      '${item.price.convertDouble(8)} ${item.fiatCurrency?.code.validate()}',
                  publishStatus: item.status == 1 ? 'Published' : 'Unpublished',
                  enabled: item.status == 1,
                  requestedOn: item.createdAt.validate(),
                  onActionPressed: () {},
                  onUpdate: (ad) async {
                    int index =
                        list.indexWhere((element) => element.id == ad.id);
                    if (index != -1) {
                      list[index] = ad;
                      advertisementList.value = list;
                      setState(() {});
                    }
                  },
                ),
              );
            },
            // separatorBuilder: (context, index) => Divider(
            //     color: Colors.grey.withOpacity(0.2), thickness: 1, height: 0),
          );
        });
  }

  final queryKey = 'ad_filter_currency_code';
  final typeKey = 'ad_filter_type';
  final statusKey = 'ad_filter_status';
  final startDateTimeKey = 'ad_filter_start_date';
  final endDateTimeKey = 'ad_filter_end_date';
  bool isFilter = false;
  bool queryFilter = false;
  bool typeFilter = false;
  bool statusFilter = false;
  Map<FilterItem, dynamic> appliedFilter = {};

  applyFilter(bool val, Map<FilterItem, dynamic> data) {
    isFilter = val;
    appliedFilter = data;
    logger.w('Filter Data',
        error: data.entries
            .map((e) =>
                '\n${e.key.tag} ${e.key.initialValue.runtimeType} : ${_getFilterValueByKey(e.key.tag)}')
            .toList(),
        tag: 'advertisement_filter');
    getAdvertisements(isRefresh: true).catchError((e) => log(e.toString()));
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
    queryFilter = _hasValue(queryKey, ['', null]);
    typeFilter = _hasValue(typeKey, null);
    statusFilter = _hasValue(statusKey, null);
    isFilter = queryFilter || typeFilter || statusFilter;
    setState(() {});
  }

  _clearFilterByKey(String tag) {
    appliedFilter.keys
        .where((element) => element.tag == tag)
        .toList()
        .forEach((element) {
      if (element.tag == queryKey) {
        element.initialValue = '';
      } else if (element.tag == typeKey) {
        element.initialValue = null;
      } else if (element.tag == statusKey) {
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
    if (contains) {
      FilterItem item =
          appliedFilter.keys.firstWhere((element) => element.tag == tag);
      if (tag == queryKey) {
        //   print('query ${item.initialValue.runtimeType}');
        //   bool has = item.initialValue != null &&
        //       item.initialValue.toString().isNotEmpty;
        //   print('has $has');
        return item.initialValue != null &&
            item.initialValue.toString().isNotEmpty;
      } else if (tag == typeKey) {
        return item.initialValue != null;
      } else if (tag == statusKey) {
        return item.initialValue != null;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  AnimatedCrossFade _buildAppliedFilterChips(
      BuildContext context, bool isLoading) {
    return AnimatedCrossFade(
      crossFadeState:
          isFilter ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      firstCurve: Curves.fastLinearToSlowEaseIn,
      secondCurve: Curves.fastLinearToSlowEaseIn,
      duration: const Duration(milliseconds: 500),
      secondChild: const SizedBox(),
      firstChild: SizedBox(
        height: queryFilter || typeFilter || statusFilter ? 50 : 0,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            ///Currency Code
            if (queryFilter)
              FilterChipItem(
                tag: queryKey,
                label: capText(
                    _getFilterValueByKey(queryKey).toString().validate(),
                    context,
                    color: Colors.white),
                subtitle: 'Currency Code',
                icon: const FaIcon(FontAwesomeIcons.moneyBill,
                    size: 15, color: Colors.white),
                color: Colors.grey.shade500,
                textColor: Colors.white,
                onTap: () => _showFilter(context, launchFrom: queryKey),
                onClear: (tag) => _clearFilterByKey(tag),
              ).paddingOnly(left: DEFAULT_PADDING),

            /// type sell|buy
            if (typeFilter && _getFilterValueByKey(typeKey) != null)
              FilterChipItem(
                tag: typeKey,
                label: capText(
                    _getFilterValueByKey(typeKey)!.label.toString().validate(),
                    context,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                subtitle: 'Type',
                icon: const FaIcon(FontAwesomeIcons.sellsy,
                    size: 15, color: Colors.white),
                color: sellColor,
                textColor: Colors.white,
                onTap: () => _showFilter(context, launchFrom: typeKey),
                onClear: (tag) => _clearFilterByKey(tag),
              ).paddingOnly(left: DEFAULT_PADDING),

            ///status enable|disable
            if (statusFilter && _getFilterValueByKey(statusKey) != null)
              FilterChipItem(
                tag: statusKey,
                label: capText(
                    _getFilterValueByKey(statusKey).label.toString().validate(),
                    context,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                subtitle: 'Status',
                icon: const FaIcon(FontAwesomeIcons.toggleOn,
                    size: 15, color: Colors.white),
                color: runningColor,
                onTap: () => _showFilter(context, launchFrom: statusKey),
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
    List<FilterDataRadioItem> types = [
      FilterDataRadioItem(
          key: '$typeKey/sell',
          label: 'Sell',
          icon: const FaIcon(FontAwesomeIcons.sellsy,
              size: 15, color: Colors.white)),
      FilterDataRadioItem(
          key: '$typeKey/buy',
          label: 'Buy',
          icon: const FaIcon(FontAwesomeIcons.cartShopping,
              size: 15, color: Colors.white)),
    ];

    List<FilterDataRadioItem> statuses = [
      FilterDataRadioItem(
          key: '$statusKey/1',
          label: 'Enable',
          icon: const FaIcon(FontAwesomeIcons.toggleOn,
              size: 15, color: Colors.white)),
      FilterDataRadioItem(
          key: '$statusKey/0',
          label: 'Disable',
          icon: const FaIcon(FontAwesomeIcons.toggleOff,
              size: 15, color: Colors.white)),
    ];

    ///dummy filter item
    List<FilterItem> filterItem = [
      ///currency code
      FilterItem(
        tag: queryKey,
        label: 'Currency Code',
        subtitle: 'Search By currency code',
        icon: const FaIcon(FontAwesomeIcons.moneyBill1,
            size: 15, color: Colors.white),
        color: Colors.blue,
        textColor: Colors.white,
        type: FilterType.query,
        initialValue: _getFilterValueByKey(queryKey),
      ),

      ///type
      FilterItem(
        tag: typeKey,
        label: 'Type',
        subtitle: 'Advertisement Type',
        icon: const FaIcon(FontAwesomeIcons.sellsy,
            size: 15, color: Colors.white),
        color: sellColor,
        textColor: Colors.white,
        type: FilterType.radio,
        initialValue: _getFilterValueByKey(typeKey),
      ),

      ///status
      FilterItem(
        tag: statusKey,
        label: 'Status',
        subtitle: 'Enable or Disable',
        icon: const FaIcon(FontAwesomeIcons.toggleOn,
            size: 15, color: Colors.white),
        color: runningColor,
        textColor: Colors.white,
        type: FilterType.radio,
        initialValue: _getFilterValueByKey(statusKey),
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
      ),*/
    ];

    ///dummy filter data for each filter item and type withsame tag
    List<FilterData> filterData = [
      ///query1
      FilterDataQuery(query: queryKey, tag: queryKey, value: ''),

      ///type
      FilterDataRadio(key: typeKey, tag: typeKey, value: types),

      ///status
      FilterDataRadio(key: statusKey, tag: statusKey, value: statuses),
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

      ///multi choice
      FilterDataMultiChoice(
          key: 'ad_filter_status',
          tag: 'ad_filter_status',
          value: FilterDataMultiChoice(
              key: 'ad_filter_status', value: ['enable', 'disable'])),
              */
    ];

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (context) => BottomSheetFilter(
        key: const Key('ad_filter'),
        title: 'Advertisement Filter',
        subTitle: 'Filter your advertisement',
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

class _TradeCard extends StatelessWidget {
  final String? advertisementId;
  final String? type;
  final String? marginOrFixed;
  final String? paymentWindow;
  final bool enabled;
  final String? currency;
  final List<Gateways> paymentMethods;
  final String? rate;
  final String? cryptoAmount;
  final String? publishStatus;
  final String? requestedOn;
  final VoidCallback? onActionPressed;
  final bool loading;
  final Future<dynamic> Function(Advertisement) onUpdate;

  const _TradeCard({
    this.advertisementId,
    this.type,
    this.marginOrFixed,
    this.paymentWindow,
    this.enabled = false,
    this.currency,
    this.paymentMethods = const [],
    this.rate,
    this.cryptoAmount,
    this.publishStatus,
    this.requestedOn,
    this.onActionPressed,
    this.loading = false,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    int statusIndex = publishStatus.validate().toLowerCase() == 'unpublished'
        ? 0
        : publishStatus.validate().toLowerCase() == 'published'
            ? 1
            : 2;
    int typeIndex = type.validate().toLowerCase() == 'buy' ? 0 : 1;

    return Stack(
      children: [
        Card(
          elevation: 0,
          margin: const EdgeInsets.only(
            left: 0,
            right: 0,
            // top: DEFAULT_PADDING * 2,
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DEFAULT_RADIUS * 3)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (paymentMethods.isNotEmpty)
                getPaymentMethods(
                        paymentMethods: paymentMethods, loading: loading)
                    .paddingBottom(DEFAULT_PADDING / 2),

              ///payment method, rate
              Container(
                decoration: BoxDecoration(
                    // color: context.dividerColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(DEFAULT_RADIUS * 5)),
                // padding: const EdgeInsets.symmetric(
                //     horizontal: DEFAULT_PADDING, vertical: DEFAULT_PADDING / 2),
                child: Wrap(
                  // mainAxisSize: MainAxisSize.min,
                  runSpacing: DEFAULT_PADDING,
                  spacing: DEFAULT_PADDING,
                  children: [
                    bodyMedText(rate.validate(), context,
                        style: boldTextStyle()),
                    //payment window
                    if (paymentWindow.validate().isNotEmpty)
                      capText(paymentWindow.validate(), context,
                          color: context.accentColor.withOpacity(0.8),
                          fontWeight: FontWeight.bold),
                  ],
                ),
              ),
              height10(),
              Wrap(
                runAlignment: WrapAlignment.spaceBetween,
                alignment: WrapAlignment.spaceBetween,
                children: [
                  ///type
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.sellsy,
                        size: LABEL_TEXT_SIZE * 0.9,
                        color: typeIndex == 1 ? sellColor : buyColor,
                      ),
                      width5(),
                      capText(type.validate(), context,
                          fontWeight: FontWeight.bold),
                    ],
                  ),

                  ///status
                  width10(),
                  if (statusIndex == 1)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FaIcon(
                          statusIndex == 0
                              ? FontAwesomeIcons.solidRectangleXmark
                              : statusIndex == 1
                                  ? FontAwesomeIcons.solidCircleCheck
                                  : FontAwesomeIcons.personRunning,
                          size: LABEL_TEXT_SIZE * 0.9,
                          color: statusIndex == 0
                              ? cancelledColor
                              : statusIndex == 1
                                  ? completedColor
                                  : appTextSecondaryColor,
                        ),
                        width5(),
                        capText(publishStatus.validate(), context,
                            fontWeight: FontWeight.bold),
                      ],
                    ),

                  ///enable/disable
                  width10(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FaIcon(
                        enabled
                            ? FontAwesomeIcons.toggleOn
                            : FontAwesomeIcons.toggleOff,
                        size: LABEL_TEXT_SIZE * 0.9,
                        color: enabled ? runningColor : appTextSecondaryColor,
                      ),
                      width5(),
                      capText(enabled ? 'Enabled' : 'Disabled', context,
                          fontWeight: FontWeight.bold),
                    ],
                  ),
                ],
              ),
              height10(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      bodyLargeText(marginOrFixed.validate(), context,
                          style: boldTextStyle(color: Colors.indigo)),
                      width5(),
                      const Icon(FontAwesomeIcons.solidCircle,
                          size: LABEL_TEXT_SIZE * 0.5, color: Colors.indigo),
                      width5(),
                      bodyLargeText(cryptoAmount.validate(), context,
                          style: boldTextStyle(
                              color: context.primaryColor
                                  .withOpacity(enabled ? 0.8 : 0.5))),
                    ],
                  )),
                  10.width,

                  ///requested on
                  capText(
                      MyDateUtils.formatDateAsToday(
                          requestedOn.validate(), 'dd-MMMM yyyy'),
                      context),
                ],
              ),
            ],
          ).paddingAll(DEFAULT_PADDING),
        ),

        ///more icon
        Positioned(
          top: DEFAULT_PADDING / 2,
          right: 0,
          child: PopupMenuButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(DEFAULT_RADIUS)),
            onSelected: (value) {
              switch (value) {
                case 'feedback':
                  context.push(Paths.feedback(advertisementId));
                  break;
                case 'edit':
                  context.push(Paths.createOrEditAd('edit', advertisementId));
                  break;
                case 'trade_list':
                  context.push(Paths.tradeList('all', advertisementId));
                  break;
                case 'enable/disable':
                  _confirmDisable(context,
                      enabled: enabled, advertisementId: advertisementId);
                  break;
                default:
              }
            },
            itemBuilder: (context) => [
              ///feedback, edit, trade list, disable
              PopupMenuItem(
                value: 'feedback',
                child: Row(
                  children: [
                    const FaIcon(FontAwesomeIcons.commentDots,
                        size: LABEL_TEXT_SIZE * 0.9, color: ratingBarColor),
                    width10(),
                    capText('Feedback', context),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    const FaIcon(FontAwesomeIcons.penToSquare,
                        size: LABEL_TEXT_SIZE * 0.9, color: verifyAcColor),
                    width10(),
                    capText('Edit', context),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'trade_list',
                child: Row(
                  children: [
                    const FaIcon(FontAwesomeIcons.list,
                        size: LABEL_TEXT_SIZE * 0.9, color: sellColor),
                    width10(),
                    capText('Trade List', context),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'enable/disable',
                child: Row(
                  children: [
                    FaIcon(
                        !enabled
                            ? FontAwesomeIcons.toggleOn
                            : FontAwesomeIcons.toggleOff,
                        size: LABEL_TEXT_SIZE * 0.9,
                        color: !enabled ? runningColor : appTextSecondaryColor),
                    width10(),
                    capText(!enabled ? 'Enable' : 'Disable', context),
                  ],
                ),
              ),
            ],
            child: const FaIcon(FontAwesomeIcons.ellipsisVertical,
                    size: LABEL_TEXT_SIZE * 0.9)
                .paddingAll(DEFAULT_PADDING),
          ),
        ),
      ],
    );
  }

  _confirmDisable(BuildContext context,
      {required bool enabled, required String? advertisementId}) {
    showGeneralDialog(
        context: context,
        pageBuilder: (_, a1, a2) => ShadowedDialog(
              title: enabled ? 'Disable Advertisement' : 'Enable Advertisement',
              message: enabled
                  ? 'Are you sure you want to disable this advertisement?'
                  : 'Are you sure you want to enable this advertisement?',
              confirmText: enabled ? 'Disable' : 'Enable',
              cancelText: 'Cancel',
              onConfirm: () async {
                appStore.setLoading(true);
                await Apis.enableAdvertisementApi(
                  !enabled,
                  advertisementId.validate(),
                ).then((value) async {
                  if (value.$1) {
                    Navigator.pop(context);
                    Advertisement? ad = tryCatch<Advertisement>(() =>
                        Advertisement.fromJson(
                            value.$2['data']['advertisement']));
                    if (ad != null) await onUpdate(ad);
                    toast(value.$3.validate(),
                        gravity: ToastGravity.TOP, bgColor: Colors.green);
                  }
                });
                appStore.setLoading(false);
              },
              onCancel: () async {},
            ));
  }
}
