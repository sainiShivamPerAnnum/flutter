import 'package:felloapp/core/model/sdui/sdui_parsers/responsiveContainer/responsive_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stac/stac.dart';

class ResponsiveContainerParser extends StacParser<ResponsiveContainer> {
  const ResponsiveContainerParser();

  @override
  ResponsiveContainer getModel(Map<String, dynamic> json) =>
      ResponsiveContainer.fromJson(json);

  @override
  String get type => 'responsiveContainer';

  @override
  Widget parse(BuildContext context, ResponsiveContainer model) {
    return _ResponsiveContainerBuilder(
      model: model,
    );
  }
}

class _ResponsiveContainerBuilder extends StatefulWidget {
  const _ResponsiveContainerBuilder({
    required this.model,
  });

  final ResponsiveContainer model;

  @override
  State<_ResponsiveContainerBuilder> createState() =>
      _ResponsiveContainerBuilderState();
}

class _ResponsiveContainerBuilderState
    extends State<_ResponsiveContainerBuilder> {
  double? _applyScaling(double? value, String? scalingType) {
    if (value == null) return null;

    switch (scalingType) {
      case 'r':
        return value.r;
      case 'w':
        return value.w;
      case 'h':
        return value.h;
      case 'dg':
        return value.dg;
      case 'dm':
        return value.dm;
      case 'sp':
        return value.sp;
      case 'sh':
        return value.sh;
      case 'sw':
        return value.sw;
      default:
        return value.r;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: widget.model.alignment?.value,
      padding: widget.model.padding?.parse,
      color: widget.model.color.toColor(context),
      decoration: widget.model.decoration?.parse(context),
      foregroundDecoration: widget.model.foregroundDecoration?.parse(context),
      width: _applyScaling(widget.model.width, widget.model.widthScaling),
      height: _applyScaling(widget.model.height, widget.model.heightScaling),
      margin: widget.model.margin?.parse,
      clipBehavior: widget.model.clipBehavior,
      child: Stac.fromJson(widget.model.child, context),
    );
  }
}
