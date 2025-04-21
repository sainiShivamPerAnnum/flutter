import 'package:freezed_annotation/freezed_annotation.dart';

part 'translate_widget.freezed.dart';
part 'translate_widget.g.dart';

@freezed
class TransformWidget with _$TransformWidget {
  const factory TransformWidget({
    @Default(0) double dx,
    @Default(0) double dy,
    Map<String, dynamic>? child,
  }) = _TransformWidget;

  factory TransformWidget.fromJson(Map<String, dynamic> json) =>
      _$TransformWidgetFromJson(json);
}
