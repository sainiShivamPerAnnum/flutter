import 'package:felloapp/core/model/sdui/sdui_parsers/app_image/app_image_widget.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:stac/stac.dart';

class AppImageWidgetParser extends StacParser<AppImageWidget> {
  const AppImageWidgetParser();

  @override
  AppImageWidget getModel(Map<String, dynamic> json) =>
      AppImageWidget.fromJson(json);

  @override
  String get type => 'appImage';

  @override
  Widget parse(BuildContext context, AppImageWidget model) {
    return _CustomAppImageBuilder(
      model: model,
    );
  }
}

class _CustomAppImageBuilder extends StatefulWidget {
  const _CustomAppImageBuilder({
    required this.model,
  });

  final AppImageWidget model;

  @override
  State<_CustomAppImageBuilder> createState() => _CustomAppImageBuilderState();
}

class _CustomAppImageBuilderState extends State<_CustomAppImageBuilder> {
  @override
  Widget build(BuildContext context) {
    return AppImage(
      widget.model.image,
      fit: _getBoxFit(widget.model.fit),
      height: widget.model.height,
      width: widget.model.width,
      color: widget.model.color?.toColor(context),
    );
  }

  BoxFit? _getBoxFit(String? fit) {
    if (fit == null) return null;

    switch (fit) {
      case 'fill':
        return BoxFit.fill;
      case 'contain':
        return BoxFit.contain;
      case 'cover':
        return BoxFit.cover;
      case 'fitWidth':
        return BoxFit.fitWidth;
      case 'fitHeight':
        return BoxFit.fitHeight;
      case 'none':
        return BoxFit.none;
      case 'scaleDown':
        return BoxFit.scaleDown;
      default:
        return null;
    }
  }
}
