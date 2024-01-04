import 'package:coinxfiat/screens/enums/enum_index.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../constants/constants_index.dart';
import '../../../model/model_index.dart';
import '../../../routes/route_index.dart';
import '../../../utils/utils_index.dart';

class TradeCard extends StatelessWidget {
  final String? tradeNumber;
  final String? withUser;
  final String? type;
  final String? currency;
  final List<Gateways> paymentMethods;
  final String? rate;
  final String? cryptoAmount;
  final int? status;
  final String? requestedOn;
  final VoidCallback? onActionPressed;
  final bool useDivider;
  final int totalTrades;
  final int completedTrade;
  final String? hashSlug;
  final bool loading;
  final bool isActive;
  final bool isLast;

  const TradeCard({
    super.key,
    this.isActive = false,
    this.loading = false,
    this.hashSlug,
    this.tradeNumber,
    this.withUser,
    this.type,
    this.currency,
    this.paymentMethods = const [],
    this.rate,
    this.cryptoAmount,
    this.status,
    this.requestedOn,
    this.onActionPressed,
    this.useDivider = false,
    this.totalTrades = 0,
    this.completedTrade = 0,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    int statusIndex = status ?? 0;

    // status.validate().toLowerCase() == 'pending'
    //     ? 0
    //     : status.validate().toLowerCase() == 'running'
    //         ? 1
    //         : 2;
    int typeIndex = type.validate().toLowerCase() == 'buy' ? 0 : 1;
    return Skeletonizer(
      textBoneBorderRadius: TextBoneBorderRadius(BorderRadius.circular(3)),
      enabled: loading,
      child: Stack(
        children: [
          Container(
            decoration: useDivider
                ? isLast
                    ? null
                    : BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.grey.withOpacity(0.2))))
                : null,
            child: Card(
              elevation: useDivider ? 0 : 2,
              margin: useDivider
                  ? null
                  : const EdgeInsets.only(
                      left: DEFAULT_PADDING,
                      right: DEFAULT_PADDING,
                      // top: DEFAULT_PADDING * 2,
                      bottom: DEFAULT_PADDING / 2,
                    ),
              shape: RoundedRectangleBorder(
                borderRadius: useDivider
                    ? BorderRadius.zero
                    : BorderRadius.circular(DEFAULT_RADIUS * 3),
                side: loading
                    ? BorderSide.none
                    : useDivider
                        ? BorderSide.none
                        : BorderSide(
                            color: statusIndex == 0
                                ? pendingColor.withOpacity(0.2)
                                : statusIndex == 1
                                    ? runningColor.withOpacity(0.2)
                                    : completedColor.withOpacity(0.2),
                            width: 2),
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
                        Badge(
                          isLabelVisible: isActive,
                          alignment: Alignment.bottomRight,
                          smallSize: DEFAULT_PADDING / 2,
                          backgroundColor: Colors.green,
                          child: CircleAvatar(
                              radius: DEFAULT_PADDING,
                              backgroundColor: Colors.transparent,
                              backgroundImage:
                                  assetImages(MyPng.dummyUser).image),
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
                                    style:
                                        const TextStyle(color: waitingColor)),
                              ],
                            )),
                          ],
                        ),
                      ],
                    ),
                    height10(),
                    if (paymentMethods.isNotEmpty)
                      getPaymentMethods(
                              paymentMethods: paymentMethods, loading: loading)
                          .paddingBottom(DEFAULT_PADDING / 2),

                    ///payment method, rate
                    Container(
                      width: loading ? 100 : null,
                      height: loading ? 20 : null,
                      decoration: BoxDecoration(
                          color: context.dividerColor.withOpacity(0.2),
                          borderRadius:
                              BorderRadius.circular(DEFAULT_RADIUS * 2)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: DEFAULT_PADDING,
                          vertical: DEFAULT_PADDING / 2),
                      child: Wrap(
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          // const FaIcon(FontAwesomeIcons.buildingColumns,
                          //     size: LABEL_TEXT_SIZE * 0.9),
                          // width10(),
                          // bodyMedText(paymentMethod.validate(), context,
                          //     style: boldTextStyle()),
                          // width10(),
                          // const FaIcon(FontAwesomeIcons.chevronRight,
                          //     size: LABEL_TEXT_SIZE * 0.9),
                          // width10(),
                          if (!loading)
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
                        ///trade number
                        bodyMedText(tradeNumber.validate(), context,
                            style: boldTextStyle(color: context.accentColor)),
                        width10(),

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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FaIcon(
                              statusIndex == 0
                                  ? FontAwesomeIcons.clock
                                  : statusIndex == 2
                                      ? FontAwesomeIcons.solidCircleCheck
                                      : FontAwesomeIcons.personRunning,
                              size: LABEL_TEXT_SIZE * 0.9,
                              color: statusIndex == 0
                                  ? pendingColor
                                  : statusIndex == 1
                                      ? runningColor
                                      : completedColor,
                            ),
                            width5(),
                            capText(
                                TradePaymentStatusExt.fromInt(statusIndex).name,
                                context,
                                fontWeight: FontWeight.bold),
                          ],
                        ),
                      ],
                    ),
                    height10(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: bodyLargeText(
                              loading ? '00000.00' : cryptoAmount.validate(),
                              context,
                              style:
                                  boldTextStyle(color: context.primaryColor)),
                        ),
                        width10(),

                        ///requested on
                        capText(
                            MyDateUtils.formatDateAsToday(
                                requestedOn.validate(), 'dd-MMMM yyyy'),
                            context),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          ///launch icon
          if (hashSlug != null && hashSlug!.isNotEmpty && !loading)
            Positioned(
              top: DEFAULT_PADDING / 2,
              right: DEFAULT_PADDING,
              child: const FaIcon(FontAwesomeIcons.arrowUpRightFromSquare,
                      size: LABEL_TEXT_SIZE * 0.9)
                  .paddingAll(DEFAULT_PADDING)
                  .onTap(() {
                context.push(Paths.tradeDetails(hashSlug.validate()));
              }),
            ),

          /// trade number, type, status
          /*
            Positioned(
              top: DEFAULT_PADDING,
              left: DEFAULT_PADDING,
              child: Container(
                decoration: BoxDecoration(
                    color: statusIndex == 0
                        ? Colors.orange.shade700
                        : statusIndex == 2
                            ? const Color.fromARGB(255, 189, 190, 191)
                            : Colors.green.shade700,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(DEFAULT_RADIUS * 5),
                        bottomRight: Radius.circular(DEFAULT_RADIUS * 5))),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: typeIndex == 1
                              ? const Color.fromARGB(255, 2, 226, 222)
                              : const Color.fromARGB(255, 242, 1, 1),
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(DEFAULT_RADIUS * 5),
                              bottomRight: Radius.circular(DEFAULT_RADIUS * 5))),
                      child: Row(
                        children: [
                          ///trade number
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: DEFAULT_PADDING * 2,
                                  vertical: DEFAULT_PADDING / 2),
                              decoration: BoxDecoration(
                                  color: context.accentColor,
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(DEFAULT_RADIUS * 5),
                                      bottomRight:
                                          Radius.circular(DEFAULT_RADIUS * 5))),
                              child: bodyLargeText(tradeNumber.validate(), context,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
      
                          ///type
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: DEFAULT_PADDING,
                                  vertical: DEFAULT_PADDING / 2),
                              margin: const EdgeInsets.only(right: DEFAULT_PADDING),
                              child: bodyMedText(type.validate(), context,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
      
                    ///status
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: DEFAULT_PADDING,
                          vertical: DEFAULT_PADDING / 2),
                      margin: const EdgeInsets.only(right: DEFAULT_PADDING),
                      child: bodyLargeText(status.validate(), context,
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          
          */
        ],
      )
      // .onTap(onActionPressed)
      ,
    );
  }
}

