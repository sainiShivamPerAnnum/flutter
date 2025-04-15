import 'package:felloapp/core/model/sdui/sdui_parsers/animated_container/animated_container_widget.dart';
import 'package:felloapp/util/stac/lib/src/framework/stac.dart';
import 'package:felloapp/util/stac/lib/src/utils/color_utils.dart';
import 'package:felloapp/util/stac_framework/lib/src/stac_parser.dart';
import 'package:flutter/material.dart';

class AnimatedContainerWidgetParser
    extends StacParser<AnimatedContainerWidget> {
  const AnimatedContainerWidgetParser();

  @override
  AnimatedContainerWidget getModel(Map<String, dynamic> json) =>
      AnimatedContainerWidget.fromJson(json);

  @override
  String get type => 'animatedContainer';

  @override
  Widget parse(BuildContext context, AnimatedContainerWidget model) {
    return _CustomAnimatedContainerBuilder(
      model: model,
    );
  }
}

class _CustomAnimatedContainerBuilder extends StatefulWidget {
  const _CustomAnimatedContainerBuilder({
    required this.model,
  });

  final AnimatedContainerWidget model;

  @override
  State<_CustomAnimatedContainerBuilder> createState() =>
      _CustomAnimatedContainerBuilderState();
}

class _CustomAnimatedContainerBuilderState
    extends State<_CustomAnimatedContainerBuilder> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: widget.model.durationInMs ?? 300),
      curve: _getCurve(widget.model.curve),
      width: widget.model.width,
      height: widget.model.height,
      padding: _getEdgeInsets(widget.model.padding),
      margin: _getEdgeInsets(widget.model.margin),
      alignment: _getAlignment(widget.model.alignment),
      color: widget.model.color?.toColor(context),
      decoration: widget.model.decoration != null
          ? BoxDecoration(
              color: widget.model.decoration?.color?.toColor(context),
              borderRadius: widget.model.decoration?.borderRadius != null
                  ? BorderRadius.circular(
                      widget.model.decoration!.borderRadius!,
                    )
                  : null,
              border: widget.model.decoration?.borderColor != null
                  ? Border.all(
                      color: widget.model.decoration!.borderColor!
                          .toColor(context)!,
                      width: widget.model.decoration?.borderWidth ?? 1.0,
                    )
                  : null,
              boxShadow: widget.model.decoration?.shadow != null
                  ? [
                      BoxShadow(
                        color: widget.model.decoration!.shadowColor
                                ?.toColor(context) ??
                            Colors.black.withOpacity(0.2),
                        blurRadius: widget.model.decoration!.shadow!,
                        spreadRadius:
                            widget.model.decoration?.spreadRadius ?? 0.0,
                        offset: Offset(
                          widget.model.decoration?.offsetX ?? 0.0,
                          widget.model.decoration?.offsetY ?? 2.0,
                        ),
                      ),
                    ]
                  : null,
              gradient:
                  _getGradient(widget.model.decoration?.gradient, context),
            )
          : null,
      // transform: widget.model.transform != null
      //     ? Matrix4.identity()
      //       ..translate(
      //         widget.model.transform?.translateX ?? 0.0,
      //         widget.model.transform?.translateY ?? 0.0,
      //         widget.model.transform?.translateZ ?? 0.0,
      //       )
      //       ..rotateX(widget.model.transform?.rotateX ?? 0.0)
      //       ..rotateY(widget.model.transform?.rotateY ?? 0.0)
      //       ..rotateZ(widget.model.transform?.rotateZ ?? 0.0)
      //       ..scale(
      //         widget.model.transform?.scaleX ?? 1.0,
      //         widget.model.transform?.scaleY ?? 1.0,
      //         widget.model.transform?.scaleZ ?? 1.0,
      //       )
      //     : null,
      transformAlignment: _getAlignment(widget.model.transformAlignment),
      clipBehavior: _getClip(widget.model.clip),
      constraints: widget.model.constraints != null
          ? BoxConstraints(
              minWidth: widget.model.constraints?.minWidth ?? 0.0,
              maxWidth: widget.model.constraints?.maxWidth ?? double.infinity,
              minHeight: widget.model.constraints?.minHeight ?? 0.0,
              maxHeight: widget.model.constraints?.maxHeight ?? double.infinity,
            )
          : null,
      child: widget.model.child != null
          ? Stac.fromJson(
              widget.model.child!,
              context,
            )
          : null,
    );
  }

  Curve _getCurve(String? curveName) {
    switch (curveName) {
      case 'linear':
        return Curves.linear;
      case 'decelerate':
        return Curves.decelerate;
      case 'ease':
        return Curves.ease;
      case 'easeIn':
        return Curves.easeIn;
      case 'easeOut':
        return Curves.easeOut;
      case 'easeInOut':
        return Curves.easeInOut;
      case 'fastOutSlowIn':
        return Curves.fastOutSlowIn;
      case 'bounceIn':
        return Curves.bounceIn;
      case 'bounceOut':
        return Curves.bounceOut;
      case 'bounceInOut':
        return Curves.bounceInOut;
      case 'elasticIn':
        return Curves.elasticIn;
      case 'elasticOut':
        return Curves.elasticOut;
      case 'elasticInOut':
        return Curves.elasticInOut;
      default:
        return Curves.linear;
    }
  }

  EdgeInsets? _getEdgeInsets(Map<String, dynamic>? padding) {
    if (padding == null) return null;

    return EdgeInsets.only(
      left: padding['left'] ?? 0.0,
      top: padding['top'] ?? 0.0,
      right: padding['right'] ?? 0.0,
      bottom: padding['bottom'] ?? 0.0,
    );
  }

  Alignment? _getAlignment(String? alignment) {
    if (alignment == null) return null;

    switch (alignment) {
      case 'topLeft':
        return Alignment.topLeft;
      case 'topCenter':
        return Alignment.topCenter;
      case 'topRight':
        return Alignment.topRight;
      case 'centerLeft':
        return Alignment.centerLeft;
      case 'center':
        return Alignment.center;
      case 'centerRight':
        return Alignment.centerRight;
      case 'bottomLeft':
        return Alignment.bottomLeft;
      case 'bottomCenter':
        return Alignment.bottomCenter;
      case 'bottomRight':
        return Alignment.bottomRight;
      default:
        return null;
    }
  }

  Gradient? _getGradient(
    Map<String, dynamic>? gradientData,
    BuildContext context,
  ) {
    if (gradientData == null) return null;

    final type = gradientData['type'] as String?;
    final colors = (gradientData['colors'] as List<dynamic>)
        .map((color) => (color as String).toColor(context)!)
        .toList();

    if (colors.isEmpty) return null;

    switch (type) {
      case 'linear':
        return LinearGradient(
          colors: colors,
          begin: _getAlignment(gradientData['begin']) ?? Alignment.topLeft,
          end: _getAlignment(gradientData['end']) ?? Alignment.bottomRight,
          stops: (gradientData['stops'] as List<dynamic>?)
              ?.map((stop) => stop as double)
              .toList(),
        );
      case 'radial':
        return RadialGradient(
          colors: colors,
          center: _getAlignment(gradientData['center']) ?? Alignment.center,
          radius: gradientData['radius'] ?? 0.5,
          stops: (gradientData['stops'] as List<dynamic>?)
              ?.map((stop) => stop as double)
              .toList(),
        );
      case 'sweep':
        return SweepGradient(
          colors: colors,
          center: _getAlignment(gradientData['center']) ?? Alignment.center,
          startAngle: gradientData['startAngle'] ?? 0.0,
          endAngle: gradientData['endAngle'] ?? 2 * 3.14159,
          stops: (gradientData['stops'] as List<dynamic>?)
              ?.map((stop) => stop as double)
              .toList(),
        );
      default:
        return null;
    }
  }

  Clip _getClip(String? clip) {
    switch (clip) {
      case 'none':
        return Clip.none;
      case 'hardEdge':
        return Clip.hardEdge;
      case 'antiAlias':
        return Clip.antiAlias;
      case 'antiAliasWithSaveLayer':
        return Clip.antiAliasWithSaveLayer;
      default:
        return Clip.none;
    }
  }
}
