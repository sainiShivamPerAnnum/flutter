import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/pages/hometabs/save/gold_components/gold_pro_card.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class GoldProHero extends StatelessWidget {
  const GoldProHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserService>(
      builder: (context, model, child) {
        final double goldQuantity =
            model.userFundWallet?.augGoldQuantity ?? 0.0;
        final double goldProQuantity = model.userFundWallet?.wAugFdQty ?? 0.0;
        if (goldProQuantity != 0) {
          return InvestedGoldProHero(model: model);
        } else if (goldQuantity <= 0) {
          return NewGoldProHero(model: model);
        } else if (goldQuantity <= 0.5) {
          return ProgressGoldProHero(model: model);
        } else {
          return EligibleGoldProHero(model: model);
        }
      },
    );
  }
}

class NewGoldProHero extends StatelessWidget {
  const NewGoldProHero({required this.model, super.key});

  final UserService model;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Get 4.5% extra returns with ${Constants.ASSET_GOLD_STAKE} ",
          style:
              TextStyles.sourceSansM.body2.colour(UiConstants.kGoldProPrimary),
        ),
        Transform.translate(
          offset: Offset(0, SizeConfig.padding1),
          child: Icon(
            Icons.arrow_forward_ios,
            size: SizeConfig.iconSize2,
            color: UiConstants.kGoldProPrimary,
          ),
        )
      ],
    );
  }
}

class ProgressGoldProHero extends StatelessWidget {
  const ProgressGoldProHero({required this.model, super.key});

  final UserService model;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Get 4.5% extra returns with ${Constants.ASSET_GOLD_STAKE} ",
          style:
              TextStyles.sourceSansSB.body2.colour(UiConstants.kGoldProPrimary),
        ),
        SizedBox(height: SizeConfig.padding18),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.white,
          ),
          alignment: Alignment.centerLeft,
          height: SizeConfig.padding16,
          width: SizeConfig.screenWidth,
          child: FractionallySizedBox(
            widthFactor: BaseUtil.digitPrecision(
                    model.userFundWallet?.augGoldQuantity ?? 0.0, 2) /
                0.5,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                gradient: LinearGradient(
                  colors: [
                    UiConstants.kGoldProPrimary,
                    UiConstants.KGoldProPrimaryDark
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const GoldShimmerWidget(
                size: ShimmerSizeEnum.small,
              ),
            ),
          ),
        ),
        SizedBox(height: SizeConfig.padding8),
        Row(
          children: [
            Text(
              "0.0g",
              style: TextStyles.sourceSansSB.body0.colour(Colors.white),
            ),
            const Spacer(),
            Text(
              "0.5g",
              style: TextStyles.sourceSansSB.body0.colour(Colors.white),
            ),
          ],
        ),
        SizedBox(height: SizeConfig.padding16),
        Row(
          children: [
            Text(
              "Get 4.5% extra returns with ${Constants.ASSET_GOLD_STAKE} ",
              style: TextStyles.sourceSansM.body3
                  .colour(UiConstants.kGoldProPrimary),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: UiConstants.kGoldProPrimary,
              size: SizeConfig.iconSize2,
            )
          ],
        )
      ],
    );
  }
}

class EligibleGoldProHero extends StatelessWidget {
  const EligibleGoldProHero({required this.model, super.key});

  final UserService model;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Congratulations!",
          style:
              TextStyles.sourceSansB.body1.colour(UiConstants.kGoldProPrimary),
        ),
        SizedBox(height: SizeConfig.padding16),
        Row(
          children: [
            Text(
              "You are eligible for 4.5% extra returns",
              style: TextStyles.sourceSansM.body3
                  .colour(UiConstants.kGoldProPrimary),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: UiConstants.kGoldProPrimary,
              size: SizeConfig.iconSize2,
            )
          ],
        ),
        SizedBox(height: SizeConfig.padding6),
      ],
    );
  }
}

class InvestedGoldProHero extends StatelessWidget {
  const InvestedGoldProHero({required this.model, super.key});

  final UserService model;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "Getting 4.5% extra returns with ${Constants.ASSET_GOLD_STAKE} ",
              style: TextStyles.sourceSansM.body3
                  .colour(UiConstants.kGoldProPrimary),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: UiConstants.kGoldProPrimary,
              size: SizeConfig.iconSize2,
            )
          ],
        ),
        SizedBox(height: SizeConfig.padding16),
        Row(
          children: [
            Expanded(
              flex: 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Leased Amount",
                    style: TextStyles.rajdhaniM.colour(Colors.white60),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          "₹${BaseUtil.digitPrecision(model.userPortfolio.goldPro.balance)}",
                          style: TextStyles.sourceSansSB.title4
                              .colour(UiConstants.kGoldProPrimary),
                        ),
                      ),
                      Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(width: SizeConfig.padding6),
                              Transform.translate(
                                offset: Offset(0, -SizeConfig.padding4),
                                child: RotatedBox(
                                  quarterTurns: BaseUtil.digitPrecision(
                                              model.userPortfolio.goldPro
                                                  .absGains,
                                              2) >=
                                          0
                                      ? 0
                                      : 2,
                                  child: SvgPicture.asset(
                                    Assets.arrow,
                                    width: SizeConfig.iconSize2,
                                    color: BaseUtil.digitPrecision(
                                                model.userPortfolio.goldPro
                                                    .absGains,
                                                2) >=
                                            0
                                        ? UiConstants.primaryColor
                                        : Colors.red,
                                  ),
                                ),
                              ),
                              Text(
                                  " ${BaseUtil.digitPrecision(
                                    BaseUtil.digitPrecision(
                                        model.userPortfolio.goldPro.percGains,
                                        2),
                                    2,
                                    false,
                                  )}%",
                                  style: TextStyles.sourceSans.body3.colour(
                                      BaseUtil.digitPrecision(
                                                  model.userPortfolio.goldPro
                                                      .absGains,
                                                  2) >=
                                              0
                                          ? UiConstants.primaryColor
                                          : Colors.red)),
                            ],
                          ),
                          SizedBox(
                            height: SizeConfig.padding4,
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Leased Value",
                    style: TextStyles.rajdhaniM.colour(Colors.white60),
                  ),
                  Text(
                    "${BaseUtil.digitPrecision(model.userFundWallet?.wAugFdQty ?? 0.0, 2)}gms",
                    style: TextStyles.sourceSansSB.title4
                        .colour(UiConstants.kGoldProPrimary),
                  )
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}
