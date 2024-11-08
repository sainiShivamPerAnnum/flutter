import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/model/app_config_serialized_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/ui/pages/hometabs/save/gold_components/gold_pro_card.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tuple/tuple.dart';

class TicketMultiplierOptionsWidget extends StatelessWidget {
  const TicketMultiplierOptionsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<LendboxAssetConfiguration> lendboxDetails =
        AppConfigV2.instance.lbV2.values.toList();
    List<Tuple3<num, int, String>> multipliers = [
      for (var value in lendboxDetails)
        Tuple3(value.interest, value.tambolaMultiplier.toInt(), value.fundType)
    ];
    multipliers.add(const Tuple3(99, 1, 'AUGGOLD'));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleSubtitleContainer(
          title: "Tickets Multiplier",
          leadingPadding: true,
          padding: EdgeInsets.symmetric(
              vertical: SizeConfig.padding12,
              horizontal: SizeConfig.pageHorizontalMargins),
        ),
        SizedBox(
          height: SizeConfig.screenWidth! * 0.32,
          child: ListView.builder(
            itemCount: multipliers.length,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
                horizontal:
                    SizeConfig.pageHorizontalMargins - SizeConfig.padding10),
            scrollDirection: Axis.horizontal,
            itemBuilder: (ctx, i) => GestureDetector(
              onTap: () {
                if (multipliers[i].item1 == 99.0) {
                  return BaseUtil().openRechargeModalSheet(
                      investmentType: InvestmentType.AUGGOLD99);
                } else {
                  BaseUtil.openFloBuySheet(floAssetType: multipliers[i].item3);
                }
                locator<AnalyticsService>().track(
                    eventName: AnalyticsEvents.ticketsMultiplierBannerTapped,
                    properties: {
                      'type': multipliers[i].item1,
                    });
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SizeConfig.roundness12),
                ),
                color: multipliers[i].item1 == 99
                    ? UiConstants.kSaveDigitalGoldCardBg
                    : UiConstants.kSaveStableFelloCardBg,
                margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding10),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness12),
                      child: SizedBox(
                        height: SizeConfig.screenWidth! * 0.36,
                        width: SizeConfig.screenWidth! * 0.33,
                        child: const GoldShimmerWidget(
                          size: ShimmerSizeEnum.medium,
                        ),
                      ),
                    ),
                    Container(
                      width: SizeConfig.screenWidth! * 0.33,
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.padding16,
                          vertical: SizeConfig.padding10),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            multipliers[i].item1 == 99
                                ? FittedBox(
                                    child: Text("Digital Gold",
                                        style: TextStyles.sourceSansSB.title5
                                            .colour(Colors.white)),
                                  )
                                : Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                            text: '${multipliers[i].item1}%',
                                            style: TextStyles
                                                .sourceSansSB.title4
                                                .colour(Colors.white)),
                                        TextSpan(
                                            text: ' Flo',
                                            style: TextStyles.sourceSans.body3
                                                .colour(Colors.white)),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                            Column(
                              children: [
                                SizedBox(height: SizeConfig.padding4),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      WidgetSpan(
                                        child: SvgPicture.asset(
                                          Assets.singleTambolaTicket,
                                          width: SizeConfig.padding20,
                                        ),
                                      ),
                                      TextSpan(
                                          text:
                                              '  ${multipliers[i].item2}X tickets',
                                          style: TextStyles.sourceSansB.body2
                                              .colour(UiConstants
                                                  .kSelectedDotColor)),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: SizeConfig.padding4),
                                Text(
                                  "on savings",
                                  style: TextStyles.body4.colour(Colors.white),
                                ),
                              ],
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: SizeConfig.padding10)
      ],
    );
  }
}
