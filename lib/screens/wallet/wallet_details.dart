import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import '../../constants/constants_index.dart';
import '../../utils/utils_index.dart';

class WalletDetails extends StatelessWidget {
  const WalletDetails({super.key, this.title, this.subTitle});
  final String? title;
  final String? subTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? subTitle ?? 'Wallet Details'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        children: [
          ///wallet detail
          _walletDetail(context),

          ///transaction
          _transaction(context),
        ],
      ),
    );
  }

  Widget _transaction(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
          left: DEFAULT_PADDING, right: DEFAULT_PADDING, top: DEFAULT_PADDING),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///transaction title
          Text(
            'Transaction',
            style: boldTextStyle(),
          ),

          ///transaction list
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 10,
            itemBuilder: (context, index) {
              return _transactionItem(
                context,
                trxId: '0x8f2d...d3f2',
                title: index.isEven ? 'Send' : 'Receive',
                amount: '${09.078738 * (index + 1)}',
                remark: 'Adding to wallet',
                time: DateTime.now().subtract(Duration(days: index)).timeAgo,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _transactionItem(
    BuildContext context, {
    required String trxId,
    required String title,
    required String amount,
    String? remark,
    String? time,
  }) {
    bool isSend = title.toLowerCase() == 'send';
    return Container(
      margin: const EdgeInsets.only(top: DEFAULT_PADDING),
      child: Row(
        children: [
          ///icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Transform.rotate(
              angle: 3.14 / 4,
              child: Icon(
                isSend ? FontAwesomeIcons.arrowUp : FontAwesomeIcons.arrowDown,
                size: 24,
                color: isSend ? runningColor : completedColor,
              ),
            ),
          ),
          width10(),

          ///detail
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///title
                Text(
                  title,
                  style: boldTextStyle(),
                ),

                ///amount
                Text(
                  amount,
                  style: boldTextStyle(size: 16),
                ),

                ///remark
                Text(
                  remark ?? 'Remark',
                  style: secondaryTextStyle(),
                ),
              ],
            ),
          ),

          ///time
          Text(
            time ?? 'Time',
            style: secondaryTextStyle(),
          ),
        ],
      ),
    );
  }

  Widget _walletDetail(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
          left: DEFAULT_PADDING, right: DEFAULT_PADDING, top: DEFAULT_PADDING),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///wallet name
          Text(subTitle ?? 'Sub Title', style: boldTextStyle()),

          ///wallet amount
          Text('0.0000978738', style: boldTextStyle(size: 24)),

          ///wallet address
          Row(
            children: [
              Text('0x8f2d...d3f2', style: secondaryTextStyle()),

              ///copy
              IconButton(
                  onPressed: () {},
                  icon: const Icon(FontAwesomeIcons.copy, size: 16)),
            ],
          ),

          ///divider
          const Divider(height: 0),
          height10(),

          ///wallet action
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ///send
              _walletAction(
                context,
                icon: FontAwesomeIcons.paperPlane,
                title: 'Send',
                onTap: () {},
              ),

              ///receive
              _walletAction(
                context,
                icon: FontAwesomeIcons.qrcode,
                title: 'Deposit',
                onTap: () =>
                    _showDepositDialog(context, title: title, symbol: subTitle),
              ),

              ///buy
              _walletAction(
                context,
                icon: FontAwesomeIcons.cartShopping,
                title: 'Withdraw',
                onTap: () => _showWithdrawDialog(context, title: title),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _walletAction(BuildContext context,
      {required IconData icon, required String title, required onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(DEFAULT_PADDING),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(icon, size: 24),
            Text(title, style: secondaryTextStyle()),
          ],
        ),
      ),
    );
  }

  void _showWithdrawDialog(BuildContext context, {String? title}) {
    showDialog(
      context: context,
      builder: (context) => _WalletWithdraDialog(title: title),
    );
  }

  ///_showDepositDialog is used to show deposit dialog box with qr code and tips
  void _showDepositDialog(BuildContext context,
      {String? title, String? symbol}) {
    showDialog(
      context: context,
      builder: (context) => _WalletDepositDialog(title: title, symbol: symbol),
    );
  }
}

