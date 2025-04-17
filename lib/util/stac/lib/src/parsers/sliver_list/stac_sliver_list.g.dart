// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stac_sliver_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StacSliverListImpl _$$StacSliverListImplFromJson(Map<String, dynamic> json) =>
    _$StacSliverListImpl(
      addAutomaticKeepAlives: json['addAutomaticKeepAlives'] as bool? ?? false,
      addRepaintBoundaries: json['addRepaintBoundaries'] as bool? ?? false,
      addSemanticIndexes: json['addSemanticIndexes'] as bool? ?? true,
      children: (json['children'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      key: json['key'] as String?,
      semanticIndexOffset: (json['semanticIndexOffset'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$StacSliverListImplToJson(
        _$StacSliverListImpl instance) =>
    <String, dynamic>{
      'addAutomaticKeepAlives': instance.addAutomaticKeepAlives,
      'addRepaintBoundaries': instance.addRepaintBoundaries,
      'addSemanticIndexes': instance.addSemanticIndexes,
      'children': instance.children,
      'key': instance.key,
      'semanticIndexOffset': instance.semanticIndexOffset,
    };
