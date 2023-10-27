import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/asset_options_model.dart' as I;
import 'package:felloapp/core/model/happy_hour_campign.dart';
import 'package:felloapp/core/service/notifier_services/marketing_event_handler_service.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:felloapp/util/timer_utill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/service/analytics/mixpanel_analytics.dart';

class BannerWidget extends StatefulWidget {
  BannerWidget({
    required this.model,
    required this.happyHourCampign,
    Key? key,
  })  : showHappyHour = happyHourCampign?.data?.showHappyHour ?? false,
        super(key: key);
  final I.Banner model;
  final bool showHappyHour;
  final HappyHourCampign? happyHourCampign;

  @override
  State<BannerWidget> createState() => _BannerWidgetState(
      endTime: DateTime.tryParse(happyHourCampign?.data?.endTime ?? ''),
      startTime: DateTime.tryParse(happyHourCampign?.data?.startTime ?? ''));
}

class _BannerWidgetState extends TimerUtil<BannerWidget> {
  _BannerWidgetState({required DateTime? endTime, required DateTime? startTime})
      : super(
            endTime: endTime ?? DateTime.now(),
            startTime: startTime ?? DateTime.now());

  late bool showHappyHour;

  @override
  void initState() {
    showHappyHour = locator<MarketingEventHandlerService>().showHappyHourBanner;
    super.initState();
  }

  @override
  void closeTimer() {
    showHappyHour = false;
    super.closeTimer();
  }

  String getString() {
    String text = "";
    if (inHours != "00") {
      text = "$text$inHours:";
    }
    return "$text$inMinutes:$inSeconds";
  }

  @override
  Widget buildBody(BuildContext context) {
    S locale = S.of(context);
    return GestureDetector(
      onTap: () {
        if (showHappyHour) {
          locator<BaseUtil>().showHappyHourDialog(locator<HappyHourCampign>(),
              isComingFromSave: true);
          locator<MixpanelAnalytics>()
              .track(eventName: "Happy Hour Strip Tapped ", properties: {
            "Reward": {
              "asset":
                  locator<HappyHourCampign>().data?.rewards?.first.type ?? "",
              "amount":
                  locator<HappyHourCampign>().data?.rewards?.first.value ?? "",
              "timer": "$inHours:$inMinutes:$inSeconds"
            },
            "location": "Inside Save Strip"
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xff1A1A1A).withOpacity(0.5),
          // : UiConstants.kModalSheetSecondaryBackgroundColor
          //     .withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        margin:
            EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
        padding: EdgeInsets.symmetric(
          vertical: SizeConfig.padding6,
          horizontal: SizeConfig.padding16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: SizeConfig.padding28,
              width: SizeConfig.padding28,
              child: showHappyHour
                  ? SvgPicture.asset(Assets.sandTimer)
                  : SvgPicture.asset(
                      Assets.howToPlayAsset1Tambola,
                      fit: BoxFit.contain,
                    ),
            ),
            SizedBox(width: SizeConfig.padding10),
            Flexible(
              child: showHappyHour
                  ? RichText(
                      text: TextSpan(
                          style: TextStyles.rajdhaniSB.body3
                              .colour(const Color(0XFFB5CDCB)),
                          text: locale.happyHoursEndsIn,
                          children: [
                            TextSpan(
                                text: getString(),
                                style: TextStyles.rajdhaniB
                                    .colour(const Color(0xff51EADD)))
                          ]),
                    )
                  : Text(
                      widget.model.title,
                      maxLines: 2,
                      style: TextStyles.sourceSans.body4
                          .colour(UiConstants.kTextColor3),
                    ),
            ),
            const SizedBox(
              width: 8,
            ),
            if (showHappyHour)
              GestureDetector(
                onTap: () => locator<BaseUtil>().showHappyHourDialog(
                    locator<HappyHourCampign>(),
                    isComingFromSave: true),
                child: const Icon(
                  Icons.info_outline,
                  size: 20,
                  color: Color(0xffB5CDCB),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
