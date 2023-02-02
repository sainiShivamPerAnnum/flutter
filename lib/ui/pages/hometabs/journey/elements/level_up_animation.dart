import 'package:felloapp/core/enums/journey_service_enum.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class LevelUpAnimation extends StatelessWidget {
  const LevelUpAnimation();
  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<JourneyService, JourneyServiceProperties>(
      properties: [JourneyServiceProperties.LevelCompletion],
      builder: (context, jModel, properties) {
        return jModel!.showLevelUpAnimation
            ? Align(
                alignment: Alignment.center,
                child: IgnorePointer(
                  ignoring: true,
                  child: Lottie.asset(
                    Assets.levelUpLottie,
                    width: SizeConfig.screenWidth,
                    fit: BoxFit.fitWidth,
                    controller: jModel.levelUpLottieController,
                    onLoaded: (composition) {
                      jModel.levelUpLottieController!
                        ..duration = composition.duration;
                    },
                  ),
                ),
              )
            : SizedBox();
      },
    );
  }
}
