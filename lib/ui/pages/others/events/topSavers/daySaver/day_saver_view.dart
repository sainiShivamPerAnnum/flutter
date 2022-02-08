import 'package:felloapp/base_util.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/events/topSavers/daySaver/day_saver_vm.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/pages/static/winnings_container.dart';
import 'package:felloapp/ui/service_elements/user_service/profile_image.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

enum SaverType { MONTHLY, DAILY, WEEKLY }

class TopSaverView extends StatelessWidget {
  final SaverType type;
  TopSaverView({this.type = SaverType.DAILY});
  @override
  Widget build(BuildContext context) {
    return BaseView<TopSaverViewModel>(onModelReady: (model) {
      model.init(type);
    }, builder: (context, model, child) {
      return Scaffold(
        backgroundColor: UiConstants.primaryColor,
        body: HomeBackground(
          child: Column(
            children: [
              FelloAppBar(
                leading: FelloAppBarBackButton(),
                title: model.appbarTitle,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(SizeConfig.padding40),
                      topRight: Radius.circular(SizeConfig.padding40),
                    ),
                    color: Colors.white,
                  ),
                  width: SizeConfig.screenWidth,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Container(
                        width: SizeConfig.screenWidth,
                        height: SizeConfig.screenWidth * 0.4,
                        margin: EdgeInsets.symmetric(
                            horizontal: SizeConfig.pageHorizontalMargins,
                            vertical: SizeConfig.pageHorizontalMargins),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(SizeConfig.roundness32),
                          image: DecorationImage(
                            image: NetworkImage(
                                "https://image.freepik.com/free-vector/investors-earning-income_74855-2486.jpg?w=1380"),
                            fit: BoxFit.cover,
                          ),
                          color: UiConstants.tertiarySolid,
                        ),
                      ),
                      PastWinners(),
                      SizedBox(height: SizeConfig.padding24),
                      WinningsContainer(
                        shadow: false,
                        onTap: () {
                          BaseUtil.openModalBottomSheet(
                            addToScreenStack: true,
                            backgroundColor: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(SizeConfig.roundness32),
                              topRight: Radius.circular(SizeConfig.roundness32),
                            ),
                            hapticVibrate: true,
                            isBarrierDismissable: false,
                            content: Padding(
                              padding: EdgeInsets.all(
                                  SizeConfig.pageHorizontalMargins),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "How to participate",
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 24,
                                        ),
                                      ),
                                      Spacer(),
                                      CircleAvatar(
                                        backgroundColor: Colors.black,
                                        child: IconButton(
                                          onPressed: () {
                                            AppState.backButtonDispatcher
                                                .didPopRoute();
                                          },
                                          icon: Icon(
                                            Icons.close,
                                            size: SizeConfig.iconSize1,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Divider(
                                    height: 32,
                                    thickness: 2,
                                  ),
                                  // SizedBox(
                                  //   height: SizeConfig.screenHeight * 0.3,
                                  // )
                                ],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          child: Padding(
                            padding: EdgeInsets.all(SizeConfig.padding16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/icons/info.png",
                                ),
                                SizedBox(width: SizeConfig.screenWidth * 0.05),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "How to participate in\nthe event",
                                      style: TextStyles.body1
                                          .colour(Colors.white)
                                          .light,
                                    ),
                                    // Text(
                                    //   "2 gm of gold",
                                    //   style: TextStyles.title3
                                    //       .colour(Colors.white)
                                    //       .bold,
                                    // ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.padding16,
                      ),
                      SaverBoards(title: "Current Leaderboard"),
                      Container(
                        width: SizeConfig.screenWidth,
                        margin: EdgeInsets.symmetric(
                            horizontal: SizeConfig.pageHorizontalMargins),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(SizeConfig.roundness32),
                          color: UiConstants.scaffoldColor,
                        ),
                        child: Column(
                          children: [],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class SaverBoards extends StatelessWidget {
  final String title;
  SaverBoards({@required this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeConfig.roundness32),
        color: UiConstants.scaffoldColor,
      ),
      margin:
          EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
      padding: EdgeInsets.all(SizeConfig.padding16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                title,
                style: TextStyles.title5.bold.colour(Colors.black54),
              ),
              Spacer(),
              Row(
                children: [
                  Text(
                    "More ",
                    style:
                        TextStyles.body3.bold.colour(UiConstants.primaryColor),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: UiConstants.primaryColor,
                    size: SizeConfig.iconSize3,
                  )
                ],
              )
            ],
          ),
          SizedBox(height: SizeConfig.padding16),
          Column(
            children: List.generate(
              4,
              (index) => Container(
                margin: EdgeInsets.only(bottom: SizeConfig.padding12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(SizeConfig.padding12),
                  color: Colors.white,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: UiConstants.primaryColor,
                    child: Text(
                      index.toString(),
                      style: TextStyles.body2.colour(Colors.white),
                    ),
                  ),
                  title: Text("username"),
                  subtitle: Text("week description"),
                  trailing: Text("Win prize"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PastWinners extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeConfig.roundness32),
        color: UiConstants.scaffoldColor,
      ),
      height: SizeConfig.screenWidth * 0.8,
      margin:
          EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(SizeConfig.roundness32),
        child: Stack(
          children: [
            Opacity(
              opacity: 0.1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(SizeConfig.roundness32),
                child: Image.asset(
                  "assets/images/confetti.png",
                  width: SizeConfig.screenWidth,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.padding16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "  Past Winners",
                        style: TextStyles.title5.bold,
                      ),
                      Spacer(),
                    ],
                  ),
                  // SizedBox(height: SizeConfig.padding16),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      physics: BouncingScrollPhysics(),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            WinnerAvatar(position: 2),
                            WinnerAvatar(position: 1),
                            WinnerAvatar(position: 3),
                          ],
                        ),
                        Column(
                          children: List.generate(
                            4,
                            (index) => Container(
                              margin:
                                  EdgeInsets.only(bottom: SizeConfig.padding12),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(SizeConfig.padding12),
                                color: Colors.grey.withOpacity(0.3),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: UiConstants.primaryColor,
                                  child: Text(
                                    "${index + 4}",
                                    style:
                                        TextStyles.body2.colour(Colors.white),
                                  ),
                                ),
                                title: Text("username"),
                                subtitle: Text("week description"),
                                trailing: Text("Win prize"),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: SizeConfig.padding6,
                              bottom: SizeConfig.padding16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "View All",
                                style: TextStyles.body2.bold
                                    .colour(UiConstants.primaryColor)
                                    .underline,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )

                  // Column(
                  //   children: List.generate(
                  //     4,
                  //     (index) => Container(
                  //       margin: EdgeInsets.only(bottom: SizeConfig.padding12),
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(SizeConfig.padding12),
                  //         color: Colors.white,
                  //       ),
                  //       child: ListTile(
                  //         leading: CircleAvatar(
                  //           backgroundColor: UiConstants.primaryColor,
                  //           child: Text(
                  //             index.toString(),
                  //             style: TextStyles.body2.colour(Colors.white),
                  //           ),
                  //         ),
                  //         title: Text("username"),
                  //         subtitle: Text("week description"),
                  //         trailing: Text("Win prize"),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WinnerAvatar extends StatelessWidget {
  final int position;
  WinnerAvatar({@required this.position});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (position == 1)
          Lottie.asset("assets/lotties/crown.json",
              width: SizeConfig.screenWidth * 0.2),
        Container(
          width: position == 1
              ? SizeConfig.screenWidth * 0.31
              : SizeConfig.screenWidth * 0.2,
          height: position == 1
              ? SizeConfig.screenWidth * 0.33
              : SizeConfig.screenWidth * 0.22,
          child: Stack(
            children: [
              Container(
                width: position == 1
                    ? SizeConfig.screenWidth * 0.31
                    : SizeConfig.screenWidth * 0.2,
                height: position == 1
                    ? SizeConfig.screenWidth * 0.31
                    : SizeConfig.screenWidth * 0.2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      UiConstants.primaryColor,
                      Colors.white,
                    ],
                  ),
                ),
                padding: EdgeInsets.all(3),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(position == 1
                      ? SizeConfig.padding6
                      : SizeConfig.padding4),
                  child: ProfileImageSE(
                    radius: SizeConfig.screenWidth * 0.25,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: position == 1
                      ? SizeConfig.screenWidth * 0.096
                      : SizeConfig.screenWidth * 0.064,
                  width: position == 1
                      ? SizeConfig.screenWidth * 0.096
                      : SizeConfig.screenWidth * 0.064,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: UiConstants.primaryColor,
                    border: Border.all(
                        width: position == 1
                            ? SizeConfig.padding4
                            : SizeConfig.padding2,
                        color: Colors.white),
                  ),
                  child: Center(
                    child: Text(
                      position.toString(),
                      style: position == 1
                          ? TextStyles.body2.bold.colour(Colors.white)
                          : TextStyles.body4.bold.colour(Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: SizeConfig.padding8,
        ),
        Text(
          "username",
          style: TextStyles.body3,
        ),
        SizedBox(
          height: SizeConfig.padding16,
        ),
      ],
    );
  }
}
