import 'dart:io';

import 'package:felloapp/core/model/sdui/sdui_parsers/cached_network_image/cached_network_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:stac/stac.dart';

class CachedNetworkImageWidgetParser
    extends StacParser<CachedNetorkImageWidget> {
  const CachedNetworkImageWidgetParser();

  @override
  CachedNetorkImageWidget getModel(Map<String, dynamic> json) =>
      CachedNetorkImageWidget.fromJson(json);

  @override
  String get type => 'imageNetwork';

  @override
  Widget parse(BuildContext context, CachedNetorkImageWidget model) {
    switch (model.imageType) {
      case ImageType.network:
        return _networkImage(model, context);
      case ImageType.file:
        return _fileImage(model, context);
      case ImageType.asset:
        return _assetImage(model, context);
      default:
        return _networkImage(model, context);
    }
  }

  Widget _networkImage(CachedNetorkImageWidget model, BuildContext context) {
    return Stack(
      children: [
        if (model.blurHash != null)
          Positioned.fill(
            child: BlurHash(
              hash: model.blurHash!,
              imageFit: BoxFit.cover,
            ),
          ),
        Container(
          width: model.width,
          height: model.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                model.src,
              ),
              fit: model.fit,
              onError: (exception, stackTrace) {
                // Handle error case
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _fileImage(CachedNetorkImageWidget model, BuildContext context) =>
      Image.file(
        File(model.src),
        color: model.color?.toColor(context),
        width: model.width,
        height: model.height,
        fit: model.fit,
        errorBuilder: (context, error, stackTrace) {
          return const SizedBox();
        },
      );

  Widget _assetImage(CachedNetorkImageWidget model, BuildContext context) =>
      Image.asset(
        model.src,
        color: model.color?.toColor(context),
        width: model.width,
        height: model.height,
        fit: model.fit,
        errorBuilder: (context, error, stackTrace) {
          return const SizedBox();
        },
      );
}
