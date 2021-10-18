import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/games/cricket/cricket_home/cricket_home_vm.dart';
import 'package:felloapp/ui/pages/static/FelloTile.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/game_card.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/ui/widgets/coin_bar/coin_bar_view.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class CricketHomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<CricketHomeViewModel>(
      builder: (ctx, model, child) {
        return Scaffold(
          backgroundColor: UiConstants.primaryColor,
          body: HomeBackground(
            child: Stack(
              children: [
                FelloAppBar(
                  leading: FelloAppBarBackButton(),
                  actions: [
                    FelloCoinBar(),
                    SizedBox(width: 16),
                    NotificationButton(),
                  ],
                ),
                WhiteBackground(
                  color: Color(0xffF1F6FF),
                  height: kToolbarHeight * 3.6,
                ),
                SafeArea(
                  child: Container(
                    width: SizeConfig.screenWidth,
                    height: SizeConfig.screenHeight,
                    margin: EdgeInsets.only(top: kToolbarHeight),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        GameCard(
                          gameData: model.gameData,
                        ),
                        Container(
                          height:
                              SizeConfig.screenHeight - kToolbarHeight * 3.6,
                          padding:
                              EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(SizeConfig.roundness40),
                              topRight: Radius.circular(SizeConfig.roundness40),
                            ),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () => model.viewpage(0),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: SizeConfig.padding24,
                                            vertical: SizeConfig.padding12),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: model.currentPage == 0
                                              ? UiConstants.primaryColor
                                              : UiConstants.primaryColor
                                                  .withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        child: Text("Prizes",
                                            style: model.currentPage == 0
                                                ? TextStyles.body3.bold
                                                    .colour(Colors.white)
                                                : TextStyles.body3.colour(
                                                    UiConstants.primaryColor)),
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    GestureDetector(
                                      onTap: () => model.viewpage(1),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: SizeConfig.padding24,
                                            vertical: SizeConfig.padding12),
                                        decoration: BoxDecoration(
                                          color: model.currentPage == 1
                                              ? UiConstants.primaryColor
                                              : UiConstants.primaryColor
                                                  .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        child: Text("Leaderboard",
                                            style: model.currentPage == 1
                                                ? TextStyles.body3.bold
                                                    .colour(Colors.white)
                                                : TextStyles.body3.colour(
                                                    UiConstants.primaryColor)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: PageView(
                                    physics: NeverScrollableScrollPhysics(),
                                    controller: model.pageController,
                                    children: [
                                      ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: 10,
                                          itemBuilder: (ctx, i) {
                                            return FelloBriefTile(
                                              leadingIcon: Icons.first_page,
                                              title: "First Prize",
                                              trailingIcon: Icons.next_plan,
                                            );
                                          }),
                                      ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: 10,
                                          itemBuilder: (ctx, i) {
                                            return Container(
                                              width: SizeConfig.screenWidth,
                                              padding: EdgeInsets.all(
                                                  SizeConfig.padding12),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width:
                                                        SizeConfig.screenWidth *
                                                            0.154,
                                                    height: SizeConfig
                                                            .tileAvatarRadius *
                                                        2,
                                                    child: Stack(
                                                      children: [
                                                        Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: CircleAvatar(
                                                            backgroundImage:
                                                                NetworkImage(
                                                              "https://thumbor.forbes.com/thumbor/fit-in/416x416/filters%3Aformat%28jpg%29/https%3A%2F%2Fspecials-images.forbesimg.com%2Fimageserve%2F5b3a90cba7ea4353dd3f9804%2F0x0.jpg%3Fbackground%3D000000%26cropX1%3D186%26cropX2%3D3092%26cropY1%3D449%26cropY2%3D3354",
                                                            ),
                                                            radius: SizeConfig
                                                                .tileAvatarRadius,
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: CircleAvatar(
                                                            backgroundColor:
                                                                UiConstants
                                                                    .primaryColor,
                                                            radius: SizeConfig
                                                                .padding16,
                                                            child: Text(
                                                              "${i + 1}",
                                                              style: TextStyles
                                                                  .body4
                                                                  .colour(Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      width:
                                                          SizeConfig.padding12),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text("Mckinney",
                                                            style: TextStyles
                                                                .body3),
                                                        SizedBox(
                                                            height: SizeConfig
                                                                .padding4),
                                                        Text(
                                                          "Tambola",
                                                          style: TextStyles
                                                              .body4
                                                              .colour(UiConstants
                                                                  .primaryColor),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  TextButton.icon(
                                                      icon: CircleAvatar(
                                                        radius: SizeConfig
                                                                .screenWidth *
                                                            0.029,
                                                        backgroundColor:
                                                            UiConstants
                                                                .primaryLight,
                                                        child: Image.asset(
                                                          "assets/images/icons/money.png",
                                                          height: SizeConfig
                                                              .iconSize3,
                                                        ),
                                                      ),
                                                      label: Text("Rs 10K",
                                                          style: TextStyles
                                                              .body3
                                                              .colour(Colors
                                                                  .black54)),
                                                      onPressed: () {}),
                                                ],
                                              ),
                                            );
                                          }),
                                    ]),
                              ),
                              SizedBox(height: SizeConfig.padding64)
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: SizeConfig.screenWidth,
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.scaffoldMargin, vertical: 16),
                    child: FelloButtonLg(
                      child: model.state == ViewState.Busy
                          ? CircularProgressIndicator()
                          : Text(
                              'PLAY',
                              style: TextStyles.body2.colour(Colors.white),
                            )
                      // : SpinKitThreeBounce(
                      //     color: UiConstants.spinnerColor2,
                      //     size: 18.0,
                      //   )
                      ,
                      onPressed: () async {
                        if (await model.openWebView())
                          model.startGame();
                        else
                          BaseUtil.showNegativeAlert(
                              "Something went wrong", model.message);
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
