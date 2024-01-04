import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../constants/constants_index.dart';
import '../../model/model_index.dart';
import '../../services/service_index.dart';
import '../../utils/utils_index.dart';

class WalletDetails extends StatefulWidget {
  const WalletDetails(
      {super.key, this.code, this.name, this.address, this.bal});
  final String? code;
  final String? name;
  final String? address;
  final String? bal;

  @override
  State<WalletDetails> createState() => _WalletDetailsState();
}

class _WalletDetailsState extends State<WalletDetails> {
  ValueNotifier<bool> loading = ValueNotifier<bool>(true);
  ValueNotifier<bool> loadingMore = ValueNotifier<bool>(false);
  String? name;
  String? walletAddress;
  double walletBalance = 0;
  setWalletName(String? name) => setState(() => this.name = name);
  setWalletAddress(String? address) => setState(() => walletAddress = address);
  setWalletBalance(String? bal) =>
      setState(() => walletBalance = double.tryParse(bal ?? '0').validate());
  ValueNotifier<List<WalletTransaction>> trxList =
      ValueNotifier<List<WalletTransaction>>([]);

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      setWalletName(widget.name);
      setWalletAddress(widget.address);
      setWalletBalance(widget.bal);
      getData(refresh: true);
    });
  }

  Future<void> getData({int page = 1, bool refresh = false}) async {
    if (refresh) {
      loading.value = true;
      loadingMore.value = false;
    } else {
      loading.value = true;
      loadingMore.value = true;
    }
    await Apis.getWalletTransactionsApi(
            type: widget.code == '-' ? '' : (widget.code ?? ''), page: page)
        .then(
      (value) {
        p(value);
        if (value.$2.entries.isNotEmpty) {
          List<Wallet> walletList = tryCatch<List<Wallet>>(() {
                return (value.$2['wallets'] ?? [])
                    .map<Wallet>((e) => Wallet.fromJson(e))
                    .toList();
              }) ??
              [];
          p('walletList: ${walletList.length}');
          if (walletList.isNotEmpty) {
            setWalletName(walletList[0].crypto?.name);
            setWalletBalance(walletList[0].balance.toString());
            setWalletAddress(walletList[0].walletAddress);
          }
          List<WalletTransaction> trxList = tryCatch<List<WalletTransaction>>(
                () => (value.$2['transactions']['data'] ?? [])
                    .map<WalletTransaction>(
                        (e) => WalletTransaction.fromJson(e))
                    .toList(),
              ) ??
              [];
          if (refresh) {
            this.trxList.value = trxList;
          } else {
            this.trxList.value = [...this.trxList.value, ...trxList];
          }
          p('trxList: ${this.trxList.value.length}');
        }
      },
    );
    loading.value = false;
    loadingMore.value = false;
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold();
    return ValueListenableBuilder<bool>(
        valueListenable: loading,
        builder: (_, loading, __) {
          return Scaffold(
            appBar: AppBar(
                title: Text(widget.name ?? 'Wallet Details'),
                centerTitle: true,
                elevation: 0),
            body: ListView(
              children: [
                ///wallet detail
                _walletDetail(context, loading),

                ///transaction
                _transaction(context, loading),
              ],
            ),
          );
        });
  }

  Widget _transaction(BuildContext context, bool loading) {
    return Container(
      margin: const EdgeInsets.only(
          left: DEFAULT_PADDING, right: DEFAULT_PADDING, top: DEFAULT_PADDING),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///transaction title
          Text('Transactions', style: boldTextStyle()),

          ///transaction list
          loading
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    return _transactionItem(
                      context,
                      trxId: 'trxId',
                      title: '--------',
                      amount: '0000000000.0 ETH',
                      remark: '------------------',
                      time: '---------',
                      loading: loading,
                    );
                  },
                )
              : ValueListenableBuilder<List<WalletTransaction>>(
                  valueListenable: trxList,
                  builder: (_, trxList, __) {
                    if (trxList.isEmpty) {
                      return SizedBox(
                          height: context.height() * 0.5,
                          child: const Text('No transaction found').center());
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: trxList.length,
                        itemBuilder: (context, index) {
                          WalletTransaction trx = trxList[index];
                          bool isSend = trx.trxType?.toLowerCase() != '+';

                          return _transactionItem(
                            context,
                            trxId:
                                Wallet().formatWalletAddress(trx.trxId ?? ''),
                            title: isSend ? 'Send' : 'Received',
                            amount:
                                '${trx.amount.convertDouble(8)} ${trx.code ?? ''}',
                            remark: trx.remarks,
                            time: MyDateUtils.formatDateAsToday(trx.createdAt),
                            loading: loading,
                          );
                        },
                      );
                    }
                  }),
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
    bool loading = false,
  }) {
    bool isSend = title.toLowerCase() == 'send';
    return Skeletonizer(
      enabled: loading,
      textBoneBorderRadius: TextBoneBorderRadius(BorderRadius.circular(3)),
      child: Container(
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
              child: loading
                  ? const SizedBox(width: 24, height: 24)
                  : Transform.rotate(
                      angle: 3.14 / 4,
                      child: Icon(
                        isSend
                            ? FontAwesomeIcons.arrowUp
                            : FontAwesomeIcons.arrowDown,
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
      ),
    );
  }

  Widget _walletDetail(BuildContext context, bool loading) {
    return Container(
      margin: const EdgeInsets.only(
          left: DEFAULT_PADDING, right: DEFAULT_PADDING, top: DEFAULT_PADDING),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///wallet name
          Text(widget.name ?? (loading ? 'Loading...' : 'Wallet'),
              style: boldTextStyle()),

          ///wallet amount
          Text(walletBalance.toString(), style: boldTextStyle(size: 24)),

          ///wallet address
          Row(
            children: [
              Text(Wallet().formatWalletAddress(walletAddress),
                  style: secondaryTextStyle()),

              ///copy
              IconButton(
                  onPressed: walletAddress != null
                      ? () => Clipboard.setData(
                              ClipboardData(text: walletAddress.validate()))
                          .then((value) => toast('Wallet address copied'))
                      : null,
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
                onTap: () => _showDepositDialog(
                  context,
                  title: widget.code,
                  symbol: widget.name,
                ),
              ),

              ///buy
              _walletAction(
                context,
                icon: FontAwesomeIcons.cartShopping,
                title: 'Withdraw',
                onTap: () => _showWithdrawDialog(context, title: widget.code),
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
      builder: (context) => _WalletDepositDialog(
          walletAddress: walletAddress.validate(),
          title: title,
          symbol: symbol),
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
    required this.walletAddress,
  });
  final String walletAddress;
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(Wallet().formatWalletAddress(walletAddress),
                style: boldTextStyle()),
            width10(),

            ///copy
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(FontAwesomeIcons.copy, size: 16),
              width5(),
              Text('Copy', style: secondaryTextStyle())
            ]).paddingAll(DEFAULT_RADIUS).onTap(
                  () => Clipboard.setData(
                          ClipboardData(text: walletAddress.validate()))
                      .then((value) => toast('Wallet address copied')),
                  borderRadius: BorderRadius.circular(10),
                ),
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
