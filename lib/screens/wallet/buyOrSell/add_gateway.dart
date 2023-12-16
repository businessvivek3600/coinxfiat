import 'package:coinxfiat/component/component_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../constants/constants_index.dart';
import '../../enums/enum_index.dart';

class AddGateway extends StatefulWidget {
  const AddGateway({super.key, this.requestId});
  final String? requestId;
  @override
  State<AddGateway> createState() => _AddGatewayState();
}

class _AddGatewayState extends State<AddGateway> {
  /// delete payment method
  void deletePaymentMethod(PaymentMethod type, dynamic data) {
    switch (type) {
      case PaymentMethod.bank:
        break;
      case PaymentMethod.card:
        break;
      case PaymentMethod.paytm ||
            PaymentMethod.amazonpay ||
            PaymentMethod.phonepe ||
            PaymentMethod.upi ||
            PaymentMethod.googlepay:
        break;

      case PaymentMethod.paypal:
        break;
      case PaymentMethod.skrill:
        break;
      default:
    }
    toast('${type.name.capitalizeFirstLetter()} deleted');
  }

  /// add payment method
  void addPaymentMethod(PaymentMethod type) {
    switch (type) {
      case PaymentMethod.bank:
        _showBankAccountDialog();
        break;
      case PaymentMethod.card:
        break;
      case PaymentMethod.paytm ||
            PaymentMethod.amazonpay ||
            PaymentMethod.phonepe ||
            PaymentMethod.upi ||
            PaymentMethod.googlepay:
        _showUPIDialog(type);
        break;

      case PaymentMethod.paypal:
        break;
      case PaymentMethod.skrill:
        _showSkrillDialog();
        break;
      default:
    }
  }

  /// edit payment method
  void editPaymentMethod(PaymentMethod type, dynamic data) {
    switch (type) {
      case PaymentMethod.bank:
        _showBankAccountDialog();
        break;
      case PaymentMethod.card:
        break;
      case PaymentMethod.paytm ||
            PaymentMethod.amazonpay ||
            PaymentMethod.phonepe ||
            PaymentMethod.upi ||
            PaymentMethod.googlepay:
        _showUPIDialog(type);
        break;

      case PaymentMethod.paypal:
        break;
      case PaymentMethod.skrill:
        _showSkrillDialog();
        break;
      default:
    }
  }

  /// show skrill dialog
  void _showSkrillDialog() {
    showDialog(
        context: context,
        builder: (context) => _SkrillDialog(
              update: true,
              initialValue: 'chiraggoel@okicici',
              remarks: '9876543210',
              type: PaymentMethod.skrill,
              onAdd: (acNo, remark) async {
                await 3.seconds.delay.then((value) {
                  print(acNo);
                  print(remark);
                  toast('Skrill added');
                });
                return true;
              },
            ));
  }

  /// show upi dialog
  void _showUPIDialog(PaymentMethod type) {
    showDialog(
        context: context,
        builder: (context) => _UPIDialog(
              update: true,
              initialValue: 'chiraggoel@okicici',
              mobileNumber: '9876543210',
              type: type,
              onAdd: (name, upiId) async {
                print(name);
                print(upiId);
                toast('UPI added');
                return true;
              },
            ));
  }

