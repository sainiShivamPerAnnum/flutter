import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/ui/pages/hometabs/save/gold_components/gold_pro_card.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
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
    List<Tuple2<int, int>> multipliers = [
      const Tuple2(12, 5),
      const Tuple2(10, 3),
      const Tuple2(8, 1),
      const Tuple2(99, 1)
    ];
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
            itemBuilder: (ctx, i) => (multipliers[i].item1 == 8 &&
                    locator<UserService>()
                        .userSegments
                        .contains(Constants.US_FLO_OLD))
                ? const SizedBox()
                : GestureDetector(
                    onTap: () {
                      switch (multipliers[i].item1) {
                        case 12:
                          return BaseUtil.openFloBuySheet(
                              floAssetType: Constants.ASSET_TYPE_FLO_FIXED_6);
                        case 10:
                          return locator<UserService>()
                                  .userSegments
                                  .contains(Constants.US_FLO_OLD)
                              ? BaseUtil.openFloBuySheet(
                                  floAssetType: Constants.ASSET_TYPE_FLO_FELXI)
                              : BaseUtil.openFloBuySheet(
                                  floAssetType:
                                      Constants.ASSET_TYPE_FLO_FIXED_3);
                        case 8:
                          return BaseUtil.openFloBuySheet(
                              floAssetType: Constants.ASSET_TYPE_FLO_FELXI);
                        case 99:
                          return BaseUtil().openRechargeModalSheet(
                              investmentType: InvestmentType.AUGGOLD99);
                      }
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(SizeConfig.roundness12),
                      ),
                      color: multipliers[i].item1 == 99
                          ? UiConstants.kSaveDigitalGoldCardBg
                          : UiConstants.kSaveStableFelloCardBg,
                      margin: EdgeInsets.symmetric(
                          horizontal: SizeConfig.padding10),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  multipliers[i].item1 == 99
                                      ? FittedBox(
                                          child: Text("Digital Gold",
                                              style: TextStyles
                                                  .sourceSansSB.title5
                                                  .colour(Colors.white)),
                                        )
                                      : Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                  text:
                                                      '${multipliers[i].item1}%',
                                                  style: TextStyles
                                                      .sourceSansSB.title4
                                                      .colour(Colors.white)),
                                              TextSpan(
                                                  text: ' Flo',
                                                  style: TextStyles
                                                      .sourceSans.body3
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
                                                style: TextStyles
                                                    .sourceSansB.body2
                                                    .colour(UiConstants
                                                        .kSelectedDotColor)),
                                          ],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: SizeConfig.padding4),
                                      Text(
                                        "on saving",
                                        style: TextStyles.body4
                                            .colour(Colors.white),
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
