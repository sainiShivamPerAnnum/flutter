import 'package:felloapp/core/model/sdui/sdui_parsers/transform/translate_widget.dart';
import 'package:flutter/material.dart';
import 'package:stac/stac.dart';

class TransformWidgetParser extends StacParser<TransformWidget> {
  const TransformWidgetParser();

  @override
  TransformWidget getModel(Map<String, dynamic> json) =>
      TransformWidget.fromJson(json);

  @override
  String get type => 'translate';

  @override
  Widget parse(BuildContext context, TransformWidget model) {
    return _CustomTransformBuilder(
      model: model,
    );
  }
}

class _CustomTransformBuilder extends StatefulWidget {
  const _CustomTransformBuilder({
    required this.model,
  });

  final TransformWidget model;

  @override
  State<_CustomTransformBuilder> createState() =>
      _CustomTransformBuilderState();
}

class _CustomTransformBuilderState extends State<_CustomTransformBuilder> {
  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(widget.model.dx, widget.model.dy),
      child: Stac.fromJson(widget.model.child, context),
    );
  }
}
