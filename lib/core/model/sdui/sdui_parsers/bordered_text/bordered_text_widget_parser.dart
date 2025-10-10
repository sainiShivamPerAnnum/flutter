import 'package:felloapp/core/model/sdui/sdui_parsers/bordered_text/bordered_text_widget.dart';
import 'package:felloapp/util/stac/lib/stac.dart';
import 'package:felloapp/util/styles/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BorderedTextWidgetParser extends StacParser<BorderedTextWidget> {
  const BorderedTextWidgetParser();

  @override
  BorderedTextWidget getModel(Map<String, dynamic> json) =>
      BorderedTextWidget.fromJson(json);

  @override
  String get type => 'borderedText';

  @override
  Widget parse(BuildContext context, BorderedTextWidget model) {
    return _CustomBorderedTextBuilder(
      model: model,
    );
  }
}

class _CustomBorderedTextBuilder extends StatefulWidget {
  const _CustomBorderedTextBuilder({
    required this.model,
  });

  final BorderedTextWidget model;

  @override
  State<_CustomBorderedTextBuilder> createState() =>
      _CustomBorderedTextBuilderState();
}

class _CustomBorderedTextBuilderState
    extends State<_CustomBorderedTextBuilder> {
  @override
  Widget build(BuildContext context) {
    return BorderedText(
      strokeCap: _parseStrokeCap(widget.model.strokeCap),
      strokeJoin: _parseStrokeJoin(widget.model.strokeJoin),
      strokeWidth: widget.model.strokeWidth ?? 6.0,
      strokeColor: widget.model.strokeColor?.toColor(context) ??
          const Color.fromRGBO(53, 0, 71, 1),
      gradient: widget.model.gradient != null
          ? _parseGradient(widget.model.gradient!, context)
          : null,
      child: Text(
        widget.model.text,
        style: GoogleFonts.sourceSans3(
          fontSize: widget.model.fontSize,
          fontWeight: FontWeight.w600,
          color: Colors.transparent,
        ),
      ),
    );
  }

  StrokeCap _parseStrokeCap(String? strokeCap) {
    switch (strokeCap) {
      case 'butt':
        return StrokeCap.butt;
      case 'round':
        return StrokeCap.round;
      case 'square':
        return StrokeCap.square;
      default:
        return StrokeCap.round;
    }
  }

  StrokeJoin _parseStrokeJoin(String? strokeJoin) {
    switch (strokeJoin) {
      case 'miter':
        return StrokeJoin.miter;
      case 'round':
        return StrokeJoin.round;
      case 'bevel':
        return StrokeJoin.bevel;
      default:
        return StrokeJoin.round;
    }
  }

  Gradient? _parseGradient(Map<String, dynamic> json, BuildContext context) {
    final String? type = json['type'] as String?;

    final List<Color> colors = (json['colors'] as List<dynamic>?)
            ?.map((colorStr) => (colorStr as String).toColor(context)!)
            .toList() ??
        [];

    final List<double>? stops = json['stops'] != null
        ? (json['stops'] as List<dynamic>)
            .map<double>((stop) => (stop as num).toDouble())
            .toList()
        : null;

    if (type == 'linear') {
      return LinearGradient(
        begin: _parseAlignment(json['begin']) ?? Alignment.centerLeft,
        end: _parseAlignment(json['end']) ?? Alignment.centerRight,
        colors: colors,
        stops: stops,
      );
    } else if (type == 'radial') {
      return RadialGradient(
        center: _parseAlignment(json['center']) ?? Alignment.center,
        radius: json['radius']?.toDouble() ?? 0.5,
        colors: colors,
        stops: stops,
      );
    }

    return null;
  }

  Alignment? _parseAlignment(String? alignment) {
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
}
