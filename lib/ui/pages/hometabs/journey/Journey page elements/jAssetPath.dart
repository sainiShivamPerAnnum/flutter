import 'dart:math' as math;
import 'package:felloapp/core/model/journey_models/journey_path_model.dart';
import 'package:felloapp/ui/pages/hometabs/journey/journey_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class JourneyAssetPath extends StatelessWidget {
  final JourneyPageViewModel model;
  const JourneyAssetPath({Key key, this.model}) : super(key: key);

  getChild(JourneyPathModel item) {
    switch (item.type) {
      case "SVG":
        return item.source == "NTWRK"
            ? SvgPicture.network(
                item.asset,
                height: item.height,
                width: item.width,
              )
            : SvgPicture.asset(
                item.asset,
                width: model.pageWidth * item.width,
                height: model.pageHeight * item.height,
              );
      case "PNG":
        return item.source == "NTWRK"
            ? Image.network(
                item.asset,
                height: item.height,
                width: item.width,
              )
            : Image.asset(
                item.asset,
                width: model.pageWidth * item.width,
                height: model.pageHeight * item.height,
              );
    }
  }

  @override
  Widget build(BuildContext context) {
    model.journeyPathItemsList.sort((a, b) => a.dz.compareTo(b.dz));
    return Stack(
      children: List.generate(
        model.journeyPathItemsList.length,
        (i) => Positioned(
          left: model.pageWidth * model.journeyPathItemsList[i].dx,
          bottom: model.pageHeight * (model.journeyPathItemsList[i].page - 1) +
              model.pageHeight * model.journeyPathItemsList[i].dy,
          child: Container(
            width: model.pageWidth * model.journeyPathItemsList[i].width,
            height: model.pageHeight * model.journeyPathItemsList[i].height,
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