  /// show bank account dialog
  void _showBankAccountDialog() {
    showDialog(
        context: context,
        builder: (context) => _BankAccountDialog(
              update: true,
              name: 'Chirag Goel',
              onAdd: (name, accountNumber, ifscCode) async {
                print(name);
                print(accountNumber);
                print(ifscCode);
                toast('Bank account added');
                return true;
              },
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Gateway'),
      ),
      body: CustomScrollView(
        slivers: [
          /// chips for selecting the gateway , add bank account and add card
          _chips(),

          /// bank account
          ...[
            List.generate(5, (index) => PaymentMethod.bank).toList(),
            List.generate(5, (index) => PaymentMethod.card).toList(),
            List.generate(5, (index) => PaymentMethod.googlepay).toList(),
            List.generate(5, (index) => PaymentMethod.paypal).toList(),
            List.generate(5, (index) => PaymentMethod.paytm).toList(),
          ].map((e) => SliverStickyHeader(
                header: getHeader(e.first),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => getAccountTIle(i, e[i]),
                    childCount: e.length,
                  ),
                ),
              )),
          // SliverStickyHeader(
          //   header: const Header(title: 'Bank Account'),
          //   sliver: SliverList(
          //     delegate: SliverChildBuilderDelegate(
          //       (context, i) => _AccountTile(
          //         type: PaymentType.bank,
          //         name: 'Bank Account',
          //         subName: 'SBIN000000000005786$i',
          //         icon: 'assets/images/${MyPng.logo}',
          //         onEdit: editPaymentMethod,
          //         onDelete: deletePaymentMethod,
          //       ),
          //       childCount: 3,
          //     ),
          //   ),
          // ),

          // /// paytm
          // SliverStickyHeader(
          //   header: const Header(title: 'Paytm'),
          //   sliver: SliverList(
          //     delegate: SliverChildBuilderDelegate(
          //       (context, i) => _AccountTile(
          //         type: PaymentType.paytm,
          //         name: 'Paytm',
          //         subName: '9876543210$i',
          //         icon: FontAwesomeIcons.paypal,
          //         onEdit: editPaymentMethod,
          //         onDelete: deletePaymentMethod,
          //       ),
          //       childCount: 2,
          //     ),
          //   ),
          // ),

          // /// 5 paypal
          // SliverStickyHeader(
          //   header: const Header(title: 'PayPal'),
          //   sliver: SliverList(
          //     delegate: SliverChildBuilderDelegate(
          //       (context, i) => _AccountTile(
          //         type: PaymentType.paypal,
          //         name: 'PayPal',
          //         subName: '9876543210$i',
          //         icon: FontAwesomeIcons.paypal,
          //         onEdit: editPaymentMethod,
          //         onDelete: deletePaymentMethod,
          //       ),
          //       childCount: 5,
          //     ),
          //   ),
          // ),

          // ///3 skrill
          // SliverStickyHeader(
          //   header: const Header(title: 'Skrill'),
          //   sliver: SliverList(
          //     delegate: SliverChildBuilderDelegate(
          //       (context, i) => _AccountTile(
          //         type: PaymentType.skrill,
          //         name: 'Skrill',
          //         subName: '9876543210$i',
          //         icon: FontAwesomeIcons.paypal,
          //         onEdit: editPaymentMethod,
          //         onDelete: deletePaymentMethod,
          //       ),
          //       childCount: 3,
          //     ),
          //   ),
          // ),

          // ///6 google pay
          // SliverStickyHeader(
          //   header: const Header(title: 'Google Pay'),
          //   sliver: SliverList(
          //     delegate: SliverChildBuilderDelegate(
          //       (context, i) => _AccountTile(
          //         type: PaymentType.googlepay,
          //         name: 'Google Pay',
          //         subName: '9876543210$i',
          //         icon: FontAwesomeIcons.paypal,
          //         onEdit: editPaymentMethod,
          //         onDelete: deletePaymentMethod,
          //       ),
          //       childCount: 6,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  _AccountTile getAccountTIle(int i, PaymentMethod e) {
    return _AccountTile(
      type: e,
      name: e.name,
      subName: e == PaymentMethod.bank
          ? 'SBIN000000000005786$i'
          : e == PaymentMethod.card
              ? '8333 3333 3333 333$i'
              : e == PaymentMethod.googlepay
                  ? '9876543210$i'
                  : e == PaymentMethod.paypal
                      ? '9876543210$i'
                      : e == PaymentMethod.paytm
                          ? '9876543210$i'
                          : e == PaymentMethod.skrill
                              ? '9876543210$i'
                              : '',
      icon: 'assets/images/${MyPng.logo}',
      onEdit: editPaymentMethod,
      onDelete: deletePaymentMethod,
    );
  }

  Header getHeader(PaymentMethod e) => Header(
        title: e == PaymentMethod.bank
            ? 'Bank Account'
            : e.name == 'Paytm'
                ? 'Paytm'
                : e.name == 'PayPal'
                    ? 'PayPal'
                    : e.name == 'Skrill'
                        ? 'Skrill'
                        : e.name == 'Google Pay'
                            ? 'Google Pay'
                            : e.name == 'Amazon Pay'
                                ? 'Amazon Pay'
                                : e.name == 'PhonePe'
                                    ? 'PhonePe'
                                    : e.name == 'UPI'
                                        ? 'UPI'
                                        : e.name == 'Card'
                                            ? 'Card'
                                            : 'Unknown',
      );

  SliverToBoxAdapter _chips() {
    return SliverToBoxAdapter(
      child: Wrap(
        spacing: DEFAULT_PADDING,
        children: [
          /// add bank account
          _AddPaymentMehodChip(
            type: PaymentMethod.bank,
            name: 'Bank Account',
            icon: 'assets/images/${MyPng.logo}',
            onTap: addPaymentMethod,
          ),

          /// add card
          _AddPaymentMehodChip(
              type: PaymentMethod.card,
              name: 'Card',
              icon: FontAwesomeIcons.creditCard,
              onTap: addPaymentMethod),

          /// add paytm
          _AddPaymentMehodChip(
              type: PaymentMethod.paytm,
              name: 'Paytm',
              icon: FontAwesomeIcons.paypal,
              onTap: addPaymentMethod),

          /// add upi
          _AddPaymentMehodChip(
              type: PaymentMethod.upi,
              name: 'UPI',
              icon: FontAwesomeIcons.buildingColumns,
              onTap: addPaymentMethod),

          /// add phonepe
          _AddPaymentMehodChip(
              type: PaymentMethod.phonepe,
              name: 'PhonePe',
              icon: FontAwesomeIcons.buildingColumns,
              onTap: addPaymentMethod),

          /// add google pay
          _AddPaymentMehodChip(
              type: PaymentMethod.googlepay,
              name: 'Google Pay',
              icon: FontAwesomeIcons.buildingColumns,
              onTap: addPaymentMethod),

          /// add amazon pay
          _AddPaymentMehodChip(
              type: PaymentMethod.amazonpay,
              name: 'Amazon Pay',
              icon: FontAwesomeIcons.buildingColumns,
              onTap: addPaymentMethod),

          /// add paypal
          _AddPaymentMehodChip(
              type: PaymentMethod.paypal,
              name: 'PayPal',
              icon: FontAwesomeIcons.buildingColumns,
              onTap: addPaymentMethod),

          /// add skrill
          _AddPaymentMehodChip(
              type: PaymentMethod.skrill,
              name: 'Skrill',
              icon: FontAwesomeIcons.buildingColumns,
              onTap: addPaymentMethod),

          /// add none
          _AddPaymentMehodChip(
              type: PaymentMethod.none,
              name: 'None',
              icon: FontAwesomeIcons.circleQuestion,
              onTap: addPaymentMethod),
        ],
      ).paddingAll(DEFAULT_PADDING),
    );
  }
}

/// add skrill dialog
class _SkrillDialog extends StatelessWidget {
  _SkrillDialog({
    this.update = false,
    String? initialValue,
    String? remarks,
    super.key,
    this.onAdd,
    required this.type,
  })  : _skrillIdController = TextEditingController(text: initialValue)
          ..selection = TextSelection.collapsed(offset: initialValue!.length),
        _remarksController = TextEditingController(text: remarks)
          ..selection = TextSelection.collapsed(offset: remarks!.length);
  final bool update;
  final Future<bool> Function(String acNo, String remark)? onAdd;
  final TextEditingController _skrillIdController;
  final TextEditingController _remarksController;
  final PaymentMethod type;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
          Text(update ? 'Update Skrill Information' : 'Add Skrill Information'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextField(
            hintText: 'Account Number',
            controller: _skrillIdController,
          ),
          CustomTextField(
            hintText: 'Remarks',
            controller: _remarksController,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            if (onAdd != null) {
              await onAdd!(_skrillIdController.text, _remarksController.text)
                  .then((value) => Navigator.pop(context));
            } else {
              Navigator.pop(context);
            }
          },
          child: Text(update ? 'Updates' : 'Add'),
        ),
      ],
    );
  }
}

