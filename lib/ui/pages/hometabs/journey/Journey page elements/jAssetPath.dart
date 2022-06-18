import 'package:felloapp/core/model/journey_models/journey_path_model.dart';
import 'package:felloapp/ui/pages/hometabs/journey/journey_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class JourneyAssetPath extends StatelessWidget {
  const JourneyAssetPath({Key key}) : super(key: key);

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
                width: JourneyPageViewModel.pageWidth * item.width,
                height: JourneyPageViewModel.pageHeight * item.height,
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
                width: JourneyPageViewModel.pageWidth * item.width,
                height: JourneyPageViewModel.pageHeight * item.height,
              );
    }
  }

  @override
  Widget build(BuildContext context) {
    JourneyPageViewModel.journeyPathItemsList
        .sort((a, b) => a.dz.compareTo(b.dz));
    return Stack(
      children: List.generate(
        JourneyPageViewModel.journeyPathItemsList.length,
        (i) => Positioned(
          left: JourneyPageViewModel.pageWidth *
              JourneyPageViewModel.journeyPathItemsList[i].dx,
          bottom: JourneyPageViewModel.pageHeight *
              JourneyPageViewModel.journeyPathItemsList[i].dy,
          child: Container(
            width: JourneyPageViewModel.pageWidth *
                JourneyPageViewModel.journeyPathItemsList[i].width,
            height: JourneyPageViewModel.pageHeight *
                JourneyPageViewModel.journeyPathItemsList[i].height,
            // decoration: BoxDecoration(
            //   border: Border.all(
            //     color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
            //         .withOpacity(1.0),
            //     width: 1,
            //   ),
            //   // borderRadius: BorderRadius.circular(10),
            // ),
            alignment: Alignment.bottomCenter,
            child: getChild(JourneyPageViewModel.journeyPathItemsList[i]),
          ),
        ),
      ),
    );
  }
}
