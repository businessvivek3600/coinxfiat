import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

import '../constants/constants_index.dart';

class SearchRequestDropdown extends StatelessWidget {
  const SearchRequestDropdown({
    Key? key,
    this.onChanged,
    required this.onRequest,
    required this.hintText,
    required this.initialItems,
    this.titleText,
    this.toolTipText,
    this.toolTipIconColor,
    this.toolTipBgColor,
    this.initialValue,
  }) : super(key: key);
  final void Function(Pair?)? onChanged;
  final Future<List<Pair>> Function(String) onRequest;
  final String hintText;
  final String? titleText;
  final String? toolTipText;
  final Color? toolTipIconColor;
  final Color? toolTipBgColor;
  final Pair? initialValue;
  final List<Pair> initialItems;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (titleText != null)
          Row(
            children: [
              Text(titleText!, style: boldTextStyle()),
              10.width,
              Tooltip(
                decoration: BoxDecoration(
                  color: toolTipBgColor ?? Colors.black,
                  borderRadius: BorderRadius.circular(DEFAULT_RADIUS),
                ),
                triggerMode: TooltipTriggerMode.tap,
                padding: const EdgeInsets.all(DEFAULT_PADDING),
                margin: const EdgeInsets.all(DEFAULT_PADDING),
                message: toolTipText ?? '',
                child: Container(
                  padding: const EdgeInsetsDirectional.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: toolTipIconColor ?? Colors.grey.shade200,
                  ),
                  child: const FaIcon(FontAwesomeIcons.question,
                      color: Colors.grey, size: 10),
                ),
                //
              ),
            ],
          ).paddingBottom(10),
        CustomDropdown<Pair>.searchRequest(
          futureRequest: onRequest,
          hintText: hintText,
          items: initialItems,
          initialItem: initialValue,
          onChanged: (value) => onChanged?.call(value),
          headerBuilder: (context, value) => Text(value.text,
              style: boldTextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color)),
          listItemBuilder: (context, value) => Text(value.text,
              style: boldTextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color)),
          closedBorder: Border.all(color: Colors.grey.shade300),
        ),
      ],
    );
  }
}

class Pair {
  Pair({required this.key, required this.text, this.icon});
  final dynamic key;
  final String text;
  final IconData? icon;

  Pair fromJson(Map<String, dynamic> json) {
    return Pair(key: json['key'], text: json['text'], icon: json['icon']);
  }
}
