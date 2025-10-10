// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stac_flexible_spacebar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StacFlexibleSpaceBarImpl _$$StacFlexibleSpaceBarImplFromJson(
        Map<String, dynamic> json) =>
    _$StacFlexibleSpaceBarImpl(
      title: json['title'] as String?,
      background: json['background'] as Map<String, dynamic>?,
      collapseMode:
          $enumDecodeNullable(_$CollapseModeEnumMap, json['collapseMode']) ??
              CollapseMode.parallax,
      centerTitle: json['centerTitle'] as bool? ?? true,
      stretchModes: (json['stretchModes'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$StretchModeEnumMap, e))
              .toList() ??
          const [StretchMode.zoomBackground],
      titlePadding: json['titlePadding'] == null
          ? null
          : StacEdgeInsets.fromJson(json['titlePadding']),
      expandedTitleScale: json['expandedTitleScale'] as bool? ?? false,
    );

Map<String, dynamic> _$$StacFlexibleSpaceBarImplToJson(
        _$StacFlexibleSpaceBarImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'background': instance.background,
      'collapseMode': _$CollapseModeEnumMap[instance.collapseMode]!,
      'centerTitle': instance.centerTitle,
      'stretchModes':
          instance.stretchModes.map((e) => _$StretchModeEnumMap[e]!).toList(),
      'titlePadding': instance.titlePadding,
      'expandedTitleScale': instance.expandedTitleScale,
    };

const _$CollapseModeEnumMap = {
  CollapseMode.parallax: 'parallax',
  CollapseMode.pin: 'pin',
  CollapseMode.none: 'none',
};

const _$StretchModeEnumMap = {
  StretchMode.zoomBackground: 'zoomBackground',
  StretchMode.blurBackground: 'blurBackground',
  StretchMode.fadeTitle: 'fadeTitle',
};
