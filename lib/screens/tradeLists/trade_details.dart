import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../component/component_index.dart';
import '../../constants/constants_index.dart';
import '../../utils/utils_index.dart';
import '../enums/enum_index.dart';

class TradeDetails extends StatefulWidget {
  const TradeDetails({super.key, this.id});
  final String? id;

  @override
  State<TradeDetails> createState() => _TradeDetailsState();
}

class _TradeDetailsState extends State<TradeDetails> {
  ///trade information
  final ValueNotifier<bool> _infoExpanded = ValueNotifier<bool>(false);

  ///terms of trade
  final ValueNotifier<bool> _termsExpanded = ValueNotifier<bool>(false);

  ///payment details
  final ValueNotifier<bool> _paymentExpanded = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trade Details'),
      ),
      body: AnimatedScrollView(
        children: [
          Container(
            width: context.width(),
            color: Colors.grey.withOpacity(0.1),
            padding: const EdgeInsets.all(DEFAULT_PADDING),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ///Trade Payment Status
                Row(
                  children: [
                    Expanded(
                        child: Text('#YCWKP6722XSN', style: boldTextStyle())),
                    10.width,
                    Text(TradePaymentStatusExt.fromInt(0).name,
                        style: boldTextStyle(
                            color: TradePaymentStatusExt.fromInt(0).color)),
                  ],
                ),
                10.height,

                /// accepted payment methods
                _paymentMethods(),
                10.height,

                ///note1
                Text('Please pay 1,100.00 INR using',
                    style: secondaryTextStyle(color: alertColor)),
                10.height,

                ///note2
                Text(
                    '0.1000 ETH will be added to your wallet after confirmation about the payment.',
                    style: secondaryTextStyle()),
                20.height,
                Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: rejectedColor,
                      ),
                      onPressed: () {},
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )),
                    10.width,
                    Expanded(
                        child: ElevatedButton(
                            onPressed: () {},
                            child: const Text(
                              'I have Paid',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ))),
                  ],
                ),
              ],
            ),
          ),
          10.height,
          Container(
            width: context.width(),
            color: Colors.grey.withOpacity(0.1),
            padding: const EdgeInsets.all(DEFAULT_PADDING),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///trade information
                _DefaultExpantionTile(
                  infoExpanded: _infoExpanded,
                  title: 'Trade Information',
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Buyer', style: primaryTextStyle()),
                        10.width,
                        Expanded(
                          child: Text('SumitSharma',
                              style: boldTextStyle(),
                              textAlign: TextAlign.right),
                        ),
                      ],
                    ),
                    10.height,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Rate', style: primaryTextStyle()),
                        10.width,
                        Expanded(
                          child: Text('11,000.00 INR /ETH',
                              style: boldTextStyle(),
                              textAlign: TextAlign.right),
                        ),
                      ],
                    ),
                    10.height,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Indian Rupee', style: primaryTextStyle()),
                        10.width,
                        Expanded(
                          child: Text('1,100.00 INR',
                              style: boldTextStyle(),
                              textAlign: TextAlign.right),
                        ),
                      ],
                    ),
                    10.height,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ethereum', style: primaryTextStyle()),
                        10.width,
                        Expanded(
                          child: Text('0.1000 ETH',
                              style: boldTextStyle(),
                              textAlign: TextAlign.right),
                        ),
                      ],
                    ),
                    10.height,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Payment Window', style: primaryTextStyle()),
                        10.width,
                        Expanded(
                          child: Text('45 minutes',
                              style: boldTextStyle(),
                              textAlign: TextAlign.right),
                        ),
                      ],
                    ),
                  ],
                ),
                10.height,
                Text('#Instructions to be followed', style: boldTextStyle()),
                10.height,
                Text(
                    '1. Please make payment within the payment window. If you fail to make payment within the payment window, the trade will be cancelled automatically.',
                    style: secondaryTextStyle()),
                10.height,
                Text(
                    '2. After making payment, please click on the "I have paid" button and wait for the seller to confirm the payment.',
                    style: secondaryTextStyle()),
                10.height,
                Text(
                    '3. After the seller confirms the payment, the cryptocurrency will be released from the escrow and will be available in your wallet.',
                    style: secondaryTextStyle()),
                10.height,
                Text(
                    '4. If you have any questions or concerns, please open a dispute.',
                    style: secondaryTextStyle()),
                10.height,
                Text(
                    '5. If you do not have a wallet, please create one before opening a trade.',
                    style: secondaryTextStyle()),
                10.height,

                ///terms of trade
                _DefaultExpantionTile(
                  infoExpanded: _termsExpanded,
                  title: 'Terms of Trade with SumitSharma',
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('1. Trade Instructions',
                            style: primaryTextStyle()),
                        10.width,
                        Expanded(
                          child: Text(
                              'Please make payment within the payment window. If you fail to make payment within the payment window, the trade will be cancelled automatically.',
                              style: secondaryTextStyle(),
                              textAlign: TextAlign.right),
                        ),
                      ],
                    ),
                    10.height,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('2. Payment Window', style: primaryTextStyle()),
                        10.width,
                        Expanded(
                          child: Text('45 minutes',
                              style: secondaryTextStyle(),
                              textAlign: TextAlign.right),
                        ),
                      ],
                    ),
                    10.height,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('3. Payment Method', style: primaryTextStyle()),
                        10.width,
                        Expanded(
                          child: Text('Bank Transfer',
                              style: secondaryTextStyle(),
                              textAlign: TextAlign.right),
                        ),
                      ],
                    ),
                    10.height,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('4. Terms of Trade', style: primaryTextStyle()),
                        10.width,
                        Expanded(
                          child: Text(
                              'Please make payment within the payment window. If you fail to make payment within the payment window, the trade will be cancelled automatically.',
                              style: secondaryTextStyle(),
                              textAlign: TextAlign.right),
                        ),
                      ],
                    ),
                    10.height,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('5. Trade Instructions',
                            style: primaryTextStyle()),
                        10.width,
                        Expanded(
                          child: Text(
                              'Please make payment within the payment window. If you fail to make payment within the payment window, the trade will be cancelled automatically.',
                              style: secondaryTextStyle(),
                              textAlign: TextAlign.right),
                        ),
                      ],
                    ),
                    10.height,
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('6. Trade Instructions',
                              style: primaryTextStyle()),
                          10.width,
                          Expanded(
                              child: Text(
                            'Please make payment within the payment window. If you fail to make payment within the payment window, the trade will be cancelled automatically.',
                            style: secondaryTextStyle(),
                          )),
                        ]),
                  ],
                ),

                10.height,

                ///payment details
                _DefaultExpantionTile(
                  infoExpanded: _paymentExpanded,
                  title: 'Payment Details',
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('1. Trade Instructions',
                            style: primaryTextStyle()),
                        10.width,
                        Expanded(
                          child: Text(
                              'Please make payment within the payment window. If you fail to make payment within the payment window, the trade will be cancelled automatically.',
                              style: secondaryTextStyle(),
                              textAlign: TextAlign.right),
                        ),
                      ],
                    ),
                    10.height,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('2. Payment Window', style: primaryTextStyle()),
                        10.width,
                        Expanded(
                          child: Text('45 minutes',
                              style: secondaryTextStyle(),
                              textAlign: TextAlign.right),
                        ),
                      ],
                    ),
                    10.height,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('3. Payment Method', style: primaryTextStyle()),
                        10.width,
                        Expanded(
                          child: Text('Bank Transfer',
                              style: secondaryTextStyle(),
                              textAlign: TextAlign.right),
                        ),
                      ],
                    ),
                    10.height,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('4. Terms of Trade', style: primaryTextStyle()),
                        10.width,
                        Expanded(
                          child: Text(
                              'Please make payment within the payment window. If you fail to make payment within the payment window, the trade will be cancelled automatically.',
                              style: secondaryTextStyle(),
                              textAlign: TextAlign.right),
                        ),
                      ],
                    ),
                    10.height,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('5. Trade Instructions',
                            style: primaryTextStyle()),
                        10.width,
                        Expanded(
                          child: Text(
                              'Please make payment within the payment window. If you fail to make payment within the payment window, the trade will be cancelled automatically.',
                              style: secondaryTextStyle(),
                              textAlign: TextAlign.right),
                        ),
                      ],
                    ),
                    10.height,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('6. Trade Instructions',
                            style: primaryTextStyle()),
                        10.width,
                        Expanded(
                            child: Text(
                          'Please make payment within the payment window. If you fail to make payment within the payment window, the trade will be cancelled automatically.',
                          style: secondaryTextStyle(),
                        )),
                      ],
                    ),
                  ],
                ),

                100.height,
              ],
            ),
          ),
        ],
      ),
      bottomSheet: _Chat(),
    );
  }

  Container _paymentMethods() {
    return Container(
      padding: const EdgeInsets.all(DEFAULT_PADDING / 2),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(DEFAULT_RADIUS)),
      child: Row(
        children: [
          Expanded(
            child: Wrap(
              runSpacing: DEFAULT_PADDING,
              spacing: DEFAULT_PADDING,
              children: [
                ...PaymentMethod.values.map(
                  (e) => Stack(
                    children: [
                      Container(
                        padding: const EdgeInsetsDirectional.only(
                          start: DEFAULT_PADDING,
                          end: DEFAULT_PADDING / 3,
                          top: DEFAULT_PADDING / 3,
                          bottom: DEFAULT_PADDING / 3,
                        ),
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius:
                                BorderRadius.circular(DEFAULT_RADIUS / 2)),
                        child: Text(e.name, style: primaryTextStyle(size: 11)),
                      ),
                      Positioned(
                        left: 0,
                        top: 0,
                        bottom: 0,
                        width: 5,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.5),
                            borderRadius:
                                BorderRadius.circular(DEFAULT_RADIUS * 2),
                          ),
                          child: Text('Cash', style: secondaryTextStyle()),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DefaultExpantionTile extends StatelessWidget {
  const _DefaultExpantionTile({
    super.key,
    required ValueNotifier<bool> infoExpanded,
    required this.title,
    required this.children,
  }) : _infoExpanded = infoExpanded;

  final ValueNotifier<bool> _infoExpanded;
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    Color expandedColor = Colors.grey.withOpacity(0.1);

    return ExpansionTile(
      collapsedBackgroundColor: expandedColor,
      backgroundColor: expandedColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DEFAULT_RADIUS)),
      collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DEFAULT_RADIUS)),
      title: Text(title,
          style: boldTextStyle(color: const Color.fromARGB(255, 178, 131, 2))),
      expandedAlignment: Alignment.topLeft,
      onExpansionChanged: (value) => _infoExpanded.value = value,
      childrenPadding: const EdgeInsetsDirectional.only(
          start: DEFAULT_PADDING,
          end: DEFAULT_PADDING,
          bottom: DEFAULT_PADDING / 2),
      trailing: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
            color: context.primaryColor,
            borderRadius: BorderRadius.circular(DEFAULT_RADIUS / 2)),
        child: ValueListenableBuilder<bool>(
            valueListenable: _infoExpanded,
            builder: (context, value, child) {
              return value
                  ? const FaIcon(FontAwesomeIcons.plus,
                      size: 10, color: Colors.white)
                  : const FaIcon(FontAwesomeIcons.minus,
                      size: 10, color: Colors.white);
            }),
      ),
      children: children,
    );
  }
}

