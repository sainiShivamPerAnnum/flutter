import 'package:freezed_annotation/freezed_annotation.dart';

part 'spacer_widget.freezed.dart';
part 'spacer_widget.g.dart';

@freezed
class SpacerWidget with _$SpacerWidget {
  const factory SpacerWidget({
    @Default(1) int flex,
  }) = _SpacerWidget;

  factory SpacerWidget.fromJson(Map<String, dynamic> json) =>
      _$SpacerWidgetFromJson(json);
}
