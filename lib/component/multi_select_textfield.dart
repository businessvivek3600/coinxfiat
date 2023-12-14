import 'package:coinxfiat/constants/constants_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_multiselect/flutter_simple_multiselect.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

class MultiSelectField extends StatefulWidget {
  const MultiSelectField(
      {super.key,
      this.onChanged,
      required this.onRequest,
      required this.hintText,
      this.titleText,
      this.toolTipText,
      this.toolTipIconColor,
      this.toolTipBgColor,
      this.initialValue = const {},
      required this.initialItems});
  final void Function(Map<String, dynamic>)? onChanged;
  final Future<List<Map<String, dynamic>>> Function(String) onRequest;
  final String hintText;
  final String? titleText;
  final String? toolTipText;
  final Color? toolTipIconColor;
  final Color? toolTipBgColor;
  final Map<String, dynamic> initialValue;
  final List<Map<String, dynamic>> initialItems;

  @override
  State<MultiSelectField> createState() => _MultiSelectFieldState();
}

class _MultiSelectFieldState extends State<MultiSelectField> {
  late Color lineColor = const Color.fromRGBO(36, 37, 51, 0.04);
  List selectedItemsAsync = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _asyncData();
  }

  Widget _asyncData() {
    InputDecorationTheme theme = Theme.of(context).inputDecorationTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.titleText != null)
          Wrap(
            children: [
              Text(widget.titleText!, style: boldTextStyle(), maxLines: 2),
              10.width,
              Tooltip(
                decoration: BoxDecoration(
                  color: widget.toolTipBgColor ?? Colors.black,
                  borderRadius: BorderRadius.circular(DEFAULT_RADIUS),
                ),
                triggerMode: TooltipTriggerMode.tap,
                padding: const EdgeInsets.all(DEFAULT_PADDING),
                margin: const EdgeInsets.all(DEFAULT_PADDING),
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
        FlutterMultiselect(
            autofocus: false,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            enableBorderColor: theme.enabledBorder?.borderSide.color,
            focusedBorderColor: theme.focusedBorder?.borderSide.color,
            borderRadius: DEFAULT_RADIUS,
            borderSize: 1,
            resetTextOnSubmitted: true,
            minTextFieldWidth: 300,
            inputDecoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: secondaryTextStyle(),
              border: InputBorder.none,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: lineColor),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: lineColor),
              ),
            ),
            validator: (value) {
              if (selectedItemsAsync.length < 2) {
                return "min 2 items required";
              }
              return null;
            },
            suggestionsBoxMaxHeight: 300,
            length: selectedItemsAsync.length,
            isLoading: isLoading,
            tagBuilder: (context, index) => SelectTag(
                  index: index,
                  label: selectedItemsAsync[index]["name"],
                  onDeleted: (value) {
                    selectedItemsAsync.removeAt(index);
                    setState(() {});
                  },
                ),
            suggestionBuilder: (context, state, data) {
              var existingIndex = selectedItemsAsync
                  .indexWhere((element) => element["uuid"] == data["uuid"]);
              var selectedData = data;
              return Material(
                  child: ListTile(
                      leading: const Icon(Icons.person),
                      selected: existingIndex >= 0,
                      trailing: existingIndex >= 0
                          ? const Icon(Icons.check_circle_outline_rounded)
                          : null,
                      selectedColor: Colors.white,
                      selectedTileColor: context.accentColor,
                      title: Text(selectedData["name"].toString()),
                      onTap: () {
                        var existingIndex = selectedItemsAsync.indexWhere(
                            (element) => element["uuid"] == data["uuid"]);
                        if (existingIndex >= 0) {
                          selectedItemsAsync.removeAt(existingIndex);
                        } else {
                          selectedItemsAsync.add(data);
                        }
                        state.selectAndClose(data);
                        setState(() {});
                      }));
            },
            suggestionsBoxElevation: 10,
            findSuggestions: (String query) async {
              setState(() => isLoading = true);
              var data = await widget.onRequest(query);
              setState(() => isLoading = false);
              return data;
            }),
      ],
    );
  }
}

class SelectTag extends StatelessWidget {
  const SelectTag({
    super.key,
    required this.label,
    required this.onDeleted,
    required this.index,
  });

  final String label;
  final ValueChanged<int> onDeleted;
  final int index;
  final Color darkAlias6 = const Color.fromRGBO(36, 37, 51, 0.06);

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: darkAlias6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      labelPadding: const EdgeInsets.only(left: 8.0),
      label: Text(label),
      deleteIcon: const Icon(
        Icons.close,
        size: 18,
      ),
      onDeleted: () {
        onDeleted(index);
      },
    );
  }
}
