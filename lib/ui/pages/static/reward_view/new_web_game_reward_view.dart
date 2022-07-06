import 'package:felloapp/core/model/prizes_model.dart';
import 'package:felloapp/ui/pages/static/reward_view/components/rank_widget.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RewardView extends StatelessWidget {
  const RewardView({Key key, @required this.model}) : super(key: key);

  final PrizesModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding12,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding12,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          SizeConfig.roundness5,
        ),
        color: UiConstants.kLeaderBoardBackgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          RankWidget(
            firstPriceMoney:
                model.prizesA.firstWhere((element) => element.rank == 1).amt,
            firstPricePoint:
                model.prizesA.firstWhere((element) => element.rank == 1).flc,
            secondPriceMoney:
                model.prizesA.firstWhere((element) => element.rank == 2).amt,
            secondPricePoint:
                model.prizesA.firstWhere((element) => element.rank == 2).flc,
            thirdPriceMoney:
                model.prizesA.firstWhere((element) => element.rank == 3).amt,
            thirdPricePoint:
                model.prizesA.firstWhere((element) => element.rank == 3).flc,
          ),
          Column(
            children: List.generate(
              model.prizesA.length - 3,
              (index) {
                return Column(
                  children: [
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.0897,
                      child: Center(
                        child: ListTile(
                          leading: SvgPicture.asset(
                            'assets/temp/medal.svg',
                            width: SizeConfig.iconSize5,
                            height: SizeConfig.iconSize5,
                          ),
                          title: Text(
                            model.prizesA[index + 3].displayName.replaceFirst(
                              ' Prize',
                              '',
                            ),
                            style: TextStyles.rajdhaniSB.body2,
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Rs ${model.prizesA[index + 3].amt}',
                                style: TextStyles.sourceSans.body2,
                              ),
                              SizedBox(
                                width: SizeConfig.padding16,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    'assets/temp/Tokens.svg',
                                    width: SizeConfig.body2,
                                    height: SizeConfig.body2,
                                  ),
                                  SizedBox(
                                    width: SizeConfig.padding2,
                                  ),
                                  Text(
                                    '${model.prizesA[index + 3].flc}',
                                    style: TextStyles.sourceSans.body3,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (model.prizesA.length - 1 != index + 3)
                      Divider(
                        height: SizeConfig.dividerHeight,
                        color: UiConstants.kDividerColor,
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
