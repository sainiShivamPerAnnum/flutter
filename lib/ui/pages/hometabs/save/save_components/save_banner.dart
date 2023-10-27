import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/happy_hour_campign.dart';
import 'package:felloapp/core/service/analytics/mixpanel_analytics.dart';
import 'package:felloapp/core/service/notifier_services/marketing_event_handler_service.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/timer_utill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HappyHourBanner extends StatefulWidget {
  const HappyHourBanner(
      {required this.model, Key? key, this.isComingFromSave = false})
      : super(key: key);
  final HappyHourCampign model;
  final bool isComingFromSave;

  @override
  State<HappyHourBanner> createState() => _HappyHourBannerState(
      endTime: DateTime.parse(model.data!.endTime!),
      startTime: DateTime.parse(model.data!.startTime!));
}

class _HappyHourBannerState extends TimerUtil<HappyHourBanner> {
  _HappyHourBannerState(
      {required DateTime endTime, required DateTime startTime})
      : super(endTime: endTime, startTime: startTime);

  @override
  void closeTimer() {
    locator<MarketingEventHandlerService>().getHappyHourCampaign();
    super.closeTimer();
  }

  String getDateTime() {
    String time = "";
    if (inHours != "00") {
      time = time + inHours + ":";
    }

    return time + inMinutes + ":" + inSeconds;
  }

  @override
  Widget buildBody(BuildContext context) {
    S locale = S.of(context);
    return GestureDetector(
      onTap: () {
        locator<BaseUtil>().showHappyHourDialog(widget.model,
            isComingFromSave: widget.isComingFromSave);
        locator<MixpanelAnalytics>()
            .track(eventName: "Happy Hour Strip Tapped ", properties: {
          "Reward": {
            "asset":
                locator<HappyHourCampign>().data?.rewards?.first.type ?? "",
            "amount":
                locator<HappyHourCampign>().data?.rewards?.first.value ?? "",
            "timer": "$inHours:$inMinutes:$inSeconds"
          },
          "location": "Purple Strip"
        });
      },
      child: SizedBox(
        height: SizeConfig.screenHeight! * 0.07,
        width: SizeConfig.screenWidth,
        child: Container(
          height: double.infinity,
          alignment: Alignment.centerLeft,
          color: const Color(0xff495DB2),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              SvgPicture.asset(
                Assets.sandTimer,
                height: 42,
                width: 42,
              ),
              const SizedBox(
                width: 12,
              ),
              RichText(
                text: TextSpan(
                  text: "Happy Hour ends in ",
                  style: TextStyles.sourceSans.body3.colour(Colors.white),
                  children: [
                    TextSpan(
                        text: getDateTime(),
                        style:
                            TextStyles.sourceSansB.body3.colour(Colors.white)),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () =>
                    locator<BaseUtil>().showHappyHourDialog(widget.model),
                child: const Icon(
                  Icons.keyboard_arrow_right_outlined,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