/// add upi dialog
class _UPIDialog extends StatelessWidget {
  _UPIDialog({
    this.update = false,
    String? initialValue,
    String? mobileNumber,
    super.key,
    this.onAdd,
    required this.type,
  })  : _upiIdController = TextEditingController(text: initialValue)
          ..selection = TextSelection.collapsed(offset: initialValue!.length),
        _mobileNumberController = TextEditingController(text: mobileNumber)
          ..selection = TextSelection.collapsed(offset: mobileNumber!.length);
  final bool update;
  final Future<bool> Function(String name, String upiId)? onAdd;
  final TextEditingController _upiIdController;
  final TextEditingController _mobileNumberController;
  final PaymentMethod type;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(update ? 'Update UPI ID' : 'Add UPI ID'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextField(
            hintText: 'Name',
            controller: _mobileNumberController,
          ),
          CustomTextField(
            hintText: 'UPI ID',
            controller: _upiIdController,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            if (onAdd != null) {
              await onAdd!(_mobileNumberController.text, _upiIdController.text)
                  .then((value) => Navigator.pop(context));
            } else {
              Navigator.pop(context);
            }
          },
          child: Text(update ? 'Update' : 'Add'),
        ),
      ],
    );
  }
}

/// add bank account dialog
class _BankAccountDialog extends StatelessWidget {
  _BankAccountDialog({
    this.update = false,
    String? name,
    String? accountNumber,
    String? ifscCode,
    super.key,
    this.onAdd,
  })  : _nameController = TextEditingController(text: name),
        _accountNumberController = TextEditingController(text: accountNumber),
        _ifscCodeController = TextEditingController(text: ifscCode);
  final bool update;
  final Future<bool> Function(
      String name, String accountNumber, String ifscCode)? onAdd;
  final TextEditingController _nameController;
  final TextEditingController _accountNumberController;
  final TextEditingController _ifscCodeController;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(update ? 'Update Bank Account' : 'Add Bank Account'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextField(
            hintText: 'Account holder name',
            controller: _nameController,
          ),
          CustomTextField(
            hintText: 'Account number',
            controller: _accountNumberController,
          ),
          CustomTextField(
            hintText: 'IFSC Code',
            controller: _ifscCodeController,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            if (onAdd != null) {
              await onAdd!(_nameController.text, _accountNumberController.text,
                      _ifscCodeController.text)
                  .then((value) => Navigator.pop(context));
            } else {
              Navigator.pop(context);
            }
          },
          child: Text(update ? 'Update' : 'Add'),
        ),
      ],
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DEFAULT_PADDING,
        vertical: DEFAULT_PADDING / 3,
      ),
      decoration:
          const BoxDecoration(color: Color.fromARGB(255, 214, 214, 214)),
      child: Text(title, style: boldTextStyle(color: context.accentColor)),
    );
  }
}

