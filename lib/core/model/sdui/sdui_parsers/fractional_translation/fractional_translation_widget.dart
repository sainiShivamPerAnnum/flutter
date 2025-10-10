import 'package:freezed_annotation/freezed_annotation.dart';

part 'fractional_translation_widget.freezed.dart';
part 'fractional_translation_widget.g.dart';

@freezed
class FractionalTranslationWidget with _$FractionalTranslationWidget {
  const factory FractionalTranslationWidget({
    @Default(0) double dx,
    @Default(0) double dy,
    Map<String, dynamic>? child,
  }) = _FractionalTranslationWidget;

  factory FractionalTranslationWidget.fromJson(Map<String, dynamic> json) =>
      _$FractionalTranslationWidgetFromJson(json);
}
