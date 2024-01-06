import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:mime/mime.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../component/component_index.dart';
import '../../constants/constants_index.dart';
import '../../model/model_index.dart';
import '../../services/service_index.dart';
import '../../store/store_index.dart';
import '../../utils/utils_index.dart';
import '../enums/enum_index.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class TradeDetails extends StatefulWidget {
  const TradeDetails({super.key, this.id});
  final String? id;

  @override
  State<TradeDetails> createState() => _TradeDetailsState();
}

class _TradeDetailsState extends State<TradeDetails> {
  ///trade information
  final ValueNotifier<bool> _infoExpanded = ValueNotifier<bool>(true);

  ///terms of trade
  final ValueNotifier<bool> _termsExpanded = ValueNotifier<bool>(false);

  ///payment details
  final ValueNotifier<bool> _paymentExpanded = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _getTradeDetails();
  }

  final ValueNotifier<bool> _loading = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _isAuther = ValueNotifier<bool>(false);
  final ValueNotifier<Trade> _trade = ValueNotifier<Trade>(Trade());
  final ValueNotifier<List<Sender>> users = ValueNotifier<List<Sender>>([]);
  int extraTime = 0;

  ///get trade details
  Future<void> _getTradeDetails() async {
    _loading.value = true;
    if (widget.id == null) {
      toast('Trade not found');
      return;
    }
    await Apis.getTradeDetailsApi(widget.id!).then((value) {
      if (value.$1) {
        _trade.value =
            tryCatch<Trade>(() => Trade.fromJson(value.$2['trade'])) ?? Trade();
        _isAuther.value = tryCatch<bool>(() => value.$2['isAuther']) ?? false;
        users.value = tryCatch<List<Sender>>(() => (value.$2['persons'] as List)
                .map((e) => Sender.fromJson(e))
                .toList()) ??
            [];
        extraTime =
            tryCatch<int>(() => value.$2['configure']['trade_extra_time']) ?? 0;
      }
      pl('Trade Details: hashSlug -> ${_trade.value.hashSlug} -> ${_isAuther.value} -> ${users.value.length}');
    }).whenComplete(() => _loading.value = false);
  }

  /// trade action by id
  Future<void> _tradeActionById(String endPoint) async {
    // _loading.value = true;
    if (_trade.value.id == null) {
      toast('Trade not found');
      return;
    }
    await Apis.tradeActionByIdApi(endPoint, _trade.value.id!.toString())
        .then((value) {
      if (value.$1) {
        pl('trade action by id: $endPoint -> ${value.$2}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trade Details')),
      body: _body(context),
      bottomSheet: ValueListenableBuilder<Trade>(
          valueListenable: _trade,
          builder: (context, trade, child) {
            return trade.hashSlug.validate().isEmpty
                ? Container(height: 0)
                : _Chat(trade: trade);
          }).visible(true),
    );
  }

  Widget _body(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: _loading,
        builder: (context, loading, child) {
          return ValueListenableBuilder<Trade>(
              valueListenable: _trade,
              builder: (context, trade, child) {
                TradePaymentStatus status = TradePaymentStatusExt.fromInt(
                    trade.status.validate(value: -1));
                bool isOwner = trade.ownerId == appStore.userId;
                bool buy = trade.type == 'buy';
                print(
                    'isOwner: $isOwner w-${trade.ownerId} s-${trade.senderId} u-${appStore.userId} ');

                Sender? anotherUser = isOwner ? trade.sender : trade.owner;
                return AnimatedScrollView(
                  listAnimationType: ListAnimationType.FadeIn,
                  children: [
                    Container(
                      width: context.width(),
                      color: Colors.grey.withOpacity(0.1),
                      padding: const EdgeInsets.all(DEFAULT_PADDING),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ///Trade Payment Status
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                      '#${trade.tradeNumber ?? ' Invalid Trade No.'} ',
                                      style: boldTextStyle())),
                              10.width,
                              Text(
                                      TradePaymentStatusExt.fromInt(
                                              trade.status.validate(value: -1))
                                          .name,
                                      style: boldTextStyle(
                                          color:
                                              TradePaymentStatusExt.fromInt(0)
                                                  .color))
                                  .withShaderMaskGradient(
                                LinearGradient(
                                    colors: [
                                      TradePaymentStatusExt.fromInt(0).color,
                                      TradePaymentStatusExt.fromInt(0).color
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight),
                              ),
                            ],
                          ).skeletonize(enabled: loading),
                          10.height,

                          /// accepted payment methods
                          _paymentMethods(trade, loading: loading),
                          if (status != TradePaymentStatus.cancelled &&
                              status != TradePaymentStatus.completed &&
                              trade.status != 8)
                            Builder(builder: (context) {
                              bool hasTimer =
                                  trade.timeRemainingInSec.validate() > 0;
                              bool isBefore = false;
                              DateTime? remainingTime = DateTime.tryParse(
                                  trade.timeRemaining.validate()
                                  // '2023-01-05T14:18:30.000000Z'
                                  );
                              remainingTime = remainingTime?.toLocal();
                              if (remainingTime != null) {
                                remainingTime.add((Duration(
                                    minutes: trade.paymentWindow.validate() +
                                        extraTime)));

                                isBefore =
                                    DateTime.now().isBefore(remainingTime);
                              }
                              pl('remainingTime: $remainingTime isBefore: $isBefore');

                              return Column(
                                children: [
                                  /// for buyer (sender)
                                  Column(
                                    children: [
                                      /// if pending and sell
                                      Column(
                                        children: [
                                          Text('Please pay ${trade.payAmount.convertDouble(8)} ${trade.currency?.code.validate() ?? 'N/A'} to the seller',
                                                  style: secondaryTextStyle(
                                                      color: alertColor))
                                              .paddingBottom(10),
                                          Text('${trade.receiveAmount.convertDouble(8)} ${trade.receiverCurrency?.code.validate() ?? 'N/A'} will be added to your wallet after confirmation about the payment.',
                                                  style: secondaryTextStyle())
                                              .skeletonize(enabled: loading)
                                              .paddingBottom(10)
                                        ],
                                      ).visible(status ==
                                              TradePaymentStatus.pending &&
                                          !buy),
                                      Text('Once the buyer has confirmed your payment then ${trade.receiveAmount.convertDouble(8)} ${trade.receiverCurrency?.code.validate() ?? 'N/A'} will be available for release.',
                                              style: secondaryTextStyle())
                                          .paddingBottom(10)
                                          .visible(status ==
                                                  TradePaymentStatus.pending &&
                                              buy),

                                      Text('This trade is Reported by ${trade.disputeBy == trade.sender?.id ? trade.sender?.fullName.validate() : trade.owner?.fullName.validate()}. Please wait for the system response.',
                                              style: secondaryTextStyle())
                                          .paddingBottom(10)
                                          .visible(status ==
                                              TradePaymentStatus.disputed),

                                      ///TODO: match exctly to the web code
                                      Text('You can dispute this trade after === TIMER',
                                              style: secondaryTextStyle())
                                          .visible(status ==
                                                  TradePaymentStatus.paid &&
                                              isBefore &&
                                              !buy)
                                          .paddingBottom(10),

                                      Row(
                                        children: [
                                          _button('Cancel Trade',
                                              bgColor: cancelledColor,
                                              onPressed: () {}),
                                          10.width,
                                          _button('I have Paid',
                                              bgColor: acceptColor,
                                              onPressed: () {}),
                                        ],
                                      ).visible(status ==
                                              TradePaymentStatus.pending &&
                                          !buy),
                                      Row(children: [
                                        _button('Dispute Trade',
                                            bgColor: cancelledColor,
                                            onPressed: () {}),
                                        10.width,
                                        _button('Payment Received',
                                            bgColor: acceptColor,
                                            onPressed: () {}),
                                      ]).visible(
                                          status == TradePaymentStatus.paid &&
                                              buy),
                                      Row(children: [
                                        _button('Dispute Trade',
                                            bgColor: cancelledColor,
                                            onPressed: () {}),
                                        10.width,
                                        _button('Payment Received',
                                            bgColor: acceptColor,
                                            onPressed: () {}),
                                      ]).visible(
                                          status == TradePaymentStatus.paid &&
                                              !isBefore &&
                                              !buy),
                                    ],
                                  ).visible(!isOwner),

                                  /// for seller (owner)
                                  Column(
                                    children: [
                                      /// if pending and sell
                                      Column(
                                        children: [
                                          ///timer
                                          Text('You can dispute this trade afte === TIMER',
                                                  style: secondaryTextStyle())
                                              .visible(status ==
                                                      TradePaymentStatus.paid &&
                                                  isBefore &&
                                                  buy)
                                              .paddingBottom(10),

                                          ///
                                          Text('Please pay ${trade.payAmount.convertDouble(8)} ${trade.currency?.code.validate() ?? 'N/A'} to the seller',
                                                  style: secondaryTextStyle(
                                                      color: alertColor))
                                              .paddingBottom(10),
                                          Text('${trade.receiveAmount.convertDouble(8)} ${trade.receiverCurrency?.code.validate() ?? 'N/A'} will be added to your wallet after confirmation about the payment.',
                                                  style: secondaryTextStyle())
                                              .skeletonize(enabled: loading)
                                              .paddingBottom(10),
                                          Row(
                                            children: [
                                              _button('Cancel Trade',
                                                  bgColor: cancelledColor,
                                                  onPressed: () =>
                                                      _tradeActionById(
                                                          'cancel')),
                                              10.width,
                                              _button('I have Paid',
                                                  bgColor: acceptColor,
                                                  onPressed: () {}),
                                            ],
                                          ),
                                        ],
                                      ).visible(status ==
                                              TradePaymentStatus.pending &&
                                          buy),

                                      Text('Once the buyer has confirmed your payment then ${trade.receiveAmount.convertDouble(8)} ${trade.receiverCurrency?.code.validate() ?? 'N/A'} will be available for release.',
                                              style: secondaryTextStyle())
                                          .paddingBottom(10)
                                          .visible(status ==
                                                  TradePaymentStatus.pending &&
                                              buy),

                                      status == TradePaymentStatus.disputed
                                          ? Text('This trade is Reported by ${trade.disputeBy == trade.sender?.id ? trade.sender?.fullName.validate() : trade.owner?.fullName.validate()}. Please wait for the system response.',
                                                  style: secondaryTextStyle())
                                              .paddingBottom(10)
                                              .visible(status ==
                                                  TradePaymentStatus.disputed)
                                          : Text('The buyer can dispute anytime this trade after countdown time.',
                                                  style: secondaryTextStyle())
                                              .paddingBottom(10)
                                              .visible(status !=
                                                      TradePaymentStatus
                                                          .pending &&
                                                  !buy),

                                      Row(
                                        children: [
                                          _button('Cancel Trade',
                                              bgColor: cancelledColor,
                                              onPressed: () =>
                                                  _tradeActionById('cancel')),
                                        ],
                                      ).visible(status ==
                                              TradePaymentStatus.pending &&
                                          !buy),
                                      Row(children: [
                                        _button('Dispute Trade',
                                            bgColor: cancelledColor,
                                            onPressed: () {}),
                                        10.width,
                                        _button('Release',
                                            bgColor: acceptColor,
                                            onPressed: () {}),
                                      ]).visible(
                                          status == TradePaymentStatus.paid &&
                                              !buy),
                                      Row(children: [
                                        _button('Dispute Trade',
                                            bgColor: cancelledColor,
                                            onPressed: () {}),
                                      ]).visible(
                                          status == TradePaymentStatus.paid &&
                                              !isBefore &&
                                              buy),
                                    ],
                                  ).visible(isOwner),
                                ],
                              );
                            }),
                        ],
                      ),
                    ),
                    10.height,
                    _details(context, trade, loading, anotherUser),
                    30.height,
                    assetImages(MyPng.logoLBlack, height: 100, width: 200)
                        .center(),
                    30.height,
                  ],
                );
              });
        });
  }

  Container _details(
      BuildContext context, Trade trade, bool loading, Sender? anotherUser) {
    return Container(
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
                    child: Text(trade.owner?.fullName.validate() ?? '',
                        style: boldTextStyle(), textAlign: TextAlign.right),
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
                    child: Text(
                        '${trade.rate.convertDouble(8)} ${trade.currency?.code.validate() ?? 'N/A'} / ${trade.receiverCurrency?.code.validate() ?? 'N/A'}',
                        style: boldTextStyle(),
                        textAlign: TextAlign.right),
                  ),
                ],
              ),
              10.height,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(trade.currency?.name.validate() ?? '',
                      style: primaryTextStyle()),
                  10.width,
                  Expanded(
                    child: Text(
                        '${trade.payAmount.convertDouble(8)} ${trade.currency?.code.validate() ?? 'N/A'}',
                        style: boldTextStyle(),
                        textAlign: TextAlign.right),
                  ),
                ],
              ).visible(trade.currency != null).paddingBottom(10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(trade.receiverCurrency?.name.validate() ?? '',
                      style: primaryTextStyle()),
                  10.width,
                  Expanded(
                    child: Text(
                        '${trade.receiveAmount} ${trade.receiverCurrency?.code.validate() ?? 'N/A'}',
                        style: boldTextStyle(),
                        textAlign: TextAlign.right),
                  ),
                ],
              ).visible(trade.receiverCurrency != null).paddingBottom(10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Payment Window', style: primaryTextStyle()),
                  10.width,
                  Expanded(
                    child: Text('${trade.paymentWindow.validate()} minutes',
                        style: boldTextStyle(), textAlign: TextAlign.right),
                  ),
                ],
              ),
            ],
          ),
          10.height,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
            ],
          ).skeletonize(enabled: true).visible(loading),
          10.height,

          ///terms of trade
          _DefaultExpantionTile(
            infoExpanded: _termsExpanded,
            title:
                'Terms of Trade with ${anotherUser?.fullName.validate() ?? ''}',
            children: [
              Text(trade.termsOfTrade.validate(), style: secondaryTextStyle()),
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Text('1. Trade Instructions', style: primaryTextStyle()),
              //     10.width,
              //     Expanded(
              //       child: Text(
              //           'Please make payment within the payment window. If you fail to make payment within the payment window, the trade will be cancelled automatically.',
              //           style: secondaryTextStyle(),
              //           textAlign: TextAlign.right),
              //     ),
              //   ],
              // ),
              // 10.height,
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Text('2. Payment Window', style: primaryTextStyle()),
              //     10.width,
              //     Expanded(
              //       child: Text('45 minutes',
              //           style: secondaryTextStyle(),
              //           textAlign: TextAlign.right),
              //     ),
              //   ],
              // ),
              // 10.height,
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Text('3. Payment Method', style: primaryTextStyle()),
              //     10.width,
              //     Expanded(
              //       child: Text('Bank Transfer',
              //           style: secondaryTextStyle(),
              //           textAlign: TextAlign.right),
              //     ),
              //   ],
              // ),
              // 10.height,
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Text('4. Terms of Trade', style: primaryTextStyle()),
              //     10.width,
              //     Expanded(
              //       child: Text(
              //           'Please make payment within the payment window. If you fail to make payment within the payment window, the trade will be cancelled automatically.',
              //           style: secondaryTextStyle(),
              //           textAlign: TextAlign.right),
              //     ),
              //   ],
              // ),
              // 10.height,
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Text('5. Trade Instructions', style: primaryTextStyle()),
              //     10.width,
              //     Expanded(
              //       child: Text(
              //           'Please make payment within the payment window. If you fail to make payment within the payment window, the trade will be cancelled automatically.',
              //           style: secondaryTextStyle(),
              //           textAlign: TextAlign.right),
              //     ),
              //   ],
              // ),
              // 10.height,
              // Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              //   Text('6. Trade Instructions', style: primaryTextStyle()),
              //   10.width,
              //   Expanded(
              //       child: Text(
              //     'Please make payment within the payment window. If you fail to make payment within the payment window, the trade will be cancelled automatically.',
              //     style: secondaryTextStyle(),
              //   )),
              // ]),
            ],
          ),

          10.height,

          ///payment details
          _DefaultExpantionTile(
            infoExpanded: _paymentExpanded,
            title: 'Payment Details',
            children: [
              Text(trade.paymentDetails.validate(),
                  style: secondaryTextStyle()),
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Text('1. Trade Instructions', style: primaryTextStyle()),
              //     10.width,
              //     Expanded(
              //       child: Text(
              //           'Please make payment within the payment window. If you fail to make payment within the payment window, the trade will be cancelled automatically.',
              //           style: secondaryTextStyle(),
              //           textAlign: TextAlign.right),
              //     ),
              //   ],
              // ),
              // 10.height,
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Text('2. Payment Window', style: primaryTextStyle()),
              //     10.width,
              //     Expanded(
              //       child: Text('45 minutes',
              //           style: secondaryTextStyle(),
              //           textAlign: TextAlign.right),
              //     ),
              //   ],
              // ),
              // 10.height,
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Text('3. Payment Method', style: primaryTextStyle()),
              //     10.width,
              //     Expanded(
              //       child: Text('Bank Transfer',
              //           style: secondaryTextStyle(),
              //           textAlign: TextAlign.right),
              //     ),
              //   ],
              // ),
              // 10.height,
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Text('4. Terms of Trade', style: primaryTextStyle()),
              //     10.width,
              //     Expanded(
              //       child: Text(
              //           'Please make payment within the payment window. If you fail to make payment within the payment window, the trade will be cancelled automatically.',
              //           style: secondaryTextStyle(),
              //           textAlign: TextAlign.right),
              //     ),
              //   ],
              // ),
              // 10.height,
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Text('5. Trade Instructions', style: primaryTextStyle()),
              //     10.width,
              //     Expanded(
              //       child: Text(
              //           'Please make payment within the payment window. If you fail to make payment within the payment window, the trade will be cancelled automatically.',
              //           style: secondaryTextStyle(),
              //           textAlign: TextAlign.right),
              //     ),
              //   ],
              // ),
              // 10.height,
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Text('6. Trade Instructions', style: primaryTextStyle()),
              //     10.width,
              //     Expanded(
              //         child: Text(
              //       'Please make payment within the payment window. If you fail to make payment within the payment window, the trade will be cancelled automatically.',
              //       style: secondaryTextStyle(),
              //     )),
              //   ],
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Expanded _button(
    String text, {
    Color bgColor = Colors.red,
    Color textColor = Colors.white,
    VoidCallback? onPressed,
  }) {
    return Expanded(
        child: ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: bgColor),
      onPressed: onPressed,
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    ));
  }

  Widget _paymentMethods(Trade trade, {required bool loading}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: loading ? 90 : null,
      padding: const EdgeInsets.all(DEFAULT_PADDING / 2),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(DEFAULT_RADIUS)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Wrap(
              runSpacing: DEFAULT_PADDING,
              spacing: DEFAULT_PADDING,
              children: [
                ...(loading
                        ? List.generate(7, (index) => Gateways())
                        : trade.gateways.validate())
                    .map((e) => _buildPaymentMethodItem(loading, e))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Skeletonizer _buildPaymentMethodItem(bool loading, Gateways e) {
    return Skeletonizer(
      enabled: loading,
      textBoneBorderRadius: TextBoneBorderRadius(BorderRadius.circular(3)),
      containersColor: Colors.grey.withOpacity(0.2),
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsetsDirectional.only(
              start: DEFAULT_PADDING,
              end: DEFAULT_PADDING / 3,
              top: DEFAULT_PADDING / 3,
              bottom: DEFAULT_PADDING / 3,
            ),
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(DEFAULT_RADIUS / 2)),
            child: Text(loading ? '------' : e.name.validate(),
                style: primaryTextStyle(size: 11, weight: FontWeight.w500)),
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
                      borderRadius: BorderRadius.circular(DEFAULT_RADIUS * 2))))
        ],
      ),
    );
  }
}

