import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

import '../constants/constants_index.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    Key? key,
    this.onChanged,
    required this.hintText,
    this.titleText,
    this.toolTipText,
    this.toolTipIconColor,
    this.toolTipBgColor,
    this.readOnly = false,
    this.initialValue = '',
    this.keyboardType,
    this.inputFormatters = const [],
    this.suffixIcon,
    this.prefixIcon,
    this.maxLines = 1,
    this.textInputAction = TextInputAction.next,
    this.controller,
  }) : super(key: key);
  final void Function(String?)? onChanged;
  final String hintText;
  final String? titleText;
  final String? toolTipText;
  final Color? toolTipIconColor;
  final Color? toolTipBgColor;
  final bool readOnly;
  final String initialValue;
  final TextInputType? keyboardType;
  final List<TextInputFormatter> inputFormatters;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int maxLines;
  final TextInputAction textInputAction;
  final TextEditingController? controller;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController controller;
  @override
  void initState() {
    super.initState();
    controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.titleText != null)
          Row(
            children: [
              Text(widget.titleText!, style: boldTextStyle()),
              10.width,
              if (widget.toolTipText != null)
                Tooltip(
                  decoration: BoxDecoration(
                    color: widget.toolTipBgColor ?? Colors.black,
                    borderRadius: BorderRadius.circular(DEFAULT_RADIUS),
                  ),
                  triggerMode: TooltipTriggerMode.tap,
                  padding: const EdgeInsets.all(DEFAULT_PADDING),
                  margin: const EdgeInsetsDirectional.symmetric(
                      horizontal: DEFAULT_PADDING),
                  message: widget.toolTipText ?? '',
                  child: Container(
                    padding: const EdgeInsetsDirectional.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.toolTipIconColor ?? Colors.grey.shade200,
                    ),
                    child: const FaIcon(FontAwesomeIcons.question,
                        color: Colors.grey, size: 10),
                  ),
                ),
            ],
          ).paddingBottom(10),
        TextFormField(
          controller: controller,
          readOnly: widget.readOnly,
          maxLines: widget.maxLines,
          textInputAction: widget.textInputAction,
          keyboardType: widget.keyboardType ?? TextInputType.text,
          onChanged: widget.onChanged,
          inputFormatters: widget.inputFormatters,
          onTap: () async {},
          decoration: InputDecoration(
            counterText: '',
            hintText: widget.hintText,
            hintStyle: secondaryTextStyle(),
            suffixIcon: widget.suffixIcon,
            prefixIcon: widget.prefixIcon,
          ),
        ).paddingBottom(10),
      ],
    );
  }
}
