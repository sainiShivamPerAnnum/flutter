import 'package:felloapp/core/enums/journey_service_enum.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/ui/pages/hometabs/journey/Journey%20page%20elements/jMilestones.dart';
import 'package:felloapp/ui/pages/hometabs/journey/journey_vm.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class MilestoneTooltip extends StatelessWidget {
  final JourneyPageViewModel model;
  const MilestoneTooltip({Key key, this.model}) : super(key: key);

  @override
  build(BuildContext context) {
    return PropertyChangeConsumer<JourneyService, JourneyServiceProperties>(
        properties: [
          JourneyServiceProperties.AvatarPosition,
          JourneyServiceProperties.BaseGlow,
          JourneyServiceProperties.Pages,
        ],
        builder: (context, serviceModel, properties) {
          return SizedBox(
            width: model.pageWidth,
            height: model.currentFullViewHeight,
            child: Stack(
              children: List.generate(model.currentMilestoneList.length, (i) {
                if (model.currentMilestoneList[i].index ==
                        model.avatarActiveMilestoneLevel &&
                    model.currentMilestoneList[i].index != 1 &&
                    model.currentMilestoneList[i].tooltip != null &&
                    model.currentMilestoneList[i].tooltip.isNotEmpty) {
                  final milestone = model.currentMilestoneList[i];
                  return Positioned(
                    left: model.pageWidth * milestone.x / 2,
                    bottom: (model.pageHeight * (milestone.page - 1) +
                            model.pageHeight * milestone.y) +
                        model.pageHeight * milestone.asset.height * 1.2,
                    child: SafeArea(
                      child: GestureDetector(
                          onTap: () => model.showMilestoneDetailsModalSheet(
                              milestone, context),
                          child: Container(
                            decoration: ShapeDecoration(
                              color: Colors.black,
                              shape: TooltipShapeBorder(arrowArc: 0.5),
                              shadows: [
                                BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4.0,
                                    offset: Offset(2, 2))
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("${milestone.tooltip}",
                                      style: TextStyles.sourceSansSB.body2),
                                  Icon(Icons.arrow_forward_ios_rounded,
                                      color: Colors.white,
                                      size: SizeConfig.iconSize1),
                                ],
                              ),
                            ),
                          )),
                    ),
                  );
                } else
                  return SizedBox();
              }),
            ),
          );
        });
  }
}
