import 'package:felloapp/core/model/sdui/sdui_parsers/clip_rrect/clip_rrect_widget.dart';
import 'package:flutter/material.dart';
import 'package:stac/stac.dart';

class ClipRRectWidgetParser extends StacParser<ClipRRectWidget> {
  const ClipRRectWidgetParser();

  @override
  ClipRRectWidget getModel(Map<String, dynamic> json) =>
      ClipRRectWidget.fromJson(json);

  @override
  String get type => 'clipRRect';

  @override
  Widget parse(BuildContext context, ClipRRectWidget model) {
    return _CustomClipRRectBuilder(
      model: model,
    );
  }
}

class _CustomClipRRectBuilder extends StatefulWidget {
  const _CustomClipRRectBuilder({
    required this.model,
  });

  final ClipRRectWidget model;

  @override
  State<_CustomClipRRectBuilder> createState() =>
      _CustomClipRRectBuilderState();
}

class _CustomClipRRectBuilderState extends State<_CustomClipRRectBuilder> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: _getBorderRadius(widget.model.borderRadius),
      clipBehavior: _getClip(widget.model.clipBehavior),
      child: widget.model.child != null
          ? Stac.fromJson(widget.model.child, context)
          : Container(),
    );
  }

  BorderRadius _getBorderRadius(BorderRadiusModel? borderRadius) {
    if (borderRadius == null) {
      return BorderRadius.zero;
    }

    // If all corners are the same
    if (borderRadius.all != null) {
      return BorderRadius.circular(borderRadius.all!);
    }

    // If we have individual corner values
    return BorderRadius.only(
      topLeft: Radius.circular(borderRadius.topLeft ?? 0.0),
      topRight: Radius.circular(borderRadius.topRight ?? 0.0),
      bottomLeft: Radius.circular(borderRadius.bottomLeft ?? 0.0),
      bottomRight: Radius.circular(borderRadius.bottomRight ?? 0.0),
    );
  }

  Clip _getClip(String? clipBehavior) {
    switch (clipBehavior) {
      case 'none':
        return Clip.none;
      case 'hardEdge':
        return Clip.hardEdge;
      case 'antiAlias':
        return Clip.antiAlias;
      case 'antiAliasWithSaveLayer':
        return Clip.antiAliasWithSaveLayer;
      default:
        return Clip.antiAlias; // Default in Flutter's ClipRRect
    }
  }
}
