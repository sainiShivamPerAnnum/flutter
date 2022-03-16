import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/modals_sheets/custom_subscription_modal.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_buy_screen/augmont_buy_view.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_buy_screen/augmont_buy_vm.dart';
import 'package:felloapp/ui/pages/static/gold_rate_card.dart';
import 'package:felloapp/ui/pages/static/winnings_container.dart';
import 'package:felloapp/ui/service_elements/user_service/user_gold_quantity.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class Save extends StatelessWidget {
  final CustomLogger logger = locator<CustomLogger>();

  @override
  Widget build(BuildContext context) {
    print(
        "Bottom padding: ${WidgetsBinding.instance.window.viewInsets.bottom}");
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
                            duration: Duration(milliseconds: 300),
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
                    decoration: BoxDecoration(
                      color: UiConstants.primaryLight.withOpacity(0.3),
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness12),
                    ),
                    alignment: Alignment.center,
                    width: SizeConfig.screenWidth,
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.pageHorizontalMargins / 2,
                      vertical: SizeConfig.padding16,
                    ),
                    margin: EdgeInsets.all(
                      SizeConfig.pageHorizontalMargins,
                    ),
                    child: CurrentPriceWidget(
                      fetchGoldRates: model.fetchGoldRates,
                      goldprice: model.goldRates != null
                          ? model.goldRates.goldBuyPrice
                          : 0.0,
                      isFetching: model.isGoldRateFetching,
                      mini: true,
                    ),
                  ),
                  // SizedBox(height: SizeConfig.padding32),
                  // // Goldlinks(model: model),
                  // TextButton(
                  //   onPressed: () {
                  //     model.showInstantTestGT();
                  //   },
                  //   child: Text("Show instant gt"),
                  // ),
                  // TextButton(
                  //   onPressed: () {
                  //     model.showTxnSuccessScreen(null, null);
                  //   },
                  //   child: Text("Show txn complete UI"),
                  // ),
                  // TextButton(
                  //   onPressed: () {
                  //     model.showTransactionPendingDialog();
                  //   },
                  //   child: Text("Show txn waiting dialog"),
                  // ),

                  // TextButton(
                  //   onPressed: () {
                  //     AppState.screenStack.add(ScreenItem.dialog);
                  //     Navigator.push(context,
                  //         MaterialPageRoute(builder: (ctx) => PoolView()));
                  //   },
                  //   child: Text("Show pool game"),
                  // ),

                  AutoPayCard(),
                  SizedBox(height: SizeConfig.padding32),
                  // Goldlinks(model: model),
                  //CustomSubscriptionContainer(),
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
                  model.focusCoupon.description,
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
              style: TextStyles.title5.colour(Colors.white.withOpacity(0.8)),
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

class AutoPayCard extends StatelessWidget {
  const AutoPayCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      margin:
          EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
      decoration: BoxDecoration(
        // color: Color(0xfff3c5c5),
        color: Color(0xff6b7AA1),

        //color: Colors.white,
        borderRadius: BorderRadius.circular(SizeConfig.roundness24),
      ),
      padding: EdgeInsets.only(left: SizeConfig.pageHorizontalMargins),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: SizeConfig.padding16,
            child: Image.asset(
              "assets/images/autopay.png",
              width: SizeConfig.screenWidth / 2.4,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: SizeConfig.pageHorizontalMargins * 2),
                    FittedBox(
                      child: Text(
                        "Savings made easy with",
                        style: TextStyles.body2.light.colour(Colors.white),
                      ),
                    ),
                    SizedBox(height: SizeConfig.padding2),
                    Text(
                      "UPI AutoPay",
                      style: TextStyles.title3.bold.colour(Colors.white),
                    ),
                    SizedBox(height: SizeConfig.padding16),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              BaseUtil.openModalBottomSheet(
                                addToScreenStack: true,
                                backgroundColor: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft:
                                      Radius.circular(SizeConfig.roundness32),
                                  topRight:
                                      Radius.circular(SizeConfig.roundness32),
                                ),
                                content: CustomSubscriptionModal(),
                                hapticVibrate: true,
                                isBarrierDismissable: false,
                                isScrollControlled: true,
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: SizeConfig.padding8),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color(0xff8f97b3),
                                borderRadius: BorderRadius.circular(100),
                                boxShadow: [
                                  BoxShadow(
                                    color: UiConstants.primaryColor
                                        .withOpacity(0.2),
                                    offset: Offset(0, 2),
                                    blurRadius: 5,
                                    spreadRadius: 5,
                                  )
                                ],
                              ),
                              child: Text(
                                "Set Up",
                                style: TextStyles.body2.colour(Colors.white),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: SizeConfig.padding8),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              AppState.delegate.appState.currentAction =
                                  PageAction(
                                      state: PageState.addPage,
                                      page: AutoPayDetailsViewPageConfig);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: SizeConfig.padding8),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                  width: 0.5,
                                  color: Colors.white,
                                ),
                              ),
                              child: Text(
                                "Details",
                                style: TextStyles.body2.colour(Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: SizeConfig.pageHorizontalMargins * 2)
                  ],
                ),
              ),
              Expanded(
                child: Container(),
              )
            ],
          ),
        ],
      ),
    );
  }
}
