import 'package:freezed_annotation/freezed_annotation.dart';

part 'clip_rrect_widget.freezed.dart';
part 'clip_rrect_widget.g.dart';

@freezed
class ClipRRectWidget with _$ClipRRectWidget {
  const factory ClipRRectWidget({
    BorderRadiusModel? borderRadius,
    String? clipBehavior,
    Map<String, dynamic>? child,
  }) = _ClipRRectWidget;

  factory ClipRRectWidget.fromJson(Map<String, dynamic> json) =>
      _$ClipRRectWidgetFromJson(json);
}

@freezed
class BorderRadiusModel with _$BorderRadiusModel {
  const factory BorderRadiusModel({
    double? all,
    double? topLeft,
    double? topRight,
    double? bottomLeft,
    double? bottomRight,
  }) = _BorderRadiusModel;

  factory BorderRadiusModel.fromJson(Map<String, dynamic> json) =>
      _$BorderRadiusModelFromJson(json);
}
