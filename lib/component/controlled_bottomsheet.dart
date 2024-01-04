import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../constants/constants_index.dart';

class ControlledBottomSheet extends StatefulWidget {
  ControlledBottomSheet({
    super.key,
    required this.builder,
    this.header,
    ValueNotifier<bool>? sheetMinimized,
    bool initialValue = false,
    this.minimizedHeight = 100,
    this.maximizedHeight = 350,
    this.decoration,
    this.bgColor,
    this.borderRadius,
    this.padding,
    this.duration,
    this.listener,
    this.showLine = false,
    this.showButton = true,
  }) : _sheetMinimized = sheetMinimized ?? ValueNotifier<bool>(initialValue);
  final double minimizedHeight;
  final double maximizedHeight;
  final BoxDecoration? decoration;
  final Color? bgColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final Duration? duration;
  final bool showLine;
  final bool showButton;

  final ValueNotifier<bool> _sheetMinimized;
  final Widget Function(
      BuildContext context, ValueNotifier<bool>, bool sheetMinimized) builder;
  final Widget Function(
      BuildContext context, ValueNotifier<bool>, bool sheetMinimized)? header;
  final void Function(bool sheetMinimized)? listener;

  @override
  State<ControlledBottomSheet> createState() => _ControlledBottomSheetState();
}

class _ControlledBottomSheetState extends State<ControlledBottomSheet> {
  @override
  void initState() {
    super.initState();
    widget._sheetMinimized.addListener(_handleSheetMinimized);
  }

  toogleSheet() => widget._sheetMinimized.value = !widget._sheetMinimized.value;
  _handleSheetMinimized() {
    widget.listener?.call(widget._sheetMinimized.value);
    if (widget._sheetMinimized.value) {
      hideKeyboard(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget._sheetMinimized,
      builder: (context, sheetMinimized, _) {
        return AnimatedContainer(
          duration: widget.duration ?? 200.milliseconds,
          padding: EdgeInsets.only(top: widget.showLine ? 10 : 0),
          height: widget._sheetMinimized.value
              ? widget.minimizedHeight
              : widget.maximizedHeight,
          decoration: widget.decoration ??
              BoxDecoration(
                color: widget.bgColor ?? context.scaffoldBackgroundColor,
                borderRadius: widget.borderRadius ??
                    const BorderRadius.only(
                        topLeft: Radius.circular(DEFAULT_RADIUS),
                        topRight: Radius.circular(DEFAULT_RADIUS)),
                boxShadow: defaultBoxShadow(
                    offset: const Offset(0, -2),
                    blurRadius: 20,
                    spreadRadius: 20),
              ),
          child: Column(
            children: [
              widget.showLine
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 40,
                          height: 5,
                          decoration: boxDecorationWithRoundedCorners(
                              backgroundColor: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ],
                    ).paddingBottom(10).onTap(() => toogleSheet())
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: widget.header?.call(context,
                                    widget._sheetMinimized, sheetMinimized) ??
                                Container()),
                        10.width,

                        ///animated arrow up-down icon
                        if (widget.showButton)
                          AnimatedBuilder(
                              animation: widget._sheetMinimized,
                              builder: (context, child) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: context.primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    sheetMinimized
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    color: whiteColor,
                                  ),
                                );
                              }).onTap(() => toogleSheet()),
                      ],
                    ).paddingAll(10),
              Expanded(
                  child: widget.builder(
                      context, widget._sheetMinimized, sheetMinimized)),
            ],
          ),
        );
      },
    );
  }
}