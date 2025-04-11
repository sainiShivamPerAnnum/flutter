import 'package:felloapp/core/model/sdui/sdui_parsers/fractional_translation/fractional_translation_widget.dart';
import 'package:flutter/material.dart';
import 'package:stac/stac.dart';

class FractionalTranslationWidgetParser
    extends StacParser<FractionalTranslationWidget> {
  const FractionalTranslationWidgetParser();

  @override
  FractionalTranslationWidget getModel(Map<String, dynamic> json) =>
      FractionalTranslationWidget.fromJson(json);

  @override
  String get type => 'fractionalTranslation';

  @override
  Widget parse(BuildContext context, FractionalTranslationWidget model) {
    return _CustomFractionalTranslationBuilder(
      model: model,
    );
  }
}

class _CustomFractionalTranslationBuilder extends StatefulWidget {
  const _CustomFractionalTranslationBuilder({
    required this.model,
  });

  final FractionalTranslationWidget model;

  @override
  State<_CustomFractionalTranslationBuilder> createState() =>
      _CustomFractionalTranslationBuilderState();
}

class _CustomFractionalTranslationBuilderState
    extends State<_CustomFractionalTranslationBuilder> {
  @override
  Widget build(BuildContext context) {
    return FractionalTranslation(
      translation: Offset(widget.model.dx, widget.model.dy),
      child: Stac.fromJson(widget.model.child, context),
    );
  }
}
