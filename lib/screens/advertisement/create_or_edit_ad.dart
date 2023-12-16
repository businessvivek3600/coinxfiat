import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../component/component_index.dart';
import '../../constants/constants_index.dart';

class CreateOrEditAdScreen extends StatefulWidget {
  const CreateOrEditAdScreen({super.key, this.id, required this.type});
  final String type;
  final String? id;

  @override
  State<CreateOrEditAdScreen> createState() => _CreateOrEditAdScreenState();
}

class _CreateOrEditAdScreenState extends State<CreateOrEditAdScreen> {
  final _formKey = GlobalKey<FormState>();

  String selectedValue = '';

  // This should be a call to the api or service or similar
  Future<List<Pair>> _getFakeRequestData(String query) async {
    return await Future.delayed(const Duration(seconds: 1), () {
      return _list.where((e) {
        return e.text.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  List<Map<String, dynamic>> data = [
    {"uuid": 1, "name": "Alfred Johanson"},
    {"uuid": 2, "name": "Goran Borovic"},
    {"uuid": 3, "name": "Ivan Horvat"},
    {"uuid": 4, "name": "Bjorn Sigurdson"}
  ];

  Future<List<Map<String, dynamic>>> searchFunctionAsync(query) async {
    return Future.delayed(const Duration(seconds: 1), () {
      return data.where((element) {
        return element["name"].toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  Map<String, dynamic> selectedMultiSelect = {};

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => hideKeyboard(context),
      child: Scaffold(
        key: widget.key,
        appBar: AppBar(
          title: Text(
              '${widget.type == 'create' ? 'New' : 'Update'} Advertisement'),
          actions: [
            ///submit button
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  child: TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        toast('Form submitted');
                      }
                    },
                    child: Text('Submit',
                        style: boldTextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
            DEFAULT_PADDING.toInt().width,
          ],
        ),
        body: Form(
          key: _formKey,
          child: AnimatedScrollView(
            padding: const EdgeInsets.all(DEFAULT_PADDING),
            children: [
              /// sell or buy dropdown field on read only text field
              Row(
                children: [
                  /// sell or buy dropdown field

                  Expanded(
                    child: SearchRequestDropdown(
                      titleText: 'I want to',
                      hintText: 'Select Type',
                      toolTipText:
                          'What kind of advertisement do you wish to create? If you wish to sell bitcoins make sure you have bitcoins in your wallet.',
                      initialItems: _list,
                      onRequest: _getFakeRequestData,
                      onChanged: (value) {
                        setState(() => selectedValue = value?.text ?? '');
                      },
                    ),
                  ),
                  10.width,

                  /// Cryptocurrency dropdown field

                  Expanded(
                    child: SearchRequestDropdown(
                      titleText: 'Cryptocurrency',
                      hintText: 'Select Cryptocurrency',
                      toolTipText:
                          'Which cryptocurrency do you wish to buy or sell?',
                      initialItems: _list,
                      onRequest: _getFakeRequestData,
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value?.text ?? '';
                        });
                      },
                    ),
                  ),
                ],
              ),
              10.height,
              MultiSelectField(
                titleText: 'Payment Method',
                hintText: 'Select Payment Method',
                toolTipText:
                    'Which payment method will be used to pay the fiat currency?',
                initialItems: data,
                onRequest: searchFunctionAsync,
                onChanged: (value) {
                  setState(() => selectedMultiSelect = value);
                },
              ),
              10.height,
              Row(
                children: [
                  ///Currency dropdown field
                  Expanded(
                    child: SearchRequestDropdown(
                      titleText: 'Currency',
                      hintText: 'Select Currency',
                      toolTipText:
                          'Which fiat currency needs exchange from cryptocurrency?',
                      initialItems: _list,
                      onRequest: _getFakeRequestData,
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value?.text ?? '';
                        });
                      },
                    ),
                  ),
                  10.width,

                  ///Payment Window
                  Expanded(
                    child: SearchRequestDropdown(
                      titleText: 'Payment Window ',
                      hintText: 'Select one',
                      toolTipText:
                          'For Buyer: Within how many minutes do you promise to initiate the payment. For Seller: Within how many minutes you want to get paid',
                      initialItems: _list,
                      onRequest: _getFakeRequestData,
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value?.text ?? '';
                        });
                      },
                    ),
                  ),
                ],
              ),

              10.height,
              CustomTextField(
                titleText: 'Currency Rate ',
                hintText: '',
                toolTipText:
                    'The margin you want over the bitcoin market price. Use a negative value for buying or selling under the market price to attract more contacts.',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  ///only one dot allowed and digits only,while unlimited decimal places
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,}')),
                ],
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('USD',
                            style: boldTextStyle(color: context.primaryColor))
                        .center()
                        .paddingRight(DEFAULT_PADDING),
                  ],
                ),
                onChanged: (value) {},
              ),
              10.height,

              ///limits
              Row(
                children: [
                  ///Minimum Transaction Limit

                  Expanded(
                    child: CustomTextField(
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
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('USD',
                                  style: boldTextStyle(
                                      color: context.primaryColor))
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
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('USD',
                                  style: boldTextStyle(
                                      color: context.primaryColor))
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
                      text: 'Price Equation: ',
                      style: secondaryTextStyle(),
                    ),
                    TextSpan(
                      text: '1890.07 USD/ETH',
                      style: boldTextStyle(color: context.primaryColor),
                    ),
                  ],
                ),
              ),
              10.height,

              ///Payment Details
              CustomTextField(
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
}

List<Pair> _list = [
  Pair(key: 1, text: 'Developer', icon: Icons.developer_board),
  Pair(key: 2, text: 'Designer', icon: Icons.deblur_sharp),
  Pair(key: 3, text: 'Consultant', icon: Icons.money_off),
  Pair(key: 4, text: 'Student', icon: Icons.edit),
];