class _Chat extends StatelessWidget {
  _Chat();
  static double defaultHeight = 600;
  final ValueNotifier<double> _maximumHeight =
      ValueNotifier<double>(defaultHeight);
  final ValueNotifier<bool> _dragging = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: _dragging,
        builder: (context, dragging, child) {
          return ValueListenableBuilder<double>(
              valueListenable: _maximumHeight,
              builder: (context, maximumHeight, child) {
                return ControlledBottomSheet(
                    padding: const EdgeInsets.all(0),
                    minimizedHeight: 70,
                    maximizedHeight: maximumHeight,
                    showLine: false,
                    showButton: false,
                    header: (_, notifier, sheetMinimized) => Stack(
                          children: [
                            _CustomChatHeader(
                                notifier: notifier, val: sheetMinimized),

                            ///drag handle
                            if (!sheetMinimized)
                              Positioned(
                                  top: 0,
                                  left: 0,
                                  right: 0,
                                  child: LongPressDraggable(
                                      feedback: Container(
                                        height: 30,
                                      ),
                                      onDragUpdate: (details) {
                                        double height = context.height() -
                                            details.globalPosition.dy;
                                        if (height > 0 && height > 300) {
                                          _maximumHeight.value = height;
                                        }
                                      },
                                      onDragStarted: () =>
                                          _dragging.value = true,
                                      onDragEnd: (details) =>
                                          _dragging.value = false,
                                      child: Center(
                                          child: AnimatedScale(
                                        scale: dragging ? 1.2 : 1,
                                        duration:
                                            const Duration(milliseconds: 200),
                                        child: const FaIcon(
                                            FontAwesomeIcons.gripLines,
                                            color: Colors.grey),
                                      )))),
                          ],
                        ),
                    builder: (context, notifier, sheetMinimized) {
                      return CustomChatWidget(hideInput: !sheetMinimized);
                    });
              });
        });
  }
}

class _CustomChatHeader extends StatelessWidget {
  const _CustomChatHeader({Key? key, required this.notifier, required this.val})
      : super(key: key);
  final ValueNotifier<bool> notifier;
  final bool val;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: context.width(),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [16.width, Text('Sumit Sharma', style: boldTextStyle())],
          ),
          Expanded(
            child: Row(
              children: [
                const Spacer(),
                Text('Online', style: secondaryTextStyle()),
                5.width,
                const Icon(Icons.circle, color: Colors.green, size: 10),
                10.width,
                (val
                        ? Container(
                            padding: const EdgeInsetsDirectional.symmetric(
                                horizontal: DEFAULT_PADDING,
                                vertical: DEFAULT_PADDING / 3),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.8),
                              borderRadius:
                                  BorderRadius.circular(DEFAULT_RADIUS * 2),
                            ),
                            child: Text('Chat',
                                style: boldTextStyle(
                                    size: 12, color: Colors.white)))
                        : const Icon(Icons.close, color: Colors.grey))
                    .onTap(() => notifier.value = !val),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
