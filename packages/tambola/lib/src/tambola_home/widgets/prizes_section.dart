import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tambola/src/models/prizes_model.dart';
import 'package:tambola/src/tambola_home/widgets/loader.dart';
import 'package:tambola/src/utils/assets.dart';
import 'package:tambola/src/utils/styles/styles.dart';

class TambolaPrize extends StatelessWidget {
  const TambolaPrize({
    Key? key,
    required this.prizes,
  }) : super(key: key);

  // final TambolaHomeViewModel model;
  final PrizesModel? prizes;
  @override
  Widget build(BuildContext context) {
    // S locale = S.of(context);
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
                "Tambola Prizes",
                style: TextStyles.rajdhaniB.title4.colour(Colors.white),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding54),
                child: Text(
                  //TODO: REVERT WHEN PACAKGE IS SETUP

                  // AppConfig.getValue<String?>(
                  //         AppConfigKey.game_tambola_announcement) ??
                  "Winners are announced every Sunday at midnight, Complete a Full House and win 1Crore!",
                  textAlign: TextAlign.center,
                  style: TextStyles.sourceSans.body4.colour(
                    Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                child: prizes == null
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
                              "Fetching your tambola tickets..",
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
                        itemCount: prizes!.prizesA!.length,
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
                                      prizes!.prizesA![index].displayName!,
                                      style: TextStyles.rajdhaniB.body2
                                          .colour(Colors.white),
                                    ),
                                    Text(
                                      //TODO: REVERT WHEN PACAKGE IS SETUP
                                      // locale.tCompleteToGet(model
                                      //     .tPrizes!.prizesA![index].displayName
                                      //     .toString()),
                                      "",
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
                                          "₹${prizes!.prizesA![index].displayAmount}",
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
                                              "${prizes!.prizesA![index].flc}",
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
            Assets.tambolaPrizeAsset,
            width: double.maxFinite,
            height: double.maxFinite,
          ),
        ),
      ],
    );
  }
}