class _AccountTile extends StatelessWidget {
  const _AccountTile({
    super.key,
    required this.name,
    this.icon,
    this.onEdit,
    this.onDelete,
    required this.type,
    this.subName,
  });
  final String name;
  final String? subName;
  final dynamic icon;
  final Function(PaymentMethod, dynamic data)? onEdit;
  final Function(PaymentMethod, dynamic data)? onDelete;
  final PaymentMethod type;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(DEFAULT_RADIUS),
        ),
        child: icon is IconData
            ? FaIcon(icon, size: 18)
            : icon is String
                ? Image.asset(
                    icon,
                    height: 18,
                    frameBuilder:
                        (context, child, frame, wasSynchronouslyLoaded) =>
                            frame == null ? const SizedBox() : child,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox(),
                  )
                : const SizedBox(),
      ),
      title: Text(name),
      subtitle: Text(subName ?? ''),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => onEdit?.call(type, subName),
            icon: const FaIcon(FontAwesomeIcons.edit),
          ),
          IconButton(
            onPressed: () => onDelete?.call(type, subName),
            icon: const FaIcon(FontAwesomeIcons.trash),
          ),
        ],
      ),
    );
  }
}

class _AddPaymentMehodChip extends StatelessWidget {
  const _AddPaymentMehodChip({
    super.key,
    required this.name,
    this.icon,
    this.onTap,
    required this.type,
  });
  final String name;
  final dynamic icon;
  final Function(PaymentMethod)? onTap;
  final PaymentMethod type;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            icon is IconData
                ? FaIcon(icon, size: 18)
                : icon is String
                    ? Image.asset(
                        icon,
                        height: 18,
                        frameBuilder:
                            (context, child, frame, wasSynchronouslyLoaded) =>
                                frame == null ? const SizedBox() : child,
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox(),
                      )
                    : const SizedBox(),
          if (icon != null) 10.width,
          Text(name),
        ],
      ),
      avatar: CircleAvatar(
        backgroundColor: context.primaryColor.withOpacity(0.5),
        child: FittedBox(
          child: const FaIcon(FontAwesomeIcons.plus, color: Colors.white)
              .paddingAll(DEFAULT_PADDING / 2)
              .center(),
        ),
      ),
    ).onTap(() => onTap?.call(type), borderRadius: BorderRadius.circular(100));
  }
}
