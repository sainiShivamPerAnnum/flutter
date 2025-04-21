import 'package:freezed_annotation/freezed_annotation.dart';

part 'timeline_widget.freezed.dart';
part 'timeline_widget.g.dart';

@freezed
class TimelineWidget with _$TimelineWidget {
  const factory TimelineWidget({
    required List<TimelineNode> nodes,
    String? primaryColor,
    String? secondaryColor,
    String? tertiaryColor,
    double? nodeSize,
    double? nodeInnerSize,
    double? nodeInnerMostSize,
    double? lineHeight,
    double? dashLength,
    double? dashGap,
    double? lineWidth,
    double? spacing,
    double? titleSpacing,
  }) = _TimelineWidget;

  factory TimelineWidget.fromJson(Map<String, dynamic> json) =>
      _$TimelineWidgetFromJson(json);
}

@freezed
class TimelineNode with _$TimelineNode {
  const factory TimelineNode({
    String? title,
    String? description,
    String? titleColor,
    String? descriptionColor,
    double? titleFontSize,
    double? descriptionFontSize,
    String? titleFontWeight,
    String? descriptionFontWeight,
    bool? completed,
    String? nodeColor,
  }) = _TimelineNode;

  factory TimelineNode.fromJson(Map<String, dynamic> json) =>
      _$TimelineNodeFromJson(json);
}
