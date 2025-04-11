import 'package:felloapp/core/model/sdui/sdui_parsers/gestureDetector/gesture_detector_widget.dart';
import 'package:flutter/material.dart';
import 'package:stac/stac.dart';

class GestureDetectorParser extends StacParser<GestureDetectorWidget> {
  const GestureDetectorParser();

  @override
  GestureDetectorWidget getModel(Map<String, dynamic> json) =>
      GestureDetectorWidget.fromJson(json);

  @override
  String get type => 'gestureDetector';

  @override
  Widget parse(BuildContext context, GestureDetectorWidget model) {
    return _CustomGestureDetectorBuilder(
      model: model,
    );
  }
}

class _CustomGestureDetectorBuilder extends StatefulWidget {
  const _CustomGestureDetectorBuilder({
    required this.model,
  });

  final GestureDetectorWidget model;

  @override
  State<_CustomGestureDetectorBuilder> createState() =>
      _CustomGestureDetectorBuilderState();
}

class _CustomGestureDetectorBuilderState
    extends State<_CustomGestureDetectorBuilder> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Stac.onCallFromJson(widget.model.onTap, context),
      child: Stac.fromJson(widget.model.child, context),
    );
  }
}
