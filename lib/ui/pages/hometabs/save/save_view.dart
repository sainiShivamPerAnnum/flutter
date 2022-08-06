import 'package:felloapp/base_util.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/modals_sheets/recharge_modal_sheet.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_buy_screen/augmont_buy_vm.dart';
import 'package:felloapp/ui/pages/static/winnings_container.dart';
import 'package:felloapp/ui/service_elements/auto_save_card/subscription_card_vm.dart';
import 'package:felloapp/ui/service_elements/user_service/user_gold_quantity.dart';
import 'package:felloapp/ui/widgets/coin_bar/coin_bar_view.dart';
import 'package:felloapp/ui/widgets/custom_card/custom_cards.dart';
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
    return BaseView<SaveViewModel>(
      onModelReady: (model) => model.init(),
      builder: (ctx, model, child) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(
              'Save',
              style: TextStyles.rajdhaniSB.title1,
            ),
            elevation: 0,
            backgroundColor: UiConstants.kSecondaryBackgroundColor,
            actions: [
              FelloCoinBar(
                svgAsset: Assets.aFelloToken,
              ),
              SizedBox(
                width: SizeConfig.padding20,
              )
            ],
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SaveNetWorthSection(),
                SizedBox(
                  height: SizeConfig.padding24,
                ),
                AutoSIPSection(),
                //Extended the EOS to avoid overshadowing by navbar
                SizedBox(
                  height: SizeConfig.screenHeight * 0.2,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SaveNetWorthSection extends StatelessWidget {
  const SaveNetWorthSection({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight * 0.45,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(SizeConfig.roundness16),
              bottomRight: Radius.circular(SizeConfig.roundness16)),
          color: UiConstants.kSecondaryBackgroundColor),
      child: Column(
        children: [
          SizedBox(
            height: SizeConfig.padding10,
          ),
          SaveCustomCard(
            title: 'Digital Gold',
            cardBgColor: UiConstants.kSaveDigitalGoldCardBg,
            cardAssetName: Assets.digitalGoldBar,
            onTap: () {
              return BaseUtil.openModalBottomSheet(
                addToScreenStack: true,
                enableDrag: false,
                hapticVibrate: true,
                isBarrierDismissable: true,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                content: RechargeModalSheet(),
              );
            },
          ),
          SaveCustomCard(
            title: 'Stable Fello',
            cardBgColor: UiConstants.kSaveStableFelloCardBg,
            cardAssetName: Assets.digitalGoldBar,
            onTap: () {
              return BaseUtil.openModalBottomSheet(
                addToScreenStack: true,
                enableDrag: false,
                hapticVibrate: true,
                isBarrierDismissable: true,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                content: RechargeModalSheet(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class AutoSIPSection extends StatelessWidget {
  const AutoSIPSection({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: SizeConfig.padding24),
          child: Text('Auto SIP', style: TextStyles.rajdhaniSB.title3),
        ),
        SizedBox(
          height: SizeConfig.padding10,
        ),
        AutoSIPCard(),
      ],
    );
  }
}

class AutoSIPCard extends StatelessWidget {
  const AutoSIPCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    S locale = S();
    return BaseView<SubscriptionCardViewModel>(
      builder: (ctx, model, builder) => Padding(
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding24),
        child: GestureDetector(
          onTap: () {
            model.navigateToAutoSave();
          },
          child: Container(
            height: SizeConfig.screenHeight * 0.2,
            width: SizeConfig.screenWidth,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: UiConstants.kSecondaryBackgroundColor),
            child: Padding(
              padding: EdgeInsets.all(SizeConfig.padding6),
              child: Row(
                children: [
                  SvgPicture.asset(Assets.autoSaveDefault),
                  SizedBox(
                    width: SizeConfig.padding10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      FittedBox(
                        fit: BoxFit.cover,
                        child: Container(
                          width: SizeConfig.screenWidth * 0.5,
                          child: RichText(
                              text: TextSpan(
                                  text: '${locale.getStartedWithSIP}\n',
                                  style: TextStyles.rajdhaniSB.body0,
                                  children: <TextSpan>[
                                TextSpan(
                                    text: locale.investSafelyInGoldText,
                                    style: TextStyles.sourceSans.body3
                                        .colour(UiConstants.kTextColor2))
                              ])),
                        ),
                      ),
                      SvgPicture.asset(Assets.saveChevronRight)
                    ],
                  ),
                ],
              ),
            ),
          ),
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

// ignore: must_be_immutable
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
