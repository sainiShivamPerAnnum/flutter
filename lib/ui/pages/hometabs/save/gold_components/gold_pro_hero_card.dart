import 'dart:math' as math;

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/elements/fello_rich_text.dart';
import 'package:felloapp/ui/pages/hometabs/save/gold_components/gold_pro_card.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
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
        } else if (goldQuantity <=
            AppConfig.getValue(AppConfigKey.goldProInvestmentChips)[0]
                .toDouble()) {
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
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 17,
        vertical: 12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Get ${AppConfig.getValue(AppConfigKey.goldProInterest).toDouble()}% extra returns with ${Constants.ASSET_GOLD_STAKE} ",
            style: TextStyles.sourceSansM.body2
                .colour(UiConstants.kGoldProPrimary),
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
      ),
    );
  }
}

class ProgressGoldProHero extends StatelessWidget {
  const ProgressGoldProHero({required this.model, super.key});

  final UserService model;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 17,
        vertical: SizeConfig.padding12,
      ),
      child: Column(
        children: [
          Text(
            "Get ${AppConfig.getValue(AppConfigKey.goldProInterest).toDouble()}% extra returns with ${Constants.ASSET_GOLD_STAKE}",
            style: TextStyles.sourceSansSB.body3.colour(
              UiConstants.kGoldProPrimary,
            ),
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
                  AppConfig.getValue(AppConfigKey.goldProInvestmentChips)[0]
                      .toDouble(),
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
                "0 gms",
                style: TextStyles.sourceSansSB.body2.colour(Colors.white),
              ),
              const Spacer(),
              Text(
                "${AppConfig.getValue(AppConfigKey.goldProInvestmentChips)[0].toInt()} gms",
                style: TextStyles.sourceSansSB.body2.colour(Colors.white),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.padding12),
          Row(
            children: [
              Text(
                "Save ${BaseUtil.digitPrecision(AppConfig.getValue(AppConfigKey.goldProInvestmentChips)[0].toDouble() - (model.userFundWallet?.augGoldQuantity ?? 0.0), 4)} gms more to be eligible for Gold Pro",
                style: TextStyles.sourceSansM.body4.colour(
                  UiConstants.kGoldProPrimary,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                color: UiConstants.kGoldProPrimary,
                size: SizeConfig.iconSize3,
              )
            ],
          ),
        ],
      ),
    );
  }
}

enum CurvedRadius {
  top,
  bottom;
}

class GoldProExclusiveLabel extends StatelessWidget {
  final String label;
  final CurvedRadius curvedRadius;

  const GoldProExclusiveLabel({
    required this.label,
    this.curvedRadius = CurvedRadius.top,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double containerTransformation = 0.0;
    double contentTransformation = 0.0;

    if (curvedRadius == CurvedRadius.bottom) {
      containerTransformation = math.pi;
      contentTransformation = -math.pi;
    }

    return Transform.rotate(
      angle: containerTransformation,
      child: ClipPath(
        clipper: InverseBorderClipper(
          bottomCornerRadius: 12,
          upperCornerRadius: 16,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 4),
          color: UiConstants.kBackgroundColor,
          child: Transform.rotate(
            angle: contentTransformation,
            child: FelloRichText(
              paragraph: label,
              style: TextStyles.sourceSansSB.body4.copyWith(
                color: UiConstants.kGoldProPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class InverseBorderClipper extends CustomClipper<Path> {
  final double upperCornerRadius;
  final double bottomCornerRadius;

  InverseBorderClipper({
    this.upperCornerRadius = 14.0,
    this.bottomCornerRadius = 10.0,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(upperCornerRadius, 0);

    path.quadraticBezierTo(
      upperCornerRadius * 2,
      0,
      upperCornerRadius * 2,
      size.height - bottomCornerRadius,
    );

    path.quadraticBezierTo(
      upperCornerRadius * 2,
      size.height,
      (upperCornerRadius * 2) + bottomCornerRadius,
      size.height,
    );

    path.lineTo(
      size.width - ((upperCornerRadius * 2) + bottomCornerRadius),
      size.height,
    );

    path.quadraticBezierTo(
      size.width - (upperCornerRadius * 2),
      size.height,
      size.width - (upperCornerRadius * 2),
      size.height - bottomCornerRadius,
    );

    path.lineTo(
      size.width - (upperCornerRadius * 2),
      upperCornerRadius,
    );

    path.quadraticBezierTo(
      size.width - (upperCornerRadius * 2),
      0,
      size.width - upperCornerRadius,
      0,
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant InverseBorderClipper oldClipper) =>
      oldClipper.bottomCornerRadius != bottomCornerRadius ||
      oldClipper.upperCornerRadius != upperCornerRadius;
}

class EligibleGoldProHero extends StatelessWidget {
  const EligibleGoldProHero({required this.model, super.key});

  final UserService model;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 17,
        vertical: SizeConfig.padding16,
      ),
      child: Column(
        children: [
          Text(
            "You have unlocked Gold Pro!",
            style: TextStyles.sourceSansSB.body2.copyWith(
              color: UiConstants.kGoldProPrimary,
            ),
          ),
          SizedBox(height: SizeConfig.padding12),
          Row(
            children: [
              Text(
                "You are eligible for ${AppConfig.getValue(AppConfigKey.goldProInterest).toDouble()}% extra returns",
                style: TextStyles.sourceSansSB.body2.copyWith(
                  color: UiConstants.kGoldProPrimary,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                color: UiConstants.kGoldProPrimary,
                size: SizeConfig.iconSize2,
              )
            ],
          ),
        ],
      ),
    );
  }
}

class InvestedGoldProHero extends StatelessWidget {
  const InvestedGoldProHero({required this.model, super.key});

  final UserService model;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 17,
        vertical: 12,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Getting ${AppConfig.getValue(AppConfigKey.goldProInterest).toDouble()}% extra returns with ${Constants.ASSET_GOLD_STAKE} ",
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
                      "Gold Leased",
                      style: TextStyles.rajdhaniM.colour(Colors.white60),
                    ),
                    Text(
                      "${BaseUtil.digitPrecision(model.userFundWallet?.wAugFdQty ?? 0.0, 2)}gms",
                      style: TextStyles.sourceSansSB.title4
                          .colour(UiConstants.kGoldProPrimary),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Current Value",
                    style: TextStyles.rajdhaniM.colour(Colors.white60),
                  ),
                  Text(
                    "${model.userFundWallet?.augGoldQuantity ?? 0} gms",
                    style: TextStyles.sourceSansSB.title4
                        .colour(UiConstants.kGoldProPrimary),
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
