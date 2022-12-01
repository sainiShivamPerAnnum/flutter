import 'package:felloapp/core/enums/marketing_event_handler_enum.dart';
import 'package:felloapp/core/service/notifier_services/marketing_event_handler_service.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class DailyAppCheckInEventModalSheet extends StatelessWidget {
  const DailyAppCheckInEventModalSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<MarketingEventHandlerService,
        MarketingEventsHandlerProperties>(
      properties: [MarketingEventsHandlerProperties.DailyAppCheckIn],
      builder: ((context, model, child) => Transform.translate(
            offset: Offset(0, -SizeConfig.screenWidth! * 0.1),
            child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: SizeConfig.pageHorizontalMargins),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(Assets.giftGameAsset,
                      height: SizeConfig.screenWidth! * 0.2),
                  SizedBox(height: SizeConfig.padding20),
                  Text(
                    "Daily Bonus",
                    //model!.dailyAppCheckInEventData!.title
                    style: TextStyles.sourceSansB.title3.colour(Colors.white),
                  ),
                  SizedBox(height: SizeConfig.padding12),
                  Text(
                    "Open the app everyday for a week and win assured rewards",
                    textAlign: TextAlign.center,
                    style: TextStyles.body2.colour(Colors.white),
                    // model.dailyAppCheckInEventData!.subtitle
                  )
                ],
              ),
            ),
          )),
    );
  }
}
