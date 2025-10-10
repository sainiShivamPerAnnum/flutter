// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline_widget.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TimelineWidgetImpl _$$TimelineWidgetImplFromJson(Map<String, dynamic> json) =>
    _$TimelineWidgetImpl(
      nodes: (json['nodes'] as List<dynamic>)
          .map((e) => TimelineNode.fromJson(e as Map<String, dynamic>))
          .toList(),
      primaryColor: json['primaryColor'] as String?,
      secondaryColor: json['secondaryColor'] as String?,
      tertiaryColor: json['tertiaryColor'] as String?,
      nodeSize: (json['nodeSize'] as num?)?.toDouble(),
      nodeInnerSize: (json['nodeInnerSize'] as num?)?.toDouble(),
      nodeInnerMostSize: (json['nodeInnerMostSize'] as num?)?.toDouble(),
      lineHeight: (json['lineHeight'] as num?)?.toDouble(),
      dashLength: (json['dashLength'] as num?)?.toDouble(),
      dashGap: (json['dashGap'] as num?)?.toDouble(),
      lineWidth: (json['lineWidth'] as num?)?.toDouble(),
      spacing: (json['spacing'] as num?)?.toDouble(),
      titleSpacing: (json['titleSpacing'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$TimelineWidgetImplToJson(
        _$TimelineWidgetImpl instance) =>
    <String, dynamic>{
      'nodes': instance.nodes,
      'primaryColor': instance.primaryColor,
      'secondaryColor': instance.secondaryColor,
      'tertiaryColor': instance.tertiaryColor,
      'nodeSize': instance.nodeSize,
      'nodeInnerSize': instance.nodeInnerSize,
      'nodeInnerMostSize': instance.nodeInnerMostSize,
      'lineHeight': instance.lineHeight,
      'dashLength': instance.dashLength,
      'dashGap': instance.dashGap,
      'lineWidth': instance.lineWidth,
      'spacing': instance.spacing,
      'titleSpacing': instance.titleSpacing,
    };

_$TimelineNodeImpl _$$TimelineNodeImplFromJson(Map<String, dynamic> json) =>
    _$TimelineNodeImpl(
      title: json['title'] as String?,
      description: json['description'] as String?,
      titleColor: json['titleColor'] as String?,
      descriptionColor: json['descriptionColor'] as String?,
      titleFontSize: (json['titleFontSize'] as num?)?.toDouble(),
      descriptionFontSize: (json['descriptionFontSize'] as num?)?.toDouble(),
      titleFontWeight: json['titleFontWeight'] as String?,
      descriptionFontWeight: json['descriptionFontWeight'] as String?,
      completed: json['completed'] as bool?,
      nodeColor: json['nodeColor'] as String?,
    );

Map<String, dynamic> _$$TimelineNodeImplToJson(_$TimelineNodeImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'titleColor': instance.titleColor,
      'descriptionColor': instance.descriptionColor,
      'titleFontSize': instance.titleFontSize,
      'descriptionFontSize': instance.descriptionFontSize,
      'titleFontWeight': instance.titleFontWeight,
      'descriptionFontWeight': instance.descriptionFontWeight,
      'completed': instance.completed,
      'nodeColor': instance.nodeColor,
    };
