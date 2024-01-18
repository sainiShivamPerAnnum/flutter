import 'dart:math';

import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GoldProCard extends StatelessWidget {
  const GoldProCard({super.key});

  @override
  Widget build(BuildContext context) {
    final goldProInterest = AppConfig.getValue(AppConfigKey.goldProInterest);
    return GestureDetector(
      onTap: () {
        AppState.delegate!.parseRoute(Uri.parse('goldProDetails'));
        final UserService userService = locator<UserService>();
        locator<AnalyticsService>().track(
          eventName: AnalyticsEvents.goldProBannerTapped,
          properties: {
            'current Gold Balance':
                userService.userFundWallet?.augGoldQuantity ?? 0,
            'isNewUser': userService.userSegments.contains("NEW_USER"),
            'current flo balance': userService.userPortfolio.flo.balance,
            "existing lease amount":
                userService.userPortfolio.augmont.fd.balance,
            "existing lease grams": userService.userFundWallet?.wAugFdQty ?? 0
          },
        );
      },
      child: Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight! * 0.21,
        margin: EdgeInsets.symmetric(
          vertical: SizeConfig.padding16,
          horizontal: SizeConfig.pageHorizontalMargins,
        ),
        decoration: BoxDecoration(
          color: UiConstants.kGoldProBgColor,
          border: Border.all(color: UiConstants.kGoldProBorder, width: 2),
          borderRadius: BorderRadius.circular(SizeConfig.roundness16),
        ),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(SizeConfig.roundness16),
              child: Transform.scale(
                scale: 1.1,
                child: const GoldShimmerWidget(
                  size: ShimmerSizeEnum.large,
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.all(SizeConfig.padding16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Get extra $goldProInterest Returns on your Gold",
                          style: TextStyles.rajdhaniSB.body1
                              .colour(UiConstants.kGoldProPrimary),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: SizeConfig.iconSize2,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "By Leasing your Gold with",
                              style: TextStyles.sourceSans.body3
                                  .colour(UiConstants.KGoldProSecondary),
                            ),
                            SizedBox(height: SizeConfig.padding16),
                            SvgPicture.asset(
                              Assets.augmontLogo,
                              color: UiConstants.kGoldProPrimary,
                              height: SizeConfig.padding12,
                            )
                          ],
                        ),
                        const Spacer(),
                        SvgPicture.asset(
                          Assets.goldAsset,
                          height: SizeConfig.padding90,
                        ),
                        SizedBox(
                          width: SizeConfig.pageHorizontalMargins,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          Assets.multiAvatars,
                          height: SizeConfig.padding12,
                        ),
                        SizedBox(width: SizeConfig.padding8),
                        Text(
                          "Limited Seats Only",
                          style: TextStyles.body4
                              .colour(UiConstants.KGoldProPrimaryDark),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum ShimmerSizeEnum { mini, small, medium, large }

class GoldShimmerWidget extends StatelessWidget {
  const GoldShimmerWidget(
      {required this.size,
      super.key,
      this.primary,
      this.secondary,
      this.tertiary});

  final ShimmerSizeEnum size;
  final Color? primary, secondary, tertiary;

  double getPrimaryHeight() {
    switch (size) {
      case ShimmerSizeEnum.large:
        return 600;
      case ShimmerSizeEnum.medium:
        return 400;
      case ShimmerSizeEnum.small:
        return 100;
      case ShimmerSizeEnum.mini:
        return 50;
    }
  }

  double getPrimaryWidth() {
    switch (size) {
      case ShimmerSizeEnum.large:
        return 20;
      case ShimmerSizeEnum.medium:
        return 20;
      case ShimmerSizeEnum.small:
        return 10;
      case ShimmerSizeEnum.mini:
        return 5;
    }
  }

  double getPrimaryPosition() {
    return 0.0;
  }

  Color getPrimaryColor() {
    if (primary != null) return primary!;
    return UiConstants.KGoldProSecondary.withOpacity(0.1);
  }

  double getSecondaryHeight() {
    switch (size) {
      case ShimmerSizeEnum.large:
        return 600;
      case ShimmerSizeEnum.medium:
        return 400;
      case ShimmerSizeEnum.small:
        return 100;
      case ShimmerSizeEnum.mini:
        return 50;
    }
  }

  double getSecondaryWidth() {
    switch (size) {
      case ShimmerSizeEnum.large:
        return 20;
      case ShimmerSizeEnum.medium:
        return 20;
      case ShimmerSizeEnum.small:
        return 10;
      case ShimmerSizeEnum.mini:
        return 5;
    }
  }

  double getSecondaryPosition() {
    switch (size) {
      case ShimmerSizeEnum.large:
        return SizeConfig.screenWidth! / 2.5;
      case ShimmerSizeEnum.medium:
        return SizeConfig.screenWidth! / 2.5;
      case ShimmerSizeEnum.small:
        return SizeConfig.screenWidth! / 2.8;
      case ShimmerSizeEnum.mini:
        return SizeConfig.screenWidth! / 2.5;
    }
  }

  Color getSecondaryColor() {
    if (secondary != null) return secondary!;
    return UiConstants.KGoldProSecondary.withOpacity(0.1);
  }

  double getTertiaryHeight() {
    switch (size) {
      case ShimmerSizeEnum.large:
        return 600;
      case ShimmerSizeEnum.medium:
        return 400;
      case ShimmerSizeEnum.small:
        return 100;
      case ShimmerSizeEnum.mini:
        return 50;
    }
  }

  double getTertiaryWidth() {
    switch (size) {
      case ShimmerSizeEnum.large:
        return 5;
      case ShimmerSizeEnum.medium:
        return 5;
      case ShimmerSizeEnum.small:
        return 1;
      case ShimmerSizeEnum.mini:
        return 1;
    }
  }

  double getTertiaryPosition() {
    return size == ShimmerSizeEnum.small
        ? SizeConfig.screenWidth! / 3.5
        : SizeConfig.screenWidth! / 1.5;
  }

  Color getTertiaryColor() {
    return tertiary ??
        (size == ShimmerSizeEnum.small
            ? Colors.white24
            : UiConstants.KGoldProSecondary.withOpacity(0.1));
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(24),
        ),
        child: Stack(children: [
          Align(
            alignment: Alignment.center,
            child: Transform.scale(
              scale: size == ShimmerSizeEnum.small ? 2.5 : 2,
              child: Transform.rotate(
                angle: pi / 3,
                child: Container(
                  height: getPrimaryHeight(),
                  width: getPrimaryWidth(),
                  color: getPrimaryColor(),
                ),
              ),
            ),
          ),
          Positioned(
            right: getTertiaryPosition(),
            child: Transform.scale(
              scale: 2,
              child: Transform.rotate(
                angle: pi / 3,
                child: Container(
                  height: getTertiaryHeight(),
                  width: getTertiaryWidth(),
                  color: getTertiaryColor(),
                ),
              ),
            ),
          ),
          Positioned(
            right: getSecondaryPosition(),
            child: Transform.scale(
              scale: 2,
              child: Transform.rotate(
                angle: pi / 3,
                child: Container(
                  height: getSecondaryHeight(),
                  width: getSecondaryWidth(),
                  color: getSecondaryColor(),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
