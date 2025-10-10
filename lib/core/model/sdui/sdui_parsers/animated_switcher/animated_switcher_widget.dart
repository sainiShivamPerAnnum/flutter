import 'package:freezed_annotation/freezed_annotation.dart';

part 'animated_switcher_widget.freezed.dart';
part 'animated_switcher_widget.g.dart';

@freezed
class AnimatedSwitcherWidget with _$AnimatedSwitcherWidget {
  const factory AnimatedSwitcherWidget({
    int? durationInMs,
    int? reverseDurationInMs,
    String? switchInCurve,
    String? switchOutCurve,
    String? transitionBuilder,
    String? layoutBuilder,
    Map<String, dynamic>? child,
  }) = _AnimatedSwitcherWidget;

  factory AnimatedSwitcherWidget.fromJson(Map<String, dynamic> json) =>
      _$AnimatedSwitcherWidgetFromJson(json);
}
