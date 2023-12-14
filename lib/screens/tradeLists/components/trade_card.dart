import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../constants/constants_index.dart';
import '../../../routes/route_index.dart';
import '../../../utils/utils_index.dart';

class TradeCard extends StatelessWidget {
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
  final bool useDivider;

  const TradeCard({
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
    this.useDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    int statusIndex = status.validate().toLowerCase() == 'pending'
        ? 0
        : status.validate().toLowerCase() == 'running'
            ? 1
            : 2;
    int typeIndex = type.validate().toLowerCase() == 'buy' ? 0 : 1;
    return Stack(
      children: [
        Container(
          decoration: useDivider
              ? BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.grey.withOpacity(0.2))))
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
              side: useDivider
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
                        color: context.dividerColor.withOpacity(0.2),
                        borderRadius:
                            BorderRadius.circular(DEFAULT_RADIUS * 5)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: DEFAULT_PADDING,
                        vertical: DEFAULT_PADDING / 2),
                    child: Wrap(
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        const FaIcon(FontAwesomeIcons.buildingColumns,
                            size: LABEL_TEXT_SIZE * 0.9),
                        width10(),
                        bodyMedText(paymentMethod.validate(), context,
                            style: boldTextStyle()),
                        width10(),
                        const FaIcon(FontAwesomeIcons.chevronRight,
                            size: LABEL_TEXT_SIZE * 0.9),
                        width10(),
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
                          capText(status.validate(), context,
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
                        child: bodyLargeText(cryptoAmount.validate(), context,
                            style: boldTextStyle(color: context.primaryColor)),
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
        Positioned(
          top: DEFAULT_PADDING / 2,
          right: DEFAULT_PADDING,
          child: const FaIcon(FontAwesomeIcons.arrowUpRightFromSquare,
                  size: LABEL_TEXT_SIZE * 0.9)
              .paddingAll(DEFAULT_PADDING)
              .onTap(() {
            context.push(Paths.tradeDetails(tradeNumber.validate()));
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
    ).onTap(onActionPressed);
  }
}
