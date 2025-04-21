import 'package:freezed_annotation/freezed_annotation.dart';

part 'divider_widget.freezed.dart';
part 'divider_widget.g.dart';

@freezed
class DividerWidget with _$DividerWidget {
  const factory DividerWidget({
    double? height,
    double? thickness,
    double? indent,
    double? endIndent,
    String? color,
  }) = _DividerWidget;

  factory DividerWidget.fromJson(Map<String, dynamic> json) =>
      _$DividerWidgetFromJson(json);
}
