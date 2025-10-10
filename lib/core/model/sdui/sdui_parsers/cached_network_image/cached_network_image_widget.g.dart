// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cached_network_image_widget.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CachedNetorkImageWidgetImpl _$$CachedNetorkImageWidgetImplFromJson(
        Map<String, dynamic> json) =>
    _$CachedNetorkImageWidgetImpl(
      src: json['src'] as String,
      imageType: $enumDecodeNullable(_$ImageTypeEnumMap, json['imageType']) ??
          ImageType.network,
      color: json['color'] as String?,
      width: (json['width'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
      fit: $enumDecodeNullable(_$BoxFitEnumMap, json['fit']),
      blurHash: json['blurHash'] as String?,
    );

Map<String, dynamic> _$$CachedNetorkImageWidgetImplToJson(
        _$CachedNetorkImageWidgetImpl instance) =>
    <String, dynamic>{
      'src': instance.src,
      'imageType': _$ImageTypeEnumMap[instance.imageType]!,
      'color': instance.color,
      'width': instance.width,
      'height': instance.height,
      'fit': _$BoxFitEnumMap[instance.fit],
      'blurHash': instance.blurHash,
    };

const _$ImageTypeEnumMap = {
  ImageType.file: 'file',
  ImageType.network: 'network',
  ImageType.asset: 'asset',
};

const _$BoxFitEnumMap = {
  BoxFit.fill: 'fill',
  BoxFit.contain: 'contain',
  BoxFit.cover: 'cover',
  BoxFit.fitWidth: 'fitWidth',
  BoxFit.fitHeight: 'fitHeight',
  BoxFit.none: 'none',
  BoxFit.scaleDown: 'scaleDown',
};
