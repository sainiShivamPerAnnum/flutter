import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/ui/pages/games/tambola/tambola_home/view_model/tambola_home_vm.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TambolaPrize extends StatelessWidget {
  const TambolaPrize({
    Key? key,
    required this.model,
  }) : super(key: key);

  final TambolaHomeViewModel model;

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: EdgeInsets.only(top: SizeConfig.screenWidth! * 0.15),
          decoration: BoxDecoration(
            color: UiConstants.kTambolaMidTextColor,
          ),
          child: Column(
            children: [
              SizedBox(
                height: SizeConfig.screenWidth! * 0.17,
              ),
              Text(
                locale.tPrizes,
                style: TextStyles.rajdhaniB.title4.colour(Colors.white),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding54),
                child: Text(
                  AppConfig.getValue<String?>(
                      AppConfigKey.game_tambola_announcement) ??
                      locale.tWin1Crore,
                  textAlign: TextAlign.center,
                  style: TextStyles.sourceSans.body4.colour(
                    Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                child: model.tPrizes == null
                    ? Center(
                  child: Column(
                    children: [
                      FullScreenLoader(
                        size: SizeConfig.padding80,
                      ),
                      SizedBox(
                        height: SizeConfig.padding16,
                      ),
                      Text(
                        locale.tFetch,
                        style: TextStyles.rajdhaniB.body2
                            .colour(Colors.white),
                      ),
                    ],
                  ),
                )
                    : ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: model.tPrizes!.prizesA!.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(
                          vertical: SizeConfig.padding16),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            Assets.tambolaPrizeAssets[index],
                            color: Colors.grey,
                            height: SizeConfig.padding44,
                            width: SizeConfig.padding44,
                          ),
                          SizedBox(
                            width: SizeConfig.padding10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                model.tPrizes!.prizesA![index]
                                    .displayName!,
                                style: TextStyles.rajdhaniB.body2
                                    .colour(Colors.white),
                              ),
                              Text(
                                locale.tCompleteToGet(model
                                    .tPrizes!.prizesA![index].displayName
                                    .toString()),
                                style: TextStyles.sourceSans.body4.colour(
                                    Colors.white.withOpacity(0.5)),
                              )
                            ],
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "₹${model.tPrizes!.prizesA![index].displayAmount}" ??
                                        "",
                                    style: TextStyles.sourceSans.body3
                                        .colour(Colors.white),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.end,
                                    children: [
                                      SvgPicture.asset(
                                        Assets.token,
                                        width: SizeConfig.padding12,
                                      ),
                                      SizedBox(
                                        width: SizeConfig.padding10,
                                      ),
                                      Text(
                                        "${model.tPrizes!.prizesA![index].flc}",
                                        style: TextStyles.sourceSans.body4
                                            .colour(Colors.white
                                            .withOpacity(0.5)),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding6),
          width: SizeConfig.screenWidth! * 0.3,
          height: SizeConfig.screenWidth! * 0.3,
          decoration: BoxDecoration(
            color: UiConstants.kTambolaMidTextColor,
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(
            "assets/svg/tambola_prize_asset.svg",
            width: double.maxFinite,
            height: double.maxFinite,
          ),
        ),
      ],
    );
  }
}
