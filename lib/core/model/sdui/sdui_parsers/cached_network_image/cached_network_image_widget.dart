import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cached_network_image_widget.freezed.dart';
part 'cached_network_image_widget.g.dart';

enum ImageType { file, network, asset }

@freezed
class CachedNetorkImageWidget with _$CachedNetorkImageWidget {
  const factory CachedNetorkImageWidget({
    required String src,
    @Default(ImageType.network) ImageType imageType,
    String? color,
    double? width,
    double? height,
    BoxFit? fit,
    String? blurHash,
  }) = _CachedNetorkImageWidget;

  factory CachedNetorkImageWidget.fromJson(Map<String, dynamic> json) =>
      _$CachedNetorkImageWidgetFromJson(json);
}
