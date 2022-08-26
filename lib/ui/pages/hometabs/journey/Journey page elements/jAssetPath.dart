import 'dart:developer';
import 'dart:math' as math;
import 'package:felloapp/core/enums/journey_service_enum.dart';
import 'package:felloapp/core/model/journey_models/journey_asset_model.dart';
import 'package:felloapp/core/model/journey_models/journey_path_model.dart';
import 'package:felloapp/core/model/journey_models/milestone_model.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/ui/pages/hometabs/journey/components/source_adaptive_asset/source_adaptive_asset_view.dart';
import 'package:felloapp/ui/pages/hometabs/journey/journey_vm.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class JourneyAssetPath extends StatefulWidget {
  final JourneyPageViewModel model;
  const JourneyAssetPath({Key key, this.model}) : super(key: key);
  @override
  State<JourneyAssetPath> createState() => _JourneyAssetPathState();
}

class _JourneyAssetPathState extends State<JourneyAssetPath> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.model.currentFullViewHeight,
      width: widget.model.pageWidth,
      child: Stack(
        children: List.generate(widget.model.journeyPathItemsList.length, (i) {
          return Positioned(
            left:
                widget.model.pageWidth * widget.model.journeyPathItemsList[i].x,
            bottom: widget.model.pageHeight *
                    (widget.model.journeyPathItemsList[i].page - 1) +
                widget.model.pageHeight *
                    widget.model.journeyPathItemsList[i].y,
            child: SourceAdaptiveAssetView(
              asset: widget.model.journeyPathItemsList[i].asset,
            ),
          );
        }),
      ),
    );
  }
}

// class JourneyAssetPath extends StatelessWidget {
//   final JourneyPageViewModel model;
//   const JourneyAssetPath({Key key, this.model}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // log("Journey path item list length ${model.journeyPathItemsList.length}");
//     // model.journeyPathItemsList.sort((a, b) => a.z.compareTo(b.z));
//     // log("Full Screen height of Journey View ${model.currentFullViewHeight}");
//     // final bg1 = model.journeyPathItemsList
//     //     .firstWhere((item) => item.asset.name == "b1");
//     // if (bg1 != null) {
//     //   print("Bg1 dx: ${model.pageWidth * bg1.x}");
//     //   print(
//     //       "Bg1 dy: ${model.pageHeight * (bg1.page - 1) + model.pageHeight * bg1.y}");
//     //   print("Bg1 width: ${model.pageWidth * bg1.asset.width}");
//     //   print("Bg1 height: ${model.pageHeight * bg1.asset.height}");
//     // }
//     return Container(
//       color: Colors.black,
//       height: model.currentFullViewHeight,
//       width: model.pageWidth,
//       child: Stack(
//         children: List.generate(model.journeyPathItemsList.length, (i) {
//           log("Path Assets ${model.journeyPathItemsList[i].asset.name} : page: ${model.journeyPathItemsList[i].page}  z: ${model.journeyPathItemsList[i].z} x: ${model.journeyPathItemsList[i].x} x: ${model.journeyPathItemsList[i].y} ");
//           return Positioned(
//             left: model.pageWidth * model.journeyPathItemsList[i].x,
//             bottom:
//                 model.pageHeight * (model.journeyPathItemsList[i].page - 1) +
//                     model.pageHeight * model.journeyPathItemsList[i].y,

//             child: SourceAdaptiveAssetView(
//               asset: model.journeyPathItemsList[i].asset,

//             ),
//           );
//         }),
//       ),
//     );
//   }
// }

class ActiveMilestoneBackgroundGlow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<JourneyService, JourneyServiceProperties>(
        properties: [JourneyServiceProperties.BaseGlow],
        builder: (context, model, properties) {
          final asset = model.journeyPathItemsList.firstWhere((element) =>
              element.mlIndex == model.avatarRemoteMlIndex && element.isBase);
          return Positioned(
            left: model.pageWidth * asset.x,
            bottom: model.pageHeight * (asset.page - 1) +
                model.pageHeight * asset.y,
            child: AnimatedOpacity(
              opacity: model.baseGlow,
              duration: Duration(milliseconds: 700),
              curve: Curves.easeInCubic,
              child: Container(
                height: SizeConfig.screenWidth * asset.asset.width,
                width: SizeConfig.screenWidth * asset.asset.width,
                decoration: BoxDecoration(
                  shape: BoxShape.circle, //color: Colors.black
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff62E3C4).withOpacity(0.8),
                      spreadRadius: 0,
                      blurRadius: SizeConfig.screenWidth,
                      offset: const Offset(0, 0),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class ActiveMilestoneBaseGlow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<JourneyService, JourneyServiceProperties>(
        properties: [
          JourneyServiceProperties.BaseGlow,
          JourneyServiceProperties.Pages,
        ],
        builder: (context, model, properties) {
          final JourneyPathModel base = model.journeyPathItemsList.firstWhere(
              (element) =>
                  element.mlIndex == model.avatarRemoteMlIndex &&
                  element.isBase,
              orElse: null);
          print("Base id: $base");
          return base != null
              ? Positioned(
                  left: model.pageWidth * base.x,
                  bottom: model.pageHeight * (base.page - 1) +
                      model.pageHeight * base.y,
                  child: AnimatedOpacity(
                    opacity: model.baseGlow,
                    curve: Curves.easeInCubic,
                    duration: Duration(milliseconds: 700),
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
                                height:
                                    model.pageHeight * base.asset.height * 1.5,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                        UiConstants.primaryColor
                                            .withOpacity(0.01),
                                        UiConstants.primaryColor
                                            .withOpacity(0.5),
                                        UiConstants.primaryColor
                                            .withOpacity(0.3),
                                        UiConstants.primaryColor
                                            .withOpacity(0.1),
                                        UiConstants.primaryColor
                                            .withOpacity(0.01)
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter),
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
                  ),
                )
              : SizedBox();
        });
  }
}

class ActiveMilestoneFrontGlow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<JourneyService, JourneyServiceProperties>(
        properties: [
          JourneyServiceProperties.BaseGlow,
          JourneyServiceProperties.AvatarPosition,
          JourneyServiceProperties.Pages,
        ],
        builder: (context, model, properties) {
          final MilestoneModel milestone = model.currentMilestoneList
              .firstWhere(
                  (element) => element.index == model.avatarRemoteMlIndex,
                  orElse: null);
          return milestone != null
              ? Positioned(
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
                        gradient: LinearGradient(
                            colors: [
                              UiConstants.primaryColor.withOpacity(0.01),
                              UiConstants.primaryColor.withOpacity(0.3),
                              UiConstants.primaryColor.withOpacity(0.1),
                              UiConstants.primaryColor.withOpacity(0.01)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter),
                      ),
                    ),
                  ))
              : SizedBox();
        });
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
  // final JourneyService model;
  final MilestoneModel milestone;
  const MileStoneCheck({Key key, this.milestone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth * 0.08,
      height: SizeConfig.screenWidth * 0.08,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: UiConstants.primaryColor, width: 3),
        color: Colors.black,
      ),
      child: Icon(
        Icons.check,
        size: SizeConfig.iconSize2,
        color: UiConstants.primaryColor,
      ),
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
