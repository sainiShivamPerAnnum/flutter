import 'package:felloapp/core/enums/journey_service_enum.dart';
import 'package:felloapp/core/model/scratch_card_model.dart';
import 'package:felloapp/core/model/timestamp_model.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/ui/pages/hometabs/journey/elements/jMilestones.dart';
import 'package:felloapp/ui/pages/hometabs/journey/journey_vm.dart';
import 'package:felloapp/ui/pages/rewards/instant_scratch_card/gt_instant_view.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class PrizeToolTips extends StatelessWidget {
  final JourneyPageViewModel model;
  PrizeToolTips({required this.model, Key? key}) : super(key: key);
  final _gtService = locator<ScratchCardService>();
  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<JourneyService, JourneyServiceProperties>(
        properties: const [
          JourneyServiceProperties.Prizes,
        ],
        builder: (context, serviceModel, properties) {
          return SizedBox(
            width: model.pageWidth,
            height: model.currentFullViewHeight,
            child: model.completedMilestonePrizeList.isEmpty
                ? const SizedBox()
                : Stack(
                    children:
                        List.generate(model.completedMilestoneList.length, (i) {
                      final milestone = model.completedMilestoneList[i];
                      final ScratchCard? scratchCard =
                          model.completedMilestonePrizeList.length >= i + 1
                              ? model.completedMilestonePrizeList[i]
                              : null;
                      return (scratchCard != null &&
                              scratchCard.isRewarding! &&
                              scratchCard.redeemedTimestamp ==
                                  TimestampModel(seconds: 0, nanoseconds: 0))
                          ? Positioned(
                              left: model.pageWidth! * milestone.x! * 0.9,
                              bottom:
                                  (model.pageHeight! * (milestone.page - 1) +
                                          model.pageHeight! * milestone.y!) +
                                      model.pageHeight! *
                                          milestone.asset.height *
                                          0.5,
                              child: SafeArea(
                                child: GestureDetector(
                                    onTap: () async {
                                      ScratchCardService.currentGT =
                                          scratchCard;
                                      _gtService.showInstantScratchCardView(
                                          source: GTSOURCE.prize,
                                          onJourney: true);
                                    },
                                    child: Container(
                                      decoration: const ShapeDecoration(
                                        color: Colors.black,
                                        shape:
                                            TooltipShapeBorder(arrowArc: 0.5),
                                        shadows: [
                                          BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 4.0,
                                              offset: Offset(2, 2))
                                        ],
                                      ),
                                      child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Image.asset(
                                            scratchCard.isLevelChange!
                                                ? Assets
                                                    .levelUpUnredeemedScratchCardBGPNG
                                                : Assets
                                                    .unredeemedScratchCardBG_png,
                                            width: SizeConfig.padding40,
                                          )),
                                    )),
                              ),
                            )
                          : const SizedBox();
                    }),
                  ),
          );
        });
  }
}
