import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_buy_screen/augmont_buy_view.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_buy_screen/augmont_buy_vm.dart';
import 'package:felloapp/ui/pages/static/gold_rate_card.dart';
import 'package:felloapp/ui/pages/static/winnings_container.dart';
import 'package:felloapp/ui/service_elements/paytm_service_elements/subscription_card.dart';
import 'package:felloapp/ui/service_elements/user_service/user_gold_quantity.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class Save extends StatelessWidget {
  final CustomLogger logger = locator<CustomLogger>();

  @override
  Widget build(BuildContext context) {
    return BaseView<AugmontGoldBuyViewModel>(
      onModelReady: (model) => model.init(null),
      builder: (ctx, model, child) {
        return Center(
          child: Text(
            "Save View in Construction",
            style: TextStyles.rajdhaniEB.body0.colour(Colors.white),
          ),
        );
      },
    );
  }
}

class FocusCouponClip extends StatelessWidget {
  final AugmontGoldBuyViewModel model;

  FocusCouponClip({this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(SizeConfig.roundness32),
            topRight: Radius.circular(SizeConfig.roundness32)),
        color: UiConstants.felloBlue,
      ),
      width: SizeConfig.screenWidth,
      height: SizeConfig.screenWidth * 0.24,
      alignment: Alignment.topCenter,
      child: Container(
        height: SizeConfig.screenWidth * 0.12,
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding20),
        child: Row(
          children: [
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  (model.focusCoupon.highlight != null)
                      ? model.focusCoupon.highlight
                      : model.focusCoupon.description,
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.start,
                  style: TextStyles.body2.colour(Colors.white),
                ),
              ),
            ),
            SizedBox(width: SizeConfig.padding12),
            InkWell(
              onTap: () => model.applyCoupon(model.focusCoupon.code),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Shimmer(
                  child: Container(
                    alignment: Alignment.center,
                    padding:
                        EdgeInsets.symmetric(horizontal: SizeConfig.padding12),
                    //width: SizeConfig.screenWidth * 0.171,
                    height: SizeConfig.screenWidth * 0.065,
                    // margin: EdgeInsets.only(left: SizeConfig.padding4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      "Apply",
                      style: TextStyles.body4.colour(Colors.white).bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GoldBalanceContainer extends StatelessWidget {
  final AugmontGoldBuyViewModel model;
  final bool showNavIcon;
  final bool hapticReq;
  GoldBalanceContainer(
      {this.model, this.showNavIcon = false, this.hapticReq = true});

  @override
  Widget build(BuildContext context) {
    return WinningsContainer(
      onTap: model != null ? model.navigateToGoldBalanceDetailsScreen : () {},
      hapticRequired: hapticReq,
      borderRadius: SizeConfig.roundness16,
      shadow: true,
      color: UiConstants.tertiarySolid,
      height: SizeConfig.screenWidth * 0.16,
      child: Container(
        width: SizeConfig.screenWidth,
        alignment: Alignment.center,
        padding: EdgeInsets.only(
          top: SizeConfig.padding8,
          bottom: SizeConfig.padding8,
          left: SizeConfig.padding24,
          right: showNavIcon ? SizeConfig.padding12 : SizeConfig.padding24,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                "My Gold Balance:",
                style: TextStyles.title5.colour(Colors.white.withOpacity(0.8)),
              ),
            ),
            Row(
              children: [
                UserGoldQuantitySE(
                  style: TextStyles.title2
                      .colour(Colors.white)
                      .weight(FontWeight.w900),
                ),
                if (showNavIcon)
                  Icon(
                    Icons.navigate_next_rounded,
                    color: Colors.white.withOpacity(0.5),
                    size: SizeConfig.padding40,
                  )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class Goldlinks extends StatelessWidget {
  AugmontGoldBuyViewModel model;

  Goldlinks({this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      height: SizeConfig.screenWidth * 0.24,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          SaveInfoTile(
            svg: 'images/svgs/gold.svg',
            title: "About digital Gold",
            onPressed: () {
              model.navigateToAboutGold();
            },
          ),
          SaveInfoTile(
            png: Assets.augmontShare,
            title: "Learn more about Augmont",
            onPressed: () {
              model.openAugmontWebUri();
            },
          ),
        ],
      ),
    );
  }
}

class SaveInfoTile extends StatelessWidget {
  final String svg, png;
  final String title;
  final Function onPressed;

  SaveInfoTile({this.svg, this.png, this.onPressed, this.title});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed ?? () {},
      splashColor: UiConstants.primaryColor,
      focusColor: UiConstants.primaryColor,
      highlightColor: UiConstants.primaryColor,
      hoverColor: UiConstants.primaryColor,
      child: Container(
        width: SizeConfig.screenWidth * 0.603,
        height: SizeConfig.screenWidth * 0.24,
        margin: EdgeInsets.only(
            left: SizeConfig.pageHorizontalMargins,
            right: SizeConfig.padding16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(SizeConfig.roundness32),
        ),
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.padding20,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              png != null
                  ? Image.asset(png ?? Assets.moneyIcon,
                      width: SizeConfig.padding40)
                  : SvgPicture.asset(
                      svg ?? Assets.tokens,
                      width: SizeConfig.padding40,
                    ),
              SizedBox(width: SizeConfig.padding16),
              Expanded(
                child: Text(
                  title ?? "title",
                  maxLines: 3,
                  style: TextStyles.title5.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
