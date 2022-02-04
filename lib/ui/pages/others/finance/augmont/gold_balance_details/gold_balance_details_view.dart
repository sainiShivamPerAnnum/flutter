import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/static/FelloTile.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/service_elements/user_service/user_gold_quantity.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/ui/widgets/mini_trans_card/mini_trans_card_view.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GoldBalanceDetailsView extends StatelessWidget {
  const GoldBalanceDetailsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var locale = S.of(context);
    return Scaffold(
      backgroundColor: UiConstants.primaryColor,
      body: HomeBackground(
        child: Column(
          children: [
            FelloAppBar(
              leading: FelloAppBarBackButton(),
              title: "My Gold Info",
            ),
            Expanded(
              child: Container(
                width: SizeConfig.screenWidth,
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.pageHorizontalMargins),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(SizeConfig.padding40),
                    topRight: Radius.circular(SizeConfig.padding40),
                  ),
                  color: UiConstants.scaffoldColor,
                ),
                child: ListView(
                  padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.pageHorizontalMargins / 2),
                  children: [
                    Container(
                        margin: EdgeInsets.symmetric(
                            vertical: SizeConfig.pageHorizontalMargins / 2),
                        height: SizeConfig.screenWidth * 0.32,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(SizeConfig.roundness24),
                          color: UiConstants.tertiaryLight,
                          border: Border.all(
                              width: 0.5, color: UiConstants.tertiarySolid),
                        ),
                        padding:
                            EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "My Gold Balance",
                              style: TextStyles.body3,
                            ),
                            SizedBox(height: SizeConfig.padding4),
                            UserGoldQuantitySE(
                                style: TextStyles.title1.extraBold
                                    .colour(UiConstants.tertiarySolid)),
                          ],
                        )),
                    Container(
                      margin: EdgeInsets.symmetric(
                          vertical: SizeConfig.pageHorizontalMargins / 2),
                      padding: EdgeInsets.only(
                          right: SizeConfig.pageHorizontalMargins / 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(SizeConfig.roundness32),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: SizeConfig.padding20),
                          Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.pageHorizontalMargins),
                              child: Text(locale.saveHistory,
                                  style: TextStyles.title4.bold)),
                          MiniTransactionCard(),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          vertical: SizeConfig.pageHorizontalMargins / 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(SizeConfig.roundness32),
                      ),
                      padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Why Digital gold",
                              style: TextStyles.title4.bold),
                          SizedBox(height: SizeConfig.padding20),
                          FeatureTile(
                            leadingAsset: Assets.gold24K,
                            title: "24K",
                            subtitle: "Augmont provides 99.99% pure gold",
                          ),
                          SizedBox(height: SizeConfig.padding12),
                          FeatureTile(
                            leadingAsset: Assets.gold24K,
                            title: "99.99% pure",
                            subtitle: "Augmont provides 99.99% pure gold",
                          ),
                          SizedBox(height: SizeConfig.padding12),
                          FeatureTile(
                            leadingAsset: Assets.gold24K,
                            title: "100% secure",
                            subtitle: "Augmont provides 99.99% pure gold",
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: SizeConfig.padding24,
                          bottom: SizeConfig.padding12),
                      child: FelloButtonLg(
                        onPressed: () {
                          AppState.delegate.appState.currentAction = PageAction(
                              state: PageState.addPage,
                              page: AugmontGoldSellPageConfig);
                        },
                        child: Text(
                          "Sell Gold",
                          style: TextStyles.body3.colour(Colors.white).bold,
                        ),
                      ),
                    ),
                    // TextButton(
                    // onPressed: () {
                    //   AppState.delegate.appState.currentAction = PageAction(
                    //       state: PageState.addPage,
                    //       page: AugmontGoldSellPageConfig);
                    // },
                    //   child: Container(
                    // margin: EdgeInsets.only(
                    //     top: SizeConfig.padding24,
                    //     bottom: SizeConfig.padding12),
                    //     height: SizeConfig.screenWidth * 0.12,
                    //     width: SizeConfig.screenWidth,
                    //     decoration: BoxDecoration(
                    //       border: Border.all(
                    //           color: UiConstants.tertiarySolid, width: 2),
                    //       borderRadius:
                    //           BorderRadius.circular(SizeConfig.roundness12),
                    //     ),
                    //     alignment: Alignment.center,
                    //     child: Text(
                    //       "Sell Gold",
                    //       style: TextStyles.body1.bold.colour(Colors.black),
                    //     ),
                    //   ),
                    // ),
                    Text(
                      "The first rule of compounding: Never interrupt it unnecessarily.",
                      textAlign: TextAlign.center,
                      style: TextStyles.body3.colour(Colors.black54),
                    ),
                    SizedBox(height: SizeConfig.padding8),
                    Text(
                      "- Charlie Munger",
                      textAlign: TextAlign.center,
                      style: TextStyles.body3.bold.colour(Colors.black54),
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.05),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(Assets.augLogo,
                            color: Colors.grey, height: SizeConfig.padding24),
                        SizedBox(width: SizeConfig.padding20),
                        Image.asset(Assets.amfiGraphic,
                            color: Colors.grey, height: SizeConfig.padding24),
                        SizedBox(width: SizeConfig.padding20),
                        Image.asset(Assets.sebiGraphic,
                            color: Colors.grey, height: SizeConfig.padding20),
                      ],
                    ),
                    SizedBox(height: SizeConfig.pageHorizontalMargins)
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

class FeatureTile extends StatelessWidget {
  final String leadingAsset;
  final String title;
  final String subtitle;

  FeatureTile({
    this.leadingAsset,
    this.subtitle,
    this.title,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      //height: SizeConfig.screenWidth * 0.25,
      decoration: BoxDecoration(
        color: Color(0xffF6F9FF),
        borderRadius: BorderRadius.circular(SizeConfig.roundness16),
      ),
      padding: EdgeInsets.symmetric(
          vertical: SizeConfig.padding16, horizontal: SizeConfig.padding24),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Color(0xffE3F4F7),
            radius: SizeConfig.padding20,
            child: SvgPicture.asset(
              leadingAsset ?? "assets/vectors/icons/tickets.svg",
              height: SizeConfig.padding24,
              width: SizeConfig.padding24,
              color: UiConstants.primaryColor,
            ),
          ),
          SizedBox(
            width: SizeConfig.padding12,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  child: Text(
                    title ?? "title",
                    style: TextStyles.body3.bold,
                  ),
                ),
                SizedBox(height: SizeConfig.padding4),
                FittedBox(
                  child: Text(
                    subtitle ?? "subtitle",
                    style: TextStyles.body4.colour(Colors.grey),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
