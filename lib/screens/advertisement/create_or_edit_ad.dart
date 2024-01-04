import 'dart:convert';
import 'dart:math';

import 'package:coinxfiat/model/model_index.dart';
import 'package:coinxfiat/store/app_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../component/component_index.dart';
import '../../constants/constants_index.dart';
import '../../services/service_index.dart';
import '../../utils/utils_index.dart';

class CreateOrEditAdScreen extends StatefulWidget {
  const CreateOrEditAdScreen({super.key, this.id, required this.type});
  final String type;
  final String? id;

  @override
  State<CreateOrEditAdScreen> createState() => _CreateOrEditAdScreenState();
}

class _CreateOrEditAdScreenState extends State<CreateOrEditAdScreen> {
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(true);
  bool newAD = true;
  ValueNotifier<Advertisement?> advertisement =
      ValueNotifier<Advertisement?>(null);
  ValueNotifier<List<Crypto>> cryptos = ValueNotifier<List<Crypto>>([]);
  ValueNotifier<List<Crypto>> fiats = ValueNotifier<List<Crypto>>([]);
  ValueNotifier<List<Gateways>> paymentMethods =
      ValueNotifier<List<Gateways>>([]);
  ValueNotifier<List<PaymentWindow>> paymentWindows =
      ValueNotifier<List<PaymentWindow>>([]);

  ///form values
  final _formKey = GlobalKey<FormState>();
  String? selectedType;
  Crypto? selectedCrypto;
  Crypto? selectedFiat;
  List<Gateways> selectedPaymentMethods = [];
  PaymentWindow? selectedPaymentWindow;
  final rateController = TextEditingController();
  final minLimitController = TextEditingController();
  final maxLimitController = TextEditingController();

  final paymentDetailsController = TextEditingController();
  final termsOfTradeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    newAD = widget.type == 'create';
    pl('initState ${widget.type} ${widget.id}');
    init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> init() async {
    await (widget.type == 'create'
            ? Apis.createAdGetDataApi()
            : Apis.updateAdGetDataApi(widget.id ?? '-1'))
        .then((value) {
      if (value.$1) {
        if (!newAD) {
          advertisement.value =
              tryCatch(() => Advertisement.fromJson(value.$2['advertise']));
        }
        cryptos.value = tryCatch(() => value.$2['cryptos']
                .map<Crypto>((e) => Crypto.fromJson(e))
                .toList()) ??
            [];
        fiats.value = tryCatch(() => value.$2['fiats']
                .map<Crypto>((e) => Crypto.fromJson(e))
                .toList()) ??
            [];
        paymentMethods.value = tryCatch(() => value.$2['gateways']
                .map<Gateways>((e) => Gateways.fromJson(e))
                .toList()) ??
            [];
        paymentWindows.value = tryCatch(() => value.$2['paymentWindows']
                .map<PaymentWindow>((e) => PaymentWindow.fromJson(e))
                .toList()) ??
            [];
        pl('ad: ${advertisement.value} cryptos ${cryptos.value.length} fiats ${fiats.value.length} paymentMethods ${paymentMethods.value.length} paymentWindows ${paymentWindows.value.length}');
      }
    });
    isLoading.value = false;
  }

