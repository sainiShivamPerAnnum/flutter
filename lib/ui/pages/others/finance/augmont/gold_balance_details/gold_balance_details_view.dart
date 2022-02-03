import 'package:felloapp/ui/pages/static/FelloTile.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/ui/widgets/mini_trans_card/mini_trans_card_view.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

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
                      padding: EdgeInsets.all(SizeConfig.padding16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text("My Gold Balance: 0.0000 gm")],
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
                          Text("Benifits of Investing in Digital gold",
                              style: TextStyles.body1.bold),
                          SizedBox(height: SizeConfig.padding20),
                          FelloTile(
                            showTrailingIcon: false,
                            leadingAsset: Assets.gold24K,
                            title: "24K pure gold",
                            subtitle: "Augmont provides 99.99% pure gold",
                          ),
                          SizedBox(height: SizeConfig.padding12),
                          FelloTile(
                            showTrailingIcon: false,
                            leadingAsset: Assets.gold24K,
                            title: "24K pure gold",
                            subtitle: "Augmont provides 99.99% pure gold",
                          ),
                          SizedBox(height: SizeConfig.padding12),
                          FelloTile(
                            showTrailingIcon: false,
                            leadingAsset: Assets.gold24K,
                            title: "24K pure gold",
                            subtitle: "Augmont provides 99.99% pure gold",
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: SizeConfig.padding24,
                          bottom: SizeConfig.padding12),
                      height: SizeConfig.screenWidth * 0.12,
                      width: SizeConfig.screenWidth,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: UiConstants.tertiarySolid, width: 2),
                        borderRadius:
                            BorderRadius.circular(SizeConfig.roundness12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Sell Gold",
                        style: TextStyles.title5.bold
                            .colour(UiConstants.tertiarySolid),
                      ),
                    ),
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
