import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/games/cricket/cricket_home/cricket_home_vm.dart';
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
                    child: Column(
                      children: [
                        GameCard(
                          gameData: model.gameData,
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(SizeConfig.scaffoldMargin),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40),
                              ),
                              color: Colors.white,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 8),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () => model.viewpage(0),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 32, vertical: 16),
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
                                                  ? TextStyles.body2.bold
                                                      .colour(Colors.white)
                                                  : TextStyles.body3.colour(
                                                      UiConstants
                                                          .primaryColor)),
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      GestureDetector(
                                        onTap: () => model.viewpage(1),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 32, vertical: 16),
                                          decoration: BoxDecoration(
                                            color: model.currentPage == 1
                                                ? UiConstants.primaryColor
                                                : UiConstants.primaryColor
                                                    .withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                          child: Text("Leaderboard",
                                              style: model.currentPage == 1
                                                  ? TextStyles.body2.bold
                                                      .colour(Colors.white)
                                                  : TextStyles.body3.colour(
                                                      UiConstants
                                                          .primaryColor)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: PageView(
                                      controller: model.pageController,
                                      children: [
                                        ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: 10,
                                            itemBuilder: (ctx, i) {
                                              return ListTile(
                                                contentPadding:
                                                    EdgeInsets.all(8),
                                                leading: Stack(
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundImage:
                                                          NetworkImage(
                                                        "https://thumbor.forbes.com/thumbor/fit-in/416x416/filters%3Aformat%28jpg%29/https%3A%2F%2Fspecials-images.forbesimg.com%2Fimageserve%2F5b3a90cba7ea4353dd3f9804%2F0x0.jpg%3Fbackground%3D000000%26cropX1%3D186%26cropX2%3D3092%26cropY1%3D449%26cropY2%3D3354",
                                                      ),
                                                      radius:
                                                          kToolbarHeight * 0.4,
                                                    ),
                                                    CircleAvatar(
                                                      backgroundColor:
                                                          UiConstants
                                                              .primaryColor,
                                                      radius:
                                                          kToolbarHeight * 0.24,
                                                      child: Text(
                                                        "${i + 1}",
                                                        style: TextStyles.body4
                                                            .colour(
                                                                Colors.white),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                title: Text("Luke Hobbs",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        TextStyles.body1.bold),
                                                subtitle: Text(
                                                  "Tambola",
                                                  style: TextStyles.body3
                                                      .colour(UiConstants
                                                          .primaryColor),
                                                ),
                                                trailing: TextButton.icon(
                                                  icon: CircleAvatar(
                                                    radius: 10,
                                                    backgroundColor: Colors
                                                        .black
                                                        .withOpacity(0.2),
                                                    child: Icon(
                                                      Icons.airplane_ticket,
                                                      color: Colors.black,
                                                      size: 10,
                                                    ),
                                                  ),
                                                  label: Text("5 tickets",
                                                      style: TextStyles.body3
                                                          .colour(
                                                              Colors.black54)),
                                                  onPressed: () {},
                                                ),
                                              );
                                            }),
                                        ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: 10,
                                            itemBuilder: (ctx, i) {
                                              return ListTile(
                                                contentPadding:
                                                    EdgeInsets.all(8),
                                                leading: CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                    "https://www.giantfreakinrobot.com/wp-content/uploads/2020/12/robertdowney-edited-1-900x599.jpg",
                                                  ),
                                                  radius: kToolbarHeight * 0.4,
                                                ),
                                                title: Text("Anthony Stark",
                                                    style:
                                                        TextStyles.body1.bold),
                                                subtitle: Text(
                                                  "Tambola",
                                                  style: TextStyles.body3
                                                      .colour(UiConstants
                                                          .primaryColor),
                                                ),
                                                trailing: TextButton.icon(
                                                  icon: CircleAvatar(
                                                    radius: 10,
                                                    backgroundColor: Colors
                                                        .black
                                                        .withOpacity(0.2),
                                                    child: Icon(
                                                      Icons.airplane_ticket,
                                                      color: Colors.black,
                                                      size: 10,
                                                    ),
                                                  ),
                                                  label: Text("5 tickets",
                                                      style: TextStyles.body3
                                                          .colour(
                                                              Colors.black54)),
                                                  onPressed: () {},
                                                ),
                                              );
                                            }),
                                      ]),
                                )
                              ],
                            ),
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
