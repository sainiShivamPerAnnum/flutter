import 'dart:io';

import 'package:felloapp/core/model/journey_models/journey_asset_model.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/journey/components/source_adaptive_asset/source_adaptive_asset.vm.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:flutter_svg/flutter_svg.dart';

class SourceAdaptiveAssetView extends StatelessWidget {
  final JourneyAssetModel asset;
  const SourceAdaptiveAssetView({this.asset});

  String generateAssetUrl(String name) {
    return "https://journey-assets-x.s3.ap-south-1.amazonaws.com/$name.svg";
  }

  @override
  Widget build(BuildContext context) {
    log("ROOTVIEW: Build called for SourceAdaptiveAsset widget");
    return BaseView<SourceAdaptiveAssetViewModel>(onModelReady: (model) {
      model.init(asset.uri);
    }, onModelDispose: (model) {
      model.dump();
    }, builder: (ctx, model, child) {
      return model.assetUrl.startsWith('http')
          ? NetworkAsset(
              asset: asset,
              networkUrl: model.assetUrl,
            )
          : FileAsset(
              asset: asset,
              filePath: model.assetUrl,
            );
    });
  }
}

class FileAsset extends StatelessWidget {
  final JourneyAssetModel asset;
  final String filePath;
  const FileAsset({@required this.asset, @required this.filePath});
  @override
  Widget build(BuildContext context) {
    log("ROOTVIEW: Build called for FileAsset widget");
    return SvgPicture.file(
      File(filePath),
    );
  }
}

class NetworkAsset extends StatelessWidget {
  final JourneyAssetModel asset;
  final String networkUrl;
  const NetworkAsset({@required this.asset, @required this.networkUrl});
  @override
  Widget build(BuildContext context) {
    log("ROOTVIEW: Build called for NetworkAsset widget");
    return SvgPicture.network(
      networkUrl,
      height: asset.height,
      width: asset.width,
    );
  }
}
