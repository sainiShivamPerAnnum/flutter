// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stac_network_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StacNetworkRequestImpl _$$StacNetworkRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$StacNetworkRequestImpl(
      url: json['url'] as String,
      cBaseUrl: json['cBaseUrl'] as String,
      method:
          $enumDecodeNullable(_$MethodEnumMap, json['method']) ?? Method.get,
      isS3Request: json['isS3Request'] as bool? ?? false,
      queryParameters: json['queryParameters'] as Map<String, dynamic>?,
      headers: json['headers'] as Map<String, dynamic>?,
      contentType: json['contentType'] as String?,
      body: json['body'],
      results: (json['results'] as List<dynamic>?)
              ?.map(
                  (e) => StacNetworkResult.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$StacNetworkRequestImplToJson(
        _$StacNetworkRequestImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'cBaseUrl': instance.cBaseUrl,
      'method': _$MethodEnumMap[instance.method]!,
      'isS3Request': instance.isS3Request,
      'queryParameters': instance.queryParameters,
      'headers': instance.headers,
      'contentType': instance.contentType,
      'body': instance.body,
      'results': instance.results,
    };

const _$MethodEnumMap = {
  Method.get: 'get',
  Method.post: 'post',
  Method.put: 'put',
  Method.delete: 'delete',
};

_$StacNetworkResultImpl _$$StacNetworkResultImplFromJson(
        Map<String, dynamic> json) =>
    _$StacNetworkResultImpl(
      statusCode: (json['statusCode'] as num).toInt(),
      action: json['action'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$$StacNetworkResultImplToJson(
        _$StacNetworkResultImpl instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'action': instance.action,
    };
