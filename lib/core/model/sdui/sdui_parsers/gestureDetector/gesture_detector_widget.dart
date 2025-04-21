import 'package:freezed_annotation/freezed_annotation.dart';

part 'gesture_detector_widget.freezed.dart';
part 'gesture_detector_widget.g.dart';

@freezed
class GestureDetectorWidget with _$GestureDetectorWidget {
  const factory GestureDetectorWidget({
    Map<String, dynamic>? onTap,
    Map<String, dynamic>? child,
  }) = _GestureDetectorWidget;

  factory GestureDetectorWidget.fromJson(Map<String, dynamic> json) =>
      _$GestureDetectorWidgetFromJson(json);
}