class _WalletWithdraDialog extends StatelessWidget {
  const _WalletWithdraDialog({
    super.key,
    this.title,
    this.note,
  });
  final String? title;
  final String? note;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DEFAULT_PADDING)),
      title: Text('Make ${title ?? ''} Withdrawal',
          style: boldTextStyle(size: 16, color: Colors.black)),
      titlePadding: const EdgeInsetsDirectional.only(
          start: DEFAULT_PADDING, top: DEFAULT_PADDING),
      contentPadding: const EdgeInsetsDirectional.only(
        start: DEFAULT_PADDING,
        end: DEFAULT_PADDING,
        top: 0,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ///note
          Text(
            'Note: You can withdraw only to your own wallet address.',
            style: secondaryTextStyle(color: Colors.red),
          ),

          height10(),

          /// Network text field
          TextField(
            style: primaryTextStyle(),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              isDense: true,
              labelText: 'Network',
              hintText: 'Network',
              hintStyle: secondaryTextStyle(),
              labelStyle: secondaryTextStyle(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          height10(),

          /// Wallet Address * text field
          TextField(
            style: primaryTextStyle(),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              isDense: true,
              labelText: 'Wallet Address *',
              hintText: 'Wallet Address *',
              hintStyle: secondaryTextStyle(),
              labelStyle: secondaryTextStyle(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          height10(),

          ///Withdraw Amount * text field
          TextField(
            style: primaryTextStyle(),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.next,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,8}')),
            ],
            decoration: InputDecoration(
              isDense: true,
              labelText: 'Withdraw Amount *',
              hintText: 'Withdraw Amount *',
              hintStyle: secondaryTextStyle(),
              labelStyle: secondaryTextStyle(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
      actions: [
        OutlinedButton(
          onPressed: () => context.pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(DEFAULT_PADDING / 2)),
          ),
          onPressed: () {
            hideKeyboard(context);
          },
          child: const Text('Withdraw'),
        ),
      ],
    );
  }
}

class _WalletDepositDialog extends StatelessWidget {
  const _WalletDepositDialog({
    super.key,
    this.title,
    this.symbol,
  });
  final String? title;
  final String? symbol;

  @override
  Widget build(BuildContext context) {
    final qrCode = QrCode(8, QrErrorCorrectLevel.H)
      ..addData('lorem ipsum dolor sit amet');

    var qrImage = QrImage(qrCode);
    return ListView(
      // mainAxisSize: MainAxisSize.min,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DEFAULT_PADDING)),
          title: Text('Deposit ${title ?? ''}',
              style: boldTextStyle(size: 16, color: Colors.black)),
          titlePadding: const EdgeInsetsDirectional.only(
              start: DEFAULT_PADDING, top: DEFAULT_PADDING),
          contentPadding: const EdgeInsetsDirectional.only(
            start: DEFAULT_PADDING,
            end: DEFAULT_PADDING,
            top: 0,
            bottom: DEFAULT_PADDING,
          ),
          content: _portrait(context, qrImage),
          scrollable: true,
        ),
        Material(
          shadowColor: Colors.transparent,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          shape: const CircleBorder(),
          child: Container(
            padding: const EdgeInsets.all(DEFAULT_PADDING),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: const Icon(FontAwesomeIcons.xmark, size: 24).center(),
          ).onTap(() => context.pop()),
        ),
      ],
    );
  }

  Widget _portrait(BuildContext context, QrImage qrImage) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(),

        ///qr code
        PrettyQrView(qrImage: qrImage, decoration: const PrettyQrDecoration()),

        height10(),

        ///wallet address
        Text('0x8f2d...d3f2', style: boldTextStyle()),

        height10(),

        ///copy
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {},
                icon: const Icon(FontAwesomeIcons.copy, size: 16)),
            Text('Copy', style: secondaryTextStyle()),
          ],
        ),

        height10(),

        ///tips
        Row(children: [Text('Tips: ', style: boldTextStyle())]),
        height10(),
        Row(
          children: [
            Expanded(
              child: RichText(
                  text: TextSpan(style: secondaryTextStyle(), children: [
                const TextSpan(text: 'Token name is'),
                TextSpan(
                  text: ' ${title ?? ''}',
                  style: boldTextStyle(color: context.primaryColor),
                ),
              ])),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: RichText(
                  text: TextSpan(style: secondaryTextStyle(), children: [
                const TextSpan(
                    text:
                        'Please don\'t deposit any other digital assets except'),
                TextSpan(
                  text: ' ${title ?? ''}',
                  style: boldTextStyle(color: context.primaryColor),
                ),
                const TextSpan(text: 'to the above address.'),
              ])),
            ),
          ],
        ),

        ///Minimum deposit amount:
        height10(),
        Row(children: [
          Text('Minimum deposit amount: ', style: boldTextStyle())
        ]),
        Row(
          children: [
            Expanded(
              child: RichText(
                  text: TextSpan(style: secondaryTextStyle(), children: [
                const TextSpan(text: 'The minimum deposit amount is '),
                TextSpan(
                  text: '0.0001 ${symbol ?? ''}',
                  style: boldTextStyle(color: context.primaryColor),
                ),
                const TextSpan(
                    text:
                        '. Any deposits less than the minimum will not be credited or refunded.\n'),
                const TextSpan(
                    text:
                        'Depositing to the above address requires confirmations of the entire network. It will be credited after'),
                TextSpan(
                    text: ' 1 network confirmations.',
                    style: boldTextStyle(color: context.primaryColor)),
              ])),
            ),
          ],
        ),
      ],
    );
  }
}
