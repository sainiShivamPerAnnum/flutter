import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_buy_screen/augmont_buy_view.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_buy_screen/augmont_buy_vm.dart';
import 'package:felloapp/ui/pages/static/gold_rate_card.dart';
import 'package:felloapp/ui/pages/static/winnings_container.dart';
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

class Save extends StatelessWidget {
  final CustomLogger logger = locator<CustomLogger>();

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return BaseView<AugmontGoldBuyViewModel>(
      onModelReady: (model) => model.init(),
      builder: (ctx, model, child) {
        return Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: SizeConfig.screenWidth * 0.12),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  SizedBox(
                      height:
                          SizeConfig.screenWidth * 0.12 + SizeConfig.padding32),
                  Stack(
                    children: [
                      if (model.focusCoupon != null)
                        FocusCouponClip(model: model),
                      Column(
                        children: [
                          AnimatedContainer(
                            duration: Duration(milliseconds: 600),
                            curve: Curves.decelerate,
                            margin: EdgeInsets.symmetric(
                                horizontal: SizeConfig.pageHorizontalMargins),
                            width: SizeConfig.screenWidth / 2,
                            height: model.appliedCoupon == null &&
                                    model.showCoupons == true &&
                                    model.focusCoupon != null
                                ? SizeConfig.screenWidth * 0.12
                                : 0,
                          ),
                          AugmontBuyCard(model: model),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: SizeConfig.screenWidth,
                    margin: EdgeInsets.symmetric(
                        horizontal: SizeConfig.pageHorizontalMargins * 2,
                        vertical: SizeConfig.padding12),
                    child: CurrentPriceWidget(
                      fetchGoldRates: model.fetchGoldRates,
                      goldprice: model.goldRates != null
                          ? model.goldRates.goldBuyPrice
                          : 0.0,
                      isFetching: model.isGoldRateFetching,
                      mini: true,
                    ),
                  ),
                  SizedBox(height: SizeConfig.padding32),
                  Goldlinks(model: model),
                  SizedBox(height: SizeConfig.navBarHeight * 2),
                ],
              ),
            ),
            GoldBalanceContainer(model: model),
          ],
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
                  "Buy Gold worth ₹1000 and get 3% Gold free.",
                  overflow: TextOverflow.clip,
                  style: TextStyles.body2.colour(Colors.white),
                ),
              ),
            ),
            SizedBox(width: SizeConfig.padding6),
            InkWell(
              onTap: () => model.applyCoupon(model.focusCoupon),
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding12),
                //width: SizeConfig.screenWidth * 0.171,
                height: SizeConfig.screenWidth * 0.065,
                margin: EdgeInsets.only(left: SizeConfig.padding4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  "Apply",
                  style: TextStyles.body4.colour(Colors.white).bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class GoldBalanceContainer extends StatelessWidget {
  final AugmontGoldBuyViewModel model;
  GoldBalanceContainer({this.model});

  @override
  Widget build(BuildContext context) {
    return WinningsContainer(
      onTap: model != null ? model.navigateToGoldBalanceDetailsScreen : () {},
      shadow: true,
      color: UiConstants.tertiarySolid,
      child: Container(
        width: SizeConfig.screenWidth,
        alignment: Alignment.center,
        padding: EdgeInsets.all(SizeConfig.padding8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "My Gold Balance",
              style: TextStyles.title5.colour(Colors.white60),
            ),
            UserGoldQuantitySE(
              style: TextStyles.title2
                  .colour(Colors.white)
                  .weight(FontWeight.w900),
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
            png: "images/augmont-share.png",
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
