import 'dart:io';

import 'package:felloapp/core/model/journey_models/journey_asset_model.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/journey/components/source_adaptive_asset/source_adaptive_asset.vm.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:flutter_svg/flutter_svg.dart';

class SourceAdaptiveAssetView extends StatelessWidget {
  final JourneyAssetModel asset;
  final double height, width;
  const SourceAdaptiveAssetView(
      {@required this.asset, this.height, this.width});

  // String generateAssetUrl(String name) {
  //   return "https://journey-assets-x.s3.ap-south-1.amazonaws.com/$name.svg";
  // }

  @override
  Widget build(BuildContext context) {
    if (asset.name == "b1") log("Asset details: ${asset.toString()}");
    return BaseView<SourceAdaptiveAssetViewModel>(onModelReady: (model) {
      model.init(asset.uri);
    }, onModelDispose: (model) {
      model.dump();
    }, builder: (ctx, model, child) {
      return model.assetUrl.startsWith('http')
          ? NetworkAsset(
              asset: asset,
              networkUrl: model.assetUrl,
              height: height,
              width: width,
            )
          : FileAsset(
              asset: asset,
              filePath: model.assetUrl,
              height: height,
              width: width,
            );
    });
  }
}

class FileAsset extends StatelessWidget {
  final JourneyAssetModel asset;
  final String filePath;
  final double height, width;
  const FileAsset(
      {@required this.asset, @required this.filePath, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    // log("ROOTVIEW: Build called for FileAsset widget with height: ${asset.height}");
    dynamic file = File(filePath);
    return SvgPicture.file(
      file,
      height: height ?? SizeConfig.screenWidth * 2.165 * asset.height,
      width: width ?? SizeConfig.screenWidth * asset.width,
      fit: BoxFit.contain,
    );
  }
}

class NetworkAsset extends StatelessWidget {
  final JourneyAssetModel asset;
  final String networkUrl;
  final double height, width;
  const NetworkAsset(
      {@required this.asset,
      @required this.networkUrl,
      this.height,
      this.width});
  @override
  Widget build(BuildContext context) {
    // log("ROOTVIEW: Build called for NetworkAsset widget");
    return SvgPicture.network(
      networkUrl,
      height: height ?? SizeConfig.screenWidth * 2.165 * asset.height,
      width: width ?? SizeConfig.screenWidth * asset.width,
      fit: BoxFit.contain,
    );
  }
}
