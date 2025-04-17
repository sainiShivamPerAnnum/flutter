import 'package:freezed_annotation/freezed_annotation.dart';

part 'bordered_text_widget.freezed.dart';
part 'bordered_text_widget.g.dart';

@freezed
class BorderedTextWidget with _$BorderedTextWidget {
  const factory BorderedTextWidget({
    required String text,
    double? fontSize,
    String? strokeCap,
    String? strokeJoin,
    double? strokeWidth,
    String? strokeColor,
    Map<String, dynamic>? gradient,
  }) = _BorderedTextWidget;

  factory BorderedTextWidget.fromJson(Map<String, dynamic> json) =>
      _$BorderedTextWidgetFromJson(json);
}
