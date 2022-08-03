import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/event_model.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/modals_sheets/event_instructions_modal.dart';
import 'package:felloapp/ui/pages/others/events/topSavers/all_participants.dart';
import 'package:felloapp/ui/pages/others/events/topSavers/top_saver_vm.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_home/tambola_home_view.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/game_card.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/pages/static/web_game_prize_view.dart';
import 'package:felloapp/ui/pages/static/winnings_container.dart';
import 'package:felloapp/ui/service_elements/winners_prizes/winners_marquee.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../service_elements/user_service/profile_image.dart';

// extension TruncateDoubles on double {
//   double truncateToDecimalPlaces(int fractionalDigits) =>
//       (this * pow(10, fractionalDigits)).truncate() / pow(10, fractionalDigits);
// }

//Method that sets the title according to the campaign type
String setTitle(String campaignType) {
  switch (campaignType) {
    case Constants.HS_DAILY_SAVER:
      return "Daily Challange";
      break;
    case Constants.HS_WEEKLY_SAVER:
      return "Weekly Challange";
      break;
    case Constants.HS_MONTHLY_SAVER:
      return "Monthly Challange";
      break;
    case Constants.BUG_BOUNTY:
      return "Bug bounty Challange";
      break;
    case Constants.NEW_FELLO_UI:
      return "Fello UI Challange";
      break;
  }
}

class TopSaverViewNew extends StatelessWidget {
  final String eventType;
  final bool isGameRedirected;
  TopSaverViewNew({this.eventType, this.isGameRedirected = false});
  @override
  Widget build(BuildContext context) {
    return BaseView<TopSaverViewModel>(
      onModelReady: (model) {
        model.init(eventType, isGameRedirected);
      },
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: UiConstants.accentColor,
          body: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              //The App Bar
              SliverAppBar(
                backgroundColor: Color(0xff495DB2), //TODO
                leading: Icon(Icons.arrow_back_ios),

                expandedHeight:
                    200, //The expandable height for the app bar //TODO
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      //Background image
                      Image.asset(
                        "assets/images/sliver_appbar_bg.png",
                        fit: BoxFit.cover,
                        width: double.maxFinite,
                        height: double.maxFinite,
                      ),
                      //The title and sub title
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/icons/coins.png",
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    setTitle(model.campaignType),
                                    style:
                                        TextStyles.title5.colour(Colors.white),
                                  ),
                                  Text(
                                    "Save a penny a day",
                                    style: TextStyles.title2
                                        .colour(Colors.white)
                                        .bold,
                                  ),
                                ],
                              )
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 50, 0, 15), //TODO
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                      color: UiConstants.kPrimaryColor,
                                      shape: BoxShape.circle),
                                ),
                                Text(
                                  "2K+ Participants",
                                  style: TextStyles.body3.colour(Colors.white),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),

              //The container for Savings, Highest Savings & Rank
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.all(25.0), //TODO
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "DAY 06",
                          style: TextStyles.title2.bold.colour(Colors.white),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            //YOUR SAVINGS
                            Container(
                              height: SizeConfig.screenHeight * 0.2,
                              padding: EdgeInsets.fromLTRB(20, 0, 40, 0), //TODO
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(SizeConfig.roundness12),
                                ),
                                color: Color(0xff3B3B3B), //TODO
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ProfileImageSE(
                                    radius: SizeConfig.screenWidth * 0.05,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Your Savings",
                                    style:
                                        TextStyles.body1.colour(Colors.white),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  //TODO
                                  Text(
                                    "₹ 500",
                                    style: TextStyles.title3.bold
                                        .colour(Colors.white),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                ],
                              ),
                            ),

                            //HIGHEST SAVING //RANK
                            Expanded(
                              child: Container(
                                height: SizeConfig.screenHeight * 0.2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(SizeConfig.roundness12),
                                  ),
                                  color: Colors.transparent, //TODO
                                ),
                                child: Column(
                                  children: [
                                    //HIGHEST SAVINGS
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(
                                            10, 0, 0, 5), //TODO

                                        padding: EdgeInsets.all(20.0), //TODO
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                SizeConfig.roundness16),
                                          ),
                                          color: Color(0xff3B3B3B), //TODO
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Highest\nSavings",
                                              style: TextStyles.body3
                                                  .colour(Colors.white),
                                            ),
                                            //TODO
                                            Flexible(
                                              child: Text(
                                                "₹ 1250",
                                                style: TextStyles.title5.bold
                                                    .colour(Colors.white),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    //RANK
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(
                                            10, 5, 0, 0), //TODO
                                        padding: EdgeInsets.all(20.0), //TODO
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                SizeConfig.roundness12),
                                          ),
                                          color: Color(0xff3B3B3B), //TODO
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                                child: Row(
                                              children: [
                                                Image.asset(
                                                  "assets/images/rank_ic.png",
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "Rank",
                                                  style: TextStyles.body3
                                                      .colour(Colors.white),
                                                ),
                                              ],
                                            )),

                                            //TODO
                                            Flexible(
                                              child: Text(
                                                "673",
                                                style: TextStyles.title5.bold
                                                    .colour(Colors.white),
                                                maxLines: 1,
                                                textAlign: TextAlign.end,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  margin: EdgeInsets.all(20.0),
                  height: 300,
                  width: 20,
                ),
              ),

              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  margin: EdgeInsets.all(20.0),
                  height: 300,
                  width: 20,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
