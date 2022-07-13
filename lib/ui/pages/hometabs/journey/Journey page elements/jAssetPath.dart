import 'dart:math' as math;
import 'package:felloapp/core/model/journey_models/journey_path_model.dart';
import 'package:felloapp/ui/pages/hometabs/journey/components/source_adaptive_asset/source_adaptive_asset_view.dart';
import 'package:felloapp/ui/pages/hometabs/journey/journey_vm.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class JourneyAssetPath extends StatelessWidget {
  final JourneyPageViewModel model;
  const JourneyAssetPath({Key key, this.model}) : super(key: key);

  getChild(JourneyPathModel item) {
    switch (item.asset.assetType) {
      case "svg":
        print("network asset used for asset ${item.asset.name}");
        return SvgPicture.network(
          item.asset.uri,
          width: model.pageWidth * item.asset.width,
          height: model.pageHeight * item.asset.height,
        );
      case "PNG":
        return Image.asset(
          item.asset.uri,
          width: model.pageWidth * item.asset.width,
          height: model.pageHeight * item.asset.height,
        );
      case "":
        return SvgPicture.network(
          item.asset.uri,
          width: model.pageWidth * item.asset.width,
          height: model.pageHeight * item.asset.height,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    model.journeyPathItemsList.sort((a, b) => a.z.compareTo(b.z));
    return Stack(
      children: List.generate(
        model.journeyPathItemsList.length,
        (i) => Positioned(
          left: model.pageWidth * model.journeyPathItemsList[i].x,
          bottom: model.pageHeight * (model.journeyPathItemsList[i].page - 1) +
              model.pageHeight * model.journeyPathItemsList[i].y,
          child: Container(
            width: model.pageWidth * model.journeyPathItemsList[i].asset.width,
            height:
                model.pageHeight * model.journeyPathItemsList[i].asset.height,
            alignment: Alignment.bottomCenter,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(
                  model.journeyPathItemsList[i].hFlip ? math.pi : 0),
              child: SourceAdaptiveAssetView(
                asset: model.journeyPathItemsList[i].asset,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
