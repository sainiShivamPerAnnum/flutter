import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

enum _ImageType {
  normal,
  svg,
  lottie;
}

/// A possible source of image.
enum _ImageSourceType {
  network,
  local;
}

class AppImage extends StatelessWidget {
  final String image;
  final BoxFit? fit;
  final double? height;
  final double? width;
  final Color? color;

  const AppImage(
    this.image, {
    super.key,
    this.fit,
    this.height,
    this.width,
    this.color,
  });

  _ImageType get _getImageType {
    _ImageType appImageType = _ImageType.normal;
    if (image.endsWith('.svg')) appImageType = _ImageType.svg;
    if (image.endsWith('.json')) appImageType = _ImageType.lottie;
    return appImageType;
  }

  _ImageSourceType get _sourceType {
    _ImageSourceType imageSourceType = _ImageSourceType.local;
    if (image.startsWith('http')) imageSourceType = _ImageSourceType.network;
    return imageSourceType;
  }

  @override
  Widget build(BuildContext context) {
    final imageType = _getImageType;

    // to avoid re-computation in switch expression.
    final sourceType = _sourceType;

    switch (imageType) {
      case _ImageType.normal:
        switch (sourceType) {
          case _ImageSourceType.local:
            return Image.asset(
              image,
              fit: fit,
              height: height,
              width: width,
              color: color,
            );

          case _ImageSourceType.network:
            return Image.network(
              image,
              fit: fit,
              height: height,
              width: width,
              color: color,
            );
        }

      case _ImageType.svg:
        switch (sourceType) {
          case _ImageSourceType.local:
            return SvgPicture.asset(
              image,
              fit: fit ?? BoxFit.contain,
              height: height,
              width: width,
              color: color,
            );

          case _ImageSourceType.network:
            return SvgPicture.network(
              image,
              fit: fit ?? BoxFit.contain,
              height: height,
              width: width,
              color: color,
            );
        }

      case _ImageType.lottie:
        switch (sourceType) {
          case _ImageSourceType.local:
            return LottieBuilder.asset(
              image,
              fit: fit ?? BoxFit.contain,
              height: height,
              width: width,
            );

          case _ImageSourceType.network:
            return LottieBuilder.network(
              image,
              fit: fit ?? BoxFit.contain,
              height: height,
              width: width,
            );
        }
    }
  }
}
