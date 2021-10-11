import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_view.dart';
import 'package:felloapp/ui/pages/root/root_view.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/pages/tabs/games/tambola/tambola_home/tambola_home_vm.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class TambolaHomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<TambolaHomeViewModel>(
      onModelReady: (model) {},
      builder: (ctx, model, child) {
        return Scaffold(
          backgroundColor: UiConstants.primaryColor,
          body: Stack(
            children: [
              HomeBackground(),
              FelloAppBar(
                leading: InkWell(
                  onDoubleTap: () =>
                      AppState.backButtonDispatcher.didPopRoute(),
                  child: CircleAvatar(
                    radius: kToolbarHeight * 0.5,
                    backgroundColor: Colors.white.withOpacity(0.4),
                    child: Icon(Icons.arrow_back_rounded,
                        color: UiConstants.primaryColor),
                  ),
                ),
                actions: [
                  FelloCurrency(),
                  SizedBox(width: 16),
                  NotificationButton(),
                ],
              ),
              SafeArea(
                child: Container(
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.screenHeight,
                  margin: EdgeInsets.only(top: kToolbarHeight * 1.6),
                  child: Column(
                    children: [
                      GameCard(
                        name: "Tambola",
                        tag: "tambola",
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
                                                    UiConstants.primaryColor)),
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
                                                    UiConstants.primaryColor)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: 10,
                                    itemBuilder: (ctx, i) {
                                      return ListTile(
                                        contentPadding: EdgeInsets.all(8),
                                        leading: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            "https://thumbor.forbes.com/thumbor/fit-in/416x416/filters%3Aformat%28jpg%29/https%3A%2F%2Fspecials-images.forbesimg.com%2Fimageserve%2F5b3a90cba7ea4353dd3f9804%2F0x0.jpg%3Fbackground%3D000000%26cropX1%3D186%26cropX2%3D3092%26cropY1%3D449%26cropY2%3D3354",
                                          ),
                                          radius: kToolbarHeight * 0.4,
                                        ),
                                        title: Text("Good Name",
                                            style: TextStyles.body1.bold),
                                        subtitle: Text(
                                          "Tambola",
                                          style: TextStyles.body3
                                              .colour(UiConstants.primaryColor),
                                        ),
                                        trailing: TextButton.icon(
                                          icon: CircleAvatar(
                                            radius: 10,
                                            backgroundColor:
                                                Colors.black.withOpacity(0.2),
                                            child: Icon(
                                              Icons.airplane_ticket,
                                              color: Colors.black,
                                              size: 10,
                                            ),
                                          ),
                                          label: Text("5 tickets",
                                              style: TextStyles.body3
                                                  .colour(Colors.black54)),
                                          onPressed: () {},
                                        ),
                                      );
                                    }),
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
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        new Container(
                          width: SizeConfig.screenWidth -
                              SizeConfig.blockSizeHorizontal * 10,
                          child: FelloButtonLg(
                            child: Text(
                              'PLAY',
                              style: TextStyles.body2.colour(Colors.white),
                            )
                            // : SpinKitThreeBounce(
                            //     color: UiConstants.spinnerColor2,
                            //     size: 18.0,
                            //   )
                            ,
                            onPressed: () {
                              AppState.delegate.appState.currentAction =
                                  PageAction(
                                      state: PageState.addPage,
                                      page: TGamePageConfig);
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                  // Row(
                  //   children: [
                  //     FelloButtonLg(
                  //       color: UiConstants.primaryColor,
                  //       child: Text(
                  //         "PLAY",
                  //         style: TextStyles.body1.colour(Colors.white).bold,
                  //       ),
                  //       onPressed: () {},
                  //     ),
                  //   ],
                  // ),
                  )
            ],
          ),
        );
      },
    );
  }
}
