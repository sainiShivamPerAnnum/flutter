import 'package:felloapp/core/model/sdui/sdui_parsers/divider/divider_widget.dart';
import 'package:flutter/material.dart';
import 'package:stac/stac.dart';

class DividerWidgetParser extends StacParser<DividerWidget> {
  const DividerWidgetParser();

  @override
  DividerWidget getModel(Map<String, dynamic> json) =>
      DividerWidget.fromJson(json);

  @override
  String get type => 'divider';

  @override
  Widget parse(BuildContext context, DividerWidget model) {
    return _CustomDividerBuilder(
      model: model,
    );
  }
}

class _CustomDividerBuilder extends StatefulWidget {
  const _CustomDividerBuilder({
    required this.model,
  });

  final DividerWidget model;

  @override
  State<_CustomDividerBuilder> createState() => _CustomDividerBuilderState();
}

class _CustomDividerBuilderState extends State<_CustomDividerBuilder> {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: widget.model.height,
      thickness: widget.model.thickness,
      endIndent: widget.model.endIndent,
      indent: widget.model.indent,
      color: widget.model.color.toColor(context),
    );
  }
}
