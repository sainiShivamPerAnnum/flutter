import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/ui/pages/static/winnings_container.dart';
import 'package:felloapp/ui/service_elements/user_service/user_gold_quantity.dart';
import 'package:felloapp/ui/widgets/buttons/buy_gold_button/buyGoldBtn_view.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/fello_button.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/ui/widgets/buttons/sell_gold_button/sellGoldBtn_view.dart';
import 'package:felloapp/ui/widgets/mini_trans_card/mini_trans_card_view.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class Save extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return BaseView<SaveViewModel>(
      onModelReady: (model) {},
      builder: (ctx, model, child) {
        return ListView(
          children: [
            SizedBox(height: SizeConfig.padding80),
            BuyGoldBtn(),
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: SizeConfig.pageHorizontalMargins),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(SizeConfig.roundness32),
                color: Colors.white,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.padding20,
                  vertical: SizeConfig.padding24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(locale.saveGoldBalancelabel,
                            style: TextStyles.title5.light),
                        UserGoldQuantitySE(
                          style: TextStyles.title5.bold
                              .colour(UiConstants.tertiarySolid),
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: SizeConfig.padding24,
                        bottom: SizeConfig.padding16,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: FelloButton(
                                onPressed: () {
                                  model.checkRegistrationAndRedirect();
                                },
                                activeButtonUI: Container(
                                  width: SizeConfig.screenWidth * 0.367, //152
                                  height: SizeConfig.screenWidth * 0.12, //50
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: UiConstants.primaryColor),
                                  alignment: Alignment.center,
                                  child: Text(
                                    locale.saveBuyButton,
                                    style: TextStyles.title5.bold
                                        .colour(Colors.white),
                                  ),
                                ),
                                offlineButtonUI: Container(
                                  width: SizeConfig.screenWidth * 0.367, //152
                                  height: SizeConfig.screenWidth * 0.12, //50
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Colors.grey),
                                  alignment: Alignment.center,
                                  child: Text(
                                    locale.saveBuyButton,
                                    style: TextStyles.title5.bold
                                        .colour(Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: SizeConfig.padding20),
                          Expanded(
                              child: Center(
                            child: SellGoldBtn(
                              activeButtonUI: Container(
                                width: SizeConfig.screenWidth * 0.367,
                                height: SizeConfig.screenWidth * 0.12,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: UiConstants.tertiarySolid,
                                      width: 2),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  locale.saveSellButton,
                                  style: TextStyles.title5.bold,
                                ),
                              ),
                              loadingButtonUI: Container(
                                width: SizeConfig.screenWidth * 0.367,
                                height: SizeConfig.screenWidth * 0.12,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: UiConstants.tertiarySolid,
                                      width: 2),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                alignment: Alignment.center,
                                child: SpinKitThreeBounce(
                                  size: SizeConfig.title5,
                                  color: UiConstants.tertiarySolid,
                                ),
                              ),
                              disabledButtonUI: Container(
                                width: SizeConfig.screenWidth * 0.367,
                                height: SizeConfig.screenWidth * 0.12,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey, width: 2),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  locale.saveSellButton,
                                  style: TextStyles.title5.bold
                                      .colour(Colors.grey),
                                ),
                              ),
                            ),
                            // ),
                          )),
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: SizeConfig.padding8),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 0.1),
                          borderRadius:
                              BorderRadius.circular(SizeConfig.roundness12)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            Assets.augLogo,
                            height: SizeConfig.padding24,
                          ),
                          Image.asset(
                            Assets.sebiGraphic,
                            color: Colors.blue,
                            height: SizeConfig.padding20,
                          ),
                          TextButton.icon(
                            icon: Icon(
                              Icons.lock,
                              color: Colors.grey,
                              size: SizeConfig.body3,
                            ),
                            onPressed: () {},
                            label: Text(
                              locale.saveSecure,
                              style: TextStyles.body3.colour(Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: SizeConfig.screenWidth * 0.12,
                      margin: EdgeInsets.only(top: SizeConfig.padding16),
                      width: SizeConfig.screenWidth,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: UiConstants.tertiaryLight,
                          borderRadius:
                              BorderRadius.circular(SizeConfig.roundness12)),
                      child: Text(
                        locale.saveBaseline,
                        style:
                            TextStyles.body3.colour(UiConstants.tertiarySolid),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: SizeConfig.padding16),
            WinningsContainer(
              shadow: true,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        Assets.giftBoxOpen,
                        width: SizeConfig.screenWidth * 0.24,
                      ),
                      SizedBox(width: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            locale.saveWinningsLabel,
                            style: TextStyles.body1.colour(Colors.white).light,
                          ),
                          SizedBox(height: 8),
                          Text(
                            locale.saveWinningsValue(
                                model.getUnclaimedPrizeBalance()),
                            // "₹ ${model.getUnclaimedPrizeBalance()}",
                            style: TextStyles.title2.colour(Colors.white).bold,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: SizeConfig.padding32),
            Container(
              width: SizeConfig.screenWidth,
              height: SizeConfig.screenWidth * 0.24,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    3,
                    (index) {
                      return Container(
                        width: SizeConfig.screenWidth * 0.603,
                        height: SizeConfig.screenWidth * 0.24,
                        margin: EdgeInsets.only(
                            left: SizeConfig.pageHorizontalMargins,
                            right: SizeConfig.padding16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(SizeConfig.roundness32),
                        ),
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.padding20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("images/augmont-share.png",
                                  width: SizeConfig.padding40),
                              SizedBox(width: SizeConfig.padding16),
                              Expanded(
                                child: Text(
                                  "What is digital Gold",
                                  maxLines: 3,
                                  style: TextStyles.title5.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: SizeConfig.padding24),
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: SizeConfig.pageHorizontalMargins),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(SizeConfig.roundness32),
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
            SizedBox(height: kBottomNavigationBarHeight * 4),
          ],
        );
      },
    );
  }
}