  // This should be a call to the api or service or similar
  Future<List<Pair>> _getFakeRequestData(String query) async {
    return await Future.delayed(const Duration(seconds: 1), () {
      return _list.where((e) {
        return e.text.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  Future<List<Map<String, dynamic>>> _getPaymentMethods(query) async {
    return Future.delayed(const Duration(seconds: 0), () {
      return paymentMethods.value
          .where((element) {
            return element.name
                .validate()
                .toLowerCase()
                .contains(query.toLowerCase());
          })
          .toList()
          .map((e) => {'uuid': e.id, 'name': e.name, 'image': e.imageUrl})
          .toList();
    });
  }

  String _getPriceEquation() {
    var equation = '';
    equation =
        '${double.tryParse(rateController.text) ?? 0.0} ${selectedFiat?.code ?? 'NA'} / ${selectedCrypto?.code ?? 'NA'}';
    return equation;
  }

  ///submit button
  Future<void> _onSubmit() async {
    // finish(context, [
    //   tryCatch<Advertisement>(
    //     () => Advertisement.fromJson({
    //       "user_id": 8,
    //       "type": "Buy",
    //       "crypto_id": 9,
    //       "fiat_id": 10,
    //       "gateway_id": selectedPaymentMethods.map((e) => e.id).toList(),
    //       "crypto_rate": 1890.07,
    //       "fiat_rate": 3436434,
    //       "price_type": "fixed",
    //       "price": rateController.text,
    //       "rate": rateController.text,
    //       "payment_window_id": selectedPaymentWindow?.id,
    //       "minimum_limit": minLimitController.text,
    //       "maximum_limit": maxLimitController.text,
    //       "payment_details": paymentDetailsController.text,
    //       "terms_of_trade": termsOfTradeController.text,
    //       "updated_at": DateTime.now().toString(),
    //       "created_at": DateTime.now().toString(),
    //       "id": Random().nextInt(10000),
    //       "currency_rate":
    //           '${selectedFiat?.code ?? 'NA'} / ${selectedCrypto?.code ?? 'NA'}',
    //       "gateways": selectedPaymentMethods.map((e) => e.toJson()).toList(),
    //       "fiat_currency": selectedFiat?.toJson(),
    //       "crypto_currency": selectedCrypto?.toJson(),
    //     }),
    //   ),
    // ]);
    hideKeyboard(context);
    // return;
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var data = {
        "type": selectedType ?? '',
        "crypto_id": selectedCrypto?.id ?? '',
        "gateway_id": selectedPaymentMethods.map((e) => e.id).toList(),
        "fiat_id": selectedFiat?.id ?? '',
        "price_type": "fixed",
        "price": rateController.text,
        "payment_window_id": selectedPaymentWindow?.id ?? '',
        "minimum_limit": minLimitController.text,
        "maximum_limit": maxLimitController.text,
      };
      var data2 = {
        "type": "",
        "gateway_id": "2,3",
        "fiat_id": "",
        "price_type": "",
        "price": "",
        "payment_window_id": "",
        "minimum_limit": "",
        "maximum_limit": ""
      };
      print(jsonEncode(data));
      appStore.setLoading(true);
      await Apis.createAdApi(data).then((value) {
        if (value.$1) {
          toast(value.$3 ?? 'New advertisment created successfully',
              bgColor: Colors.green,
              textColor: Colors.white,
              gravity: ToastGravity.TOP);
          Advertisement? ad = tryCatch(
              () => Advertisement.fromJson(value.$2['data']['advertisement']));
          finish(context, [ad]);
        }
      });
      appStore.setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    pl('selected --- type $selectedType selectedCrypto ${selectedCrypto?.name} selectedFiat ${selectedFiat?.name} selectedPaymentMethod ${selectedPaymentMethods?.length} selectedPaymentWindow ${selectedPaymentWindow?.name}');
    return GestureDetector(
      onTap: () => hideKeyboard(context),
      child: Scaffold(
        key: widget.key,
        appBar: _appBar(),
        body: Form(
          key: _formKey,
          child: AnimatedScrollView(
            padding: const EdgeInsets.all(DEFAULT_PADDING),
            children: [
              /// sell or buy dropdown field on read only text field
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// sell or buy dropdown field

                  Expanded(
                    child: MyDropdown(
                      titleText: 'I want to',
                      hintText: 'Select Type',
                      toolTipText:
                          'What kind of advertisement do you wish to create? If you wish to sell bitcoins make sure you have bitcoins in your wallet.',
                      initialItems: _typeList,
                      validator: (item) {
                        if (item == null) {
                          return 'Please select one';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() => selectedType = _typeList
                            .firstWhereOrNull(
                                (element) => element.key == value?.key)
                            ?.text);
                      },
                    ),
                  ),
                  10.width,

                  /// Cryptocurrency dropdown field

                  Expanded(
                    child: ValueListenableBuilder<List<Crypto>>(
                        valueListenable: cryptos,
                        builder: (_, value, __) {
                          return MyDropdown(
                            titleText: 'Cryptocurrency',
                            hintText: 'Select Cryptocurrency',
                            toolTipText:
                                'Which cryptocurrency do you wish to buy or sell?',
                            initialItems: value
                                .where((element) =>
                                    element.id != null &&
                                    element.name.validate().isNotEmpty)
                                .map<Pair>((e) =>
                                    Pair(key: e.id, text: e.name.validate()))
                                .toList(),
                            validator: (item) {
                              if (item == null) {
                                return 'Please select one';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() => selectedCrypto = cryptos.value
                                  .firstWhereOrNull(
                                      (element) => element.id == value?.key));
                            },
                          );
                        }),
                  ),
                ],
              ),
              10.height,

              ///Payment Method
              ValueListenableBuilder<List<Gateways>>(
                  valueListenable: paymentMethods,
                  builder: (_, methods, c) {
                    return MultiSelectField(
                      titleText: 'Payment Method',
                      hintText: 'Select Payment Method',
                      toolTipText:
                          'Which payment method will be used to pay the fiat currency?',
                      initialItems: const [],
                      onRequest: _getPaymentMethods,
                      onChanged: (value) {
                        selectedPaymentMethods.clear();
                        for (var item in value) {
                          var gateway = methods.firstWhereOrNull(
                              (element) => element.id == item['uuid']);
                          if (gateway != null) {
                            selectedPaymentMethods.add(gateway);
                          }
                        }
                        setState(() {});
                      },
                      validator: (value, selectedItemsAsync) {
                        if (selectedItemsAsync.isEmpty) {
                          return 'Please select one or more payment methods';
                        }
                        return null;
                      },
                      leadingBuilder: (context, state, data, selected) {
                        return Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              backgroundImage:
                                  netImages(data['image'].toString().validate())
                                      .image),
                        );
                      },
                      trailingBuilder: (context, state, data, selected) {
                        return selected
                            ? const FaIcon(FontAwesomeIcons.circleCheck,
                                color: completedColor, size: 18)
                            : null;
                      },
                    );
                  }),
              10.height,
              Row(
                children: [
                  ///Currency dropdown field
                  Expanded(
                    child: ValueListenableBuilder<List<Crypto>>(
                        valueListenable: fiats,
                        builder: (_, value, __) {
                          return MyDropdown(
                            titleText: 'Currency',
                            hintText: 'Select Currency',
                            toolTipText:
                                'Which fiat currency needs exchange from cryptocurrency?',
                            initialItems: value
                                .where((element) =>
                                    element.id != null &&
                                    element.name.validate().isNotEmpty)
                                .map<Pair>((e) =>
                                    Pair(key: e.id, text: e.name.validate()))
                                .toList(),
                            validator: (item) {
                              if (item == null) {
                                return 'Please select one';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() => selectedFiat = fiats.value
                                  .firstWhereOrNull(
                                      (element) => element.id == value?.key));
                            },
                          );
                        }),
                  ),
                  10.width,

                  ///Payment Window
                  Expanded(
                    child: ValueListenableBuilder<List<PaymentWindow>>(
                        valueListenable: paymentWindows,
                        builder: (_, value, __) {
                          return MyDropdown(
                            titleText: 'Payment Window ',
                            hintText: 'Select one',
                            toolTipText:
                                'For Buyer: Within how many minutes do you promise to initiate the payment. For Seller: Within how many minutes you want to get paid',
                            initialItems: value
                                .where((element) =>
                                    element.id != null &&
                                    element.name.validate().isNotEmpty)
                                .map<Pair>((e) =>
                                    Pair(key: e.id, text: e.name.validate()))
                                .toList(),
                            validator: (item) {
                              if (item == null) {
                                return 'Please select one';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() => selectedPaymentWindow =
                                  paymentWindows.value.firstWhereOrNull(
                                      (element) => element.id == value?.key));
                            },
                          );
                        }),
                  ),
                ],
              ),

              10.height,
              CustomTextField(
                controller: rateController,
                titleText: 'Currency Rate ',
                hintText: 'Enter Currency Rate',
                toolTipText:
                    'The margin you want over the bitcoin market price. Use a negative value for buying or selling under the market price to attract more contacts.',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  ///only one dot allowed and digits only,while unlimited decimal places
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,}')),
                ],
                onChanged: (value) => setState(() {}),
                enabled: selectedFiat != null,
                validator: (item) {
                  if (item == null || item.isEmpty) {
                    return 'Currency Rate is required';
                  }
                  return null;
                },
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(selectedFiat?.code.validate() ?? 'Currency?',
                            style: boldTextStyle(
                                color: selectedFiat != null
                                    ? context.primaryColor
                                    : Colors.grey))
                        .center()
                        .paddingRight(DEFAULT_PADDING),
                  ],
                ),
              ),
              10.height,

              ///limits
              Row(
                children: [
                  ///Minimum Transaction Limit

                  Expanded(
                    child: CustomTextField(
                      controller: minLimitController,
                      titleText: 'Minimum Limit',
                      hintText: 'e.g. 100',
                      initialValue: '0.00',
                      toolTipText: 'Minimum transaction limit in one trade.?',
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        ///only one dot allowed and digits only,while unlimited decimal places
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,}')),
                      ],
                      enabled: selectedFiat != null,
                      validator: (item) {
                        if (item == null || item.isEmpty) {
                          return 'Minimum Limit is required';
                        }
                        return null;
                      },
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(selectedFiat?.code.validate() ?? 'Currency?',
                                  style: boldTextStyle(
                                      color: selectedFiat != null
                                          ? context.primaryColor
                                          : Colors.grey))
                              .center()
                              .paddingRight(DEFAULT_PADDING),
                        ],
                      ),
                      onChanged: (value) {},
                    ),
                  ),
                  10.width,

                  ///Maximum Transaction Limit
                  Expanded(
                    child: CustomTextField(
                      controller: maxLimitController,
                      titleText: 'Maximum Limit',
                      hintText: 'e.g. 100',
                      initialValue: '0.00',
                      toolTipText: 'Maximum transaction limit in one trade.?',
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        ///only one dot allowed and digits only,while unlimited decimal places
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,}')),
                      ],
                      enabled: selectedFiat != null,
                      validator: (item) {
                        if (item == null || item.isEmpty) {
                          return 'Maximum Limit is required';
                        }
                        return null;
                      },
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(selectedFiat?.code.validate() ?? 'Currency?',
                                  style: boldTextStyle(
                                      color: selectedFiat != null
                                          ? context.primaryColor
                                          : Colors.grey))
                              .center()
                              .paddingRight(DEFAULT_PADDING),
                        ],
                      ),
                      onChanged: (value) {},
                    ),
                  ),
                ],
              ),
              10.height,

              /// Price Equation: 1890.07 USD/ETH
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: 'Price Equation: ', style: secondaryTextStyle()),
                    TextSpan(
                        text: _getPriceEquation(),
                        style: boldTextStyle(color: context.primaryColor)),
                  ],
                ),
              ),
              10.height,

              ///Payment Details
              CustomTextField(
                controller: paymentDetailsController,
                titleText: 'Payment Details',
                hintText: '',
                initialValue: '',
                maxLines: 5,
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                onChanged: (value) {},
              ),

              10.height,

              ///Terms of Trade
              CustomTextField(
                controller: termsOfTradeController,
                titleText: 'Terms of Trade',
                hintText: '',
                initialValue: '',
                maxLines: 5,
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                onChanged: (value) {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title:
          Text('${widget.type == 'create' ? 'New' : 'Update'} Advertisement'),
      actions: [
        ///submit button
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              child: TextButton(
                onPressed: _onSubmit,
                child:
                    Text('Submit', style: boldTextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
        DEFAULT_PADDING.toInt().width,
      ],
    );
  }
}

List<Pair> _typeList = [
  Pair(key: 'buy', text: 'Buy', icon: Icons.developer_board),
  Pair(key: 'sell', text: 'Sell', icon: Icons.deblur_sharp),
];

List<Pair> _list = [
  Pair(key: 1, text: 'Developer', icon: Icons.developer_board),
  Pair(key: 2, text: 'Designer', icon: Icons.deblur_sharp),
  Pair(key: 3, text: 'Consultant', icon: Icons.money_off),
  Pair(key: 4, text: 'Student', icon: Icons.edit),
];
