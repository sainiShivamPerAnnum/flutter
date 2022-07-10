import 'dart:math' as math;
import 'package:felloapp/core/model/journey_models/journey_path_model.dart';
import 'package:felloapp/ui/pages/hometabs/journey/journey_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class JourneyAssetPath extends StatelessWidget {
  final JourneyPageViewModel model;
  const JourneyAssetPath({Key key, this.model}) : super(key: key);

  getChild(JourneyPathModel item) {
    switch (item.asset.type) {
      case "SVG":
        print("network asset used for asset ${item.asset.name}");
        return
            // item.asset.uri == "NTWRK"
            //     ? SvgPicture.network(
            //         item.asset.uri,
            //         height: item.asset.height,
            //         width: item.asset.width,
            //       )
            //     :
            SvgPicture.network(
          "https://journey-assets-x.s3.ap-south-1.amazonaws.com/${item.asset.name}.svg",
          width: model.pageWidth * item.asset.width,
          height: model.pageHeight * item.asset.height,
        );
      case "PNG":
        return
            // item.asset.source == "NTWRK"
            //     ? Image.network(
            //         item.asset.uri,
            //         height: item.asset.height,
            //         width: item.asset.width,
            //       )
            //     :
            Image.asset(
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
            // decoration: BoxDecoration(
            //   border: Border.all(
            //     color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
            //         .withOpacity(1.0),
            //     width: 1,
            //   ),
            //   // borderRadius: BorderRadius.circular(10),
            // ),
            alignment: Alignment.bottomCenter,
            child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(
                    model.journeyPathItemsList[i].hFlip ? math.pi : 0),
                child: getChild(model.journeyPathItemsList[i])),
          ),
        ),
      ),
    );
  }
}