class _DefaultExpantionTile extends StatelessWidget {
  const _DefaultExpantionTile({
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
      initiallyExpanded: _infoExpanded.value,
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
              return !value
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

class _Chat extends StatefulWidget {
  const _Chat({Key? key, required this.trade}) : super(key: key);
  static double defaultHeight = 500;
  final Trade trade;

  @override
  State<_Chat> createState() => _ChatState();
}

class _ChatState extends State<_Chat> {
  ///sheet variables
  final ValueNotifier<double> _maximumHeight =
      ValueNotifier<double>(_Chat.defaultHeight);
  late ValueNotifier<bool> sheetMinimized;
  final ValueNotifier<bool> _dragging = ValueNotifier<bool>(false);
  final ValueNotifier<bool> loadingChat = ValueNotifier<bool>(true);

  ///chat variables
  final ValueNotifier<List<types.Message>> messages =
      ValueNotifier<List<types.Message>>([]);
  late types.User user;
  PusherChannel? myChannel;
  @override
  void initState() {
    super.initState();
    TradePaymentStatus status =
        TradePaymentStatusExt.fromInt(widget.trade.status.validate(value: -1));
    sheetMinimized = ValueNotifier<bool>(
        status == TradePaymentStatus.completed ||
            status == TradePaymentStatus.cancelled);
    user = types.User(id: appStore.userId.validate().toString());
    onConnectPressed();
    afterBuildCreated(() => getChatMessages());
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  getChatMessages([dynamic chatId, int perPage = 20]) async {
    pl('getChatMessages: ${widget.trade.hashSlug.validate()} $chatId');
    if (widget.trade.hashSlug.validate().isEmpty) return;
    loadingChat.value = true;
    // await 5.seconds.delay;
    await Apis.getTradeChatMessagesApi(widget.trade.hashSlug.validate(),
            perPage: perPage, chatId: chatId)
        .then((value) async {
      if (value.$1) {
        final messageList = <types.Message>[];
        for (var e in ((value.$2['chats'] ?? []) as List)) {
          var message = tryCatch(() => messageFromJson(e), 'getChatMessages');
          if (message == null) continue;
          messageList.add(message);
        }
        await (perPage * 10).milliseconds.delay;
        if (messageList.isNotEmpty) {
          for (var message in messageList) {
            bool contains =
                messages.value.any((element) => element.id == message.id);
            if (!contains) {
              // chatId == null
              //     ?
              messages.value.add(message);
              // : messages.value.insert(0, message);
            } else {
              var index = messages.value
                  .indexWhere((element) => element.id == message.id);
              messages.value[index] = message;
            }
          }
        }
        // messages.value.insertAll(0, messageList);
        pl('messages: ${messages.value.length}', 'getChatMessages');
      }
    });
    loadingChat.value = false;
    setState(() {});
  }

  types.Message? messageFromJson(Map<String, dynamic> json) {
    if (json['attachment'].toString().validate().isEmpty &&
        json['description'].toString().validate().isEmpty) return null;
    int createdAt =
        DateTime.tryParse(json['created_at'] ?? '')?.millisecondsSinceEpoch ??
            0;
    String id = json['id'].toString().validate();
    types.Status status =
        json['is_read'] == 1 ? types.Status.seen : types.Status.sent;
    String username = json['chatable']['username'].toString().validate();
    String firstName = json['chatable']['firstname'].toString().validate();
    String lastName = json['chatable']['lastname'].toString().validate();
    String fullName = firstName.isEmpty && lastName.isEmpty
        ? username
        : '$firstName $lastName';
    String url =
        'https://ui-avatars.com/api/?size=256&name=$fullName&background=ffc107&color=fff&=true';
    Uri imageUrl = Uri.file(url);
    pl('fullName: $fullName ${imageUrl.userInfo} ${imageUrl.data} ${imageUrl.normalizePath()}');
    types.User user = types.User.fromJson({
      "firstName": firstName.capitalizeEachWord(),
      "id": (json['chatable']['id'] ?? '').toString(),
      "lastName": lastName.capitalizeEachWord(),
      'imageUrl': imageUrl.data,
      // 'imageUrl': json['chatable']['imgPath'],
    });
    String text = json['description'].toString().validate();

    ///text message
    if (json['attachment'].toString().validate().isEmpty) {
      return types.TextMessage(
        author: user,
        createdAt: createdAt,
        id: id,
        text: text,
        status: status,
      );

      ///others
    } else {
      bool isImage = json['attachment'].toString().validate().isImage ||
          json['attachment'].toString().validate().split('.').last == 'png';
      bool isVideo = json['attachment'].toString().validate().isVideo;
      bool isAudio = json['attachment'].toString().validate().isAudio;
      String attachment = json['attachment'].toString().validate();
      bool replied = text.isNotEmpty;
      pl('id:=> $id is  isImage: $isImage, isVideo: $isVideo, isAudio: $isAudio  hasReplied: $replied');
      if (isImage) {
        return types.ImageMessage(
          author: user,
          createdAt: createdAt,
          status: status,
          // height: image.height.toDouble(),
          id: id,
          name: '',
          size: 100,
          // uri: 'https://wallpapers.com/images/featured/hd-a5u9zq0a0ymy2dug.jpg',
          uri: AppConst.siteUrl + attachment,
          // width: image.width.toDouble(),
          remoteId: id,
          repliedMessage: replied
              ? types.TextMessage(
                  author: user,
                  createdAt: createdAt,
                  id: id,
                  text: text,
                  status: status,
                )
              : null,
        );
      }
      return types.FileMessage(
        author: user,
        status: status,
        createdAt: createdAt,
        id: id,
        mimeType: lookupMimeType(attachment),
        name: '',
        size: 100,
        uri: attachment,
      );
    }
  }

  Future<bool> sendMessage(dynamic message) async {
    if (message is String && message.isEmpty) return false;
    final formData = FormData.fromMap({
      "trade_id": widget.trade.id ?? '',
      "message": message is! String ? '' : message,
    });
    if (message is XFile || message is PlatformFile) {
      formData.files.add(MapEntry(
          'attachment',
          await MultipartFile.fromFile(message.path ?? '',
              filename: message.name)));
    }
    pl('sending message: $message ${formData.fields}}');

    await Apis.pushTradeMessageApi(formData).then((value) {
      pl('pushTradeMessageApi: $value');
      if (value.$1) setState(() {});
      // myChannel!.trigger(
      //   PusherEvent(channelName: channelName, eventName: 'new-message', data: {
      //     "id": 3553,
      //     "trades_id": 186,
      //     "chatable_type": "App\\Models\\User",
      //     "chatable_id": 8,
      //     "description": "dfdfdf",
      //     "attachment":
      //         "assets/uploads/attachments/65968caed70d61704365230.png",
      //     "is_read": 0,
      //     "is_read_admin": 0,
      //     "created_at": "2024-01-04T10:47:10.000000Z",
      //     "updated_at": "2024-01-04T10:47:11.000000Z",
      //     "formatted_date": "Jan 04, 2024 04:17 PM",
      //     "chatable": {
      //       "id": 8,
      //       "username": "SumitSharma",
      //       "phone": "870079956563",
      //       "image": null,
      //       "fullname": " ",
      //       "mobile": " 870079956563",
      //       "imgPath":
      //           "https://p2p.coinxfiat.com/assets/admin/images/default.png",
      //       "last_seen": true,
      //       "total_trade": 4
      //     }
      //   }),
      // );
    });
    return true;
  }

  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

  void onConnectPressed() async {
    try {
      ///init pusher
      await pusher.init(
        apiKey: AppConst.pusherAppKey,
        cluster: AppConst.pusherAppCluster,
        onConnectionStateChange: onConnectionStateChange,
        onError: onError,
        onSubscriptionSucceeded: onSubscriptionSucceeded,
        onEvent: onEvent,
        onSubscriptionError: onSubscriptionError,
        onDecryptionFailure: onDecryptionFailure,
        onMemberAdded: onMemberAdded,
        onMemberRemoved: onMemberRemoved,
        onSubscriptionCount: onSubscriptionCount,
        // authEndpoint: "<Your Authendpoint Url>",
        // onAuthorizer: onAuthorizer
      );
      myChannel = await pusher.subscribe(
          channelName:
              AppConst.pusherAppChatTopic + widget.trade.hashSlug.validate());
      await pusher.connect();
    } catch (e) {
      logger.e('onConnectPressed error: ', tag: 'Trading Chat', error: e);
    }
  }

  void onEvent(PusherEvent event) {
    bool listen = event.channelName ==
        AppConst.pusherAppChatTopic + widget.trade.hashSlug.validate();
    pl('onEvent: listen this:=> $listen ${event.channelName} \n ${event.data.runtimeType}');
    if (listen && (event.data is String) && event.data.isNotEmpty) {
      var data = jsonDecode(event.data);
      if (data is Map<String, dynamic> && data.isNotEmpty) {
        data = data['message'];
      } else {
        return;
      }
      types.Message? message = tryCatch(() => messageFromJson(data));
      if (message != null) {
        bool contains =
            messages.value.any((element) => element.id == message.id);
        if (!contains) {
          messages.value.insert(0, message);
        } else {
          var index =
              messages.value.indexWhere((element) => element.id == message.id);
          messages.value[index] = message;
        }
        setState(() {});
      }
    }
  }

  void disconnect() async => await pusher.disconnect();

  void onConnectionStateChange(dynamic currentState, dynamic previousState) =>
      pl("Connection: $currentState");

  void onError(String message, int? code, dynamic e) =>
      pl("onError: $message code: $code exception: $e");

  void onSubscriptionSucceeded(String channelName, dynamic data) {
    log("onSubscriptionSucceeded: $channelName data: $data");
    final me = pusher.getChannel(channelName)?.me;
    log("Me: $me");
  }

  void onSubscriptionError(String message, dynamic e) =>
      log("onSubscriptionError: $message Exception: $e");

  void onDecryptionFailure(String event, String reason) =>
      log("onDecryptionFailure: $event reason: $reason");

  void onMemberAdded(String channelName, PusherMember member) =>
      log("onMemberAdded: $channelName user: $member");

  void onMemberRemoved(String channelName, PusherMember member) =>
      log("onMemberRemoved: $channelName user: $member");

  void onSubscriptionCount(String channelName, int subscriptionCount) => log(
      "onSubscriptionCount: $channelName subscriptionCount: $subscriptionCount");

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: loadingChat,
        builder: (context, loading, child) {
          return ValueListenableBuilder<bool>(
              valueListenable: _dragging,
              builder: (context, dragging, child) {
                return ValueListenableBuilder<double>(
                    valueListenable: _maximumHeight,
                    builder: (context, maximumHeight, child) {
                      bool isOwner = widget.trade.owner?.id == appStore.userId;
                      // print(
                      //     'isOwner: $isOwner w-${widget.trade.owner?.id} s-${widget.trade.sender?.id} u-${appStore.userId} ');

                      Sender? anotherUser =
                          isOwner ? widget.trade.sender : widget.trade.owner;
                      String fullName = anotherUser?.fullName.validate() ?? '';
                      bool isOnline = anotherUser?.status == 1;
                      return ControlledBottomSheet(
                          // padding: const EdgeInsets.all(0),
                          minimizedHeight: 50,
                          maximizedHeight: maximumHeight,
                          showLine: false,
                          showButton: false,
                          enableDragHint: true,
                          initiallyMinimized: true,
                          sheetMinimized: sheetMinimized,
                          header: (_, notifier, sheetMinimized) => _header(
                                notifier,
                                sheetMinimized,
                                context,
                                dragging,
                                username: fullName,
                                isOnline: isOnline,
                              ),
                          builder: (context, notifier, sheetMinimized) {
                            TradePaymentStatus status =
                                TradePaymentStatusExt.fromInt(
                                    widget.trade.status.validate());
                            return CustomChatWidget(
                              hideInput: sheetMinimized ||
                                  (status == TradePaymentStatus.completed ||
                                      status == TradePaymentStatus.cancelled),
                              // enableFileSelection: true,
                              // enableImageSelection: false,
                              messagesList: messages,
                              onSendPressed: sendMessage,
                              loading: loadingChat,
                              showUserAvatar: true,

                              onLoadMore: () async {
                                await getChatMessages(
                                    int.tryParse(messages.value.last.id), 20);
                              },
                              user: user,
                              // users: [trade.sender?.toJson()??{}, trade.owner?.toJson()??{}],
                            );
                          });
                    });
              });
        });
  }

  Widget _header(ValueNotifier<bool> notifier, bool sheetMinimized,
      BuildContext context, bool dragging,
      {required String username, required bool isOnline}) {
    var child = Draggable(
        feedback: Container(height: 30),
        onDragUpdate: (details) {
          double height = context.height() - details.globalPosition.dy;
          if (height > 0 && height > 300) {
            _maximumHeight.value = height;
          }
        },
        onDragStarted: () {
          _dragging.value = true;
          timeDilation = 0.5;
        },
        onDragEnd: (details) {
          _dragging.value = false;
          timeDilation = 1.0;
        },
        child: Center(
            child: AnimatedScale(
          scale: dragging ? 1.5 : 1,
          duration: const Duration(milliseconds: 100),
          child: Stack(
            children: [
              _CustomChatHeader(
                minimizeNotifier: notifier,
                val: sheetMinimized,
                username: username,
                isOnline: isOnline,
                dragging: dragging,
              ),

              ///drag handle
              if (!sheetMinimized)
                Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Center(
                        child: AnimatedScale(
                      scale: dragging ? 0.8 : 1,
                      duration: const Duration(milliseconds: 200),
                      child: const FaIcon(FontAwesomeIcons.gripLines,
                          color: Colors.grey, size: 30),
                    ))),
            ],
          ),
        )));

    return sheetMinimized
        ? child
        : JustTheTooltip(
            content: Padding(
              padding: const EdgeInsets.all(DEFAULT_PADDING),
              child: Text('Drag up/down to resize chat window.',
                  style: primaryTextStyle()),
            ),
            triggerMode: TooltipTriggerMode.tap,
            tailBuilder: JustTheInterface.defaultBezierTailBuilder,
            preferredDirection: AxisDirection.up,
            child: child);
  }
}

class _CustomChatHeader extends StatelessWidget {
  const _CustomChatHeader({
    Key? key,
    required this.minimizeNotifier,
    required this.val,
    required this.username,
    required this.isOnline,
    required this.dragging,
  }) : super(key: key);

  /// sheet close notifier
  final ValueNotifier<bool> minimizeNotifier;
  final bool val;
  final String username;
  final bool isOnline;
  final bool dragging;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: context.width(),
      decoration: boxDecorationRoundedWithShadow(
        0,
        shadowColor: Colors.black.withOpacity(0.1),
        backgroundColor: Colors.white.withOpacity(1),
        blurRadius: 50,
        spreadRadius: 50,
        offset: const Offset(0, -15),
      ),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: dragging ? 0.6 : 1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [16.width, Text(username, style: boldTextStyle())]),
            Expanded(
              child: Row(
                children: [
                  const Spacer(),
                  Text(isOnline ? 'Online' : 'Offline',
                          style: secondaryTextStyle())
                      .paddingRight(5),
                  Icon(Icons.circle,
                          color: isOnline ? Colors.green : Colors.grey,
                          size: 10)
                      .paddingRight(10),
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
                      .onTap(() => minimizeNotifier.value = !val)
                      .paddingRight(DEFAULT_PADDING)
                      .visible(!dragging),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
