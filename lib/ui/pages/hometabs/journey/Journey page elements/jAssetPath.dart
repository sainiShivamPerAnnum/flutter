import 'dart:developer';
import 'dart:math' as math;
import 'package:felloapp/core/model/journey_models/journey_asset_model.dart';
import 'package:felloapp/core/model/journey_models/journey_path_model.dart';
import 'package:felloapp/core/model/journey_models/milestone_model.dart';
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
    log("Journey path item list length ${model.journeyPathItemsList.length}");
    return SizedBox(
      height: model.pageHeight * 2,
      width: model.pageWidth,
      child: Stack(
        children: List.generate(
          model.journeyPathItemsList.length,
          (i) => Positioned(
            left: model.pageWidth * model.journeyPathItemsList[i].x,
            bottom:
                model.pageHeight * (model.journeyPathItemsList[i].page - 1) +
                    model.pageHeight * model.journeyPathItemsList[i].y,
            // child: Transform(
            //   alignment: Alignment.center,
            //   transform: Matrix4.rotationY(
            //       model.journeyPathItemsList[i].hFlip ? math.pi : 0),
            child: SourceAdaptiveAssetView(
              asset: model.journeyPathItemsList[i].asset,
              //),
            ),
          ),
        ),
      ),
    );
  }
}

class ActiveMilestoneBackgroundGlow extends StatelessWidget {
  final double radius;
  final JourneyPathModel asset;
  final JourneyPageViewModel model;
  const ActiveMilestoneBackgroundGlow(
      {Key key, this.radius, this.asset, this.model})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: model.pageWidth * asset.x,
      bottom: model.pageHeight * (asset.page - 1) + model.pageHeight * asset.y,
      child: Container(
        height: SizeConfig.screenWidth * asset.asset.width,
        width: SizeConfig.screenWidth * asset.asset.width,
        decoration: BoxDecoration(
          shape: BoxShape.circle, //color: Colors.black
          boxShadow: [
            BoxShadow(
              color: const Color(0xff62E3C4).withOpacity(0.8),
              spreadRadius: 0,
              blurRadius: SizeConfig.screenWidth * radius * 2,
              offset: const Offset(0, 0),
            )
          ],
        ),
      ),
    );
  }
}

class ActiveMilestoneBaseGlow extends StatelessWidget {
  // final Point? point;
  final JourneyPageViewModel model;
  final JourneyPathModel base;
  final Color color;
  // final Size size;

  const ActiveMilestoneBaseGlow({Key key, this.base, this.model, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: model.pageWidth * base.x,
      bottom: (model.pageHeight * (base.page - 1) + model.pageHeight * base.y),
      child: Container(
        width: model.pageWidth * base.asset.width,
        height: model.pageHeight * base.asset.height * 2,
        // color: Colors.black,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: ClipPath(
                clipper: const BackBeamClipper(),
                child: Container(
                  width: model.pageWidth * base.asset.width * 4,
                  height: model.pageHeight * base.asset.height * 1.5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      const Color(0xff62E3C4).withOpacity(0.01),
                      const Color(0xff62E3C4).withOpacity(0.5),
                      const Color(0xff62E3C4).withOpacity(0.3),
                      const Color(0xff62E3C4).withOpacity(0.1),
                      const Color(0xff62E3C4).withOpacity(0.01)
                    ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: BaseRings(
                size: model.pageWidth * base.asset.width * 0.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActiveMilestoneFrontGlow extends StatelessWidget {
  final MilestoneModel milestone;
  final JourneyPageViewModel model;
  const ActiveMilestoneFrontGlow({
    Key key,
    @required this.milestone,
    this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: (model.pageWidth * milestone.x) -
            (milestone.asset.width * model.pageWidth) * 0.6,
        bottom: model.pageHeight * (milestone.page - 1) +
            model.pageHeight * milestone.y,
        child: ClipPath(
          clipper: const FrontBeamClipper(),
          child: Container(
            width: model.pageWidth * milestone.asset.width * 2,
            height: model.pageWidth * milestone.asset.height,
            decoration: BoxDecoration(
              // color: Colors.black,
              gradient: LinearGradient(colors: [
                const Color(0xff62E3C4).withOpacity(0.01),
                const Color(0xff62E3C4).withOpacity(0.3),
                const Color(0xff62E3C4).withOpacity(0.1),
                const Color(0xff62E3C4).withOpacity(0.01)
              ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
            ),
          ),
        ));
  }
}

class BaseRings extends StatelessWidget {
  final double size;

  const BaseRings({Key key, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.rotationX(math.pi / 4),
      alignment: Alignment.center,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 6, color: Colors.white),
                    shape: BoxShape.circle),
                height: size * 0.4,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 3, color: Colors.white.withOpacity(0.8)),
                    shape: BoxShape.circle),
                height: size * 0.6,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 2, color: Colors.white.withOpacity(0.6)),
                    shape: BoxShape.circle),
                height: size,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MileStoneCheck extends StatelessWidget {
  final JourneyPageViewModel model;
  final MilestoneModel milestone;
  const MileStoneCheck({Key key, this.model, this.milestone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: model.pageWidth * 0.1,
      height: model.pageWidth * 0.1,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xff0C5462), width: 4),
        color: Colors.black,
      ),
      child: const Icon(Icons.check, color: Color(0xff62E3C4)),
    );
  }
}

class BackBeamClipper extends CustomClipper<Path> {
  const BackBeamClipper();

  @override
  getClip(Size size) {
    return Path()
      ..lineTo(0, 0)
      ..lineTo(size.width * 0.2, size.height)
      ..lineTo(size.width * 0.8, size.height)
      ..lineTo(size.width, 0)
      ..close();
  }

  /// Return false always because we always clip the same area.
  @override
  bool shouldReclip(CustomClipper oldClipper) => false;
}

class FrontBeamClipper extends CustomClipper<Path> {
  const FrontBeamClipper();

  @override
  getClip(Size size) {
    return Path()
      ..lineTo(0, 0)
      ..lineTo(size.width * 0.1, size.height)
      ..lineTo(size.width * 0.9, size.height)
      ..lineTo(size.width, 0)
      ..close();
  }

  /// Return false always because we always clip the same area.
  @override
  bool shouldReclip(CustomClipper oldClipper) => false;
}