///get payment methods
Widget getPaymentMethods(
    {required List<Gateways> paymentMethods, bool loading = false}) {
  return Wrap(
    runSpacing: DEFAULT_PADDING / 2,
    spacing: DEFAULT_PADDING / 2,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      ...paymentMethods.map(
        (e) => Container(
          width: loading ? 100 : null,
          height: loading ? 25 : null,
          padding: const EdgeInsetsDirectional.only(
            start: DEFAULT_PADDING / 3,
            end: DEFAULT_PADDING / 3,
            top: DEFAULT_PADDING / 3,
            bottom: DEFAULT_PADDING / 3,
          ),
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(DEFAULT_RADIUS)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (e.imageUrl != null && e.imageUrl!.isNotEmpty && !loading)
                Image.network(
                  e.imageUrl.validate(),
                  height: DEFAULT_PADDING * 1,
                  width: DEFAULT_PADDING * 1,
                  frameBuilder:
                      (context, child, frame, wasSynchronouslyLoaded) {
                    if (wasSynchronouslyLoaded) return child;
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(DEFAULT_RADIUS * 5),
                      child: AnimatedOpacity(
                        opacity: frame == null ? 0 : 1,
                        duration: const Duration(seconds: 1),
                        curve: Curves.easeOut,
                        child: child,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.payment,
                    color: context.iconColor,
                    size: DEFAULT_PADDING,
                  ),
                ),
              if (e.imageUrl == null || e.imageUrl!.isNotEmpty) width5(),
              Text(e.name ?? '', style: primaryTextStyle(size: 11))
                  .visible(!loading),
            ],
          ),
        ),
      )
    ],
  );
}
