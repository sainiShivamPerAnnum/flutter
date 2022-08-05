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
import 'package:felloapp/ui/pages/others/events/topSavers/top_saver_view.dart';
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
import '../../../hometabs/play/play_components/play_info_section.dart';
import '../../../hometabs/play/play_components/titlesGames.dart';

// extension TruncateDoubles on double {
//   double truncateToDecimalPlaces(int fractionalDigits) =>
//       (this * pow(10, fractionalDigits)).truncate() / pow(10, fractionalDigits);
// }

class CampaignView extends StatelessWidget {
  final String eventType;
  final bool isGameRedirected;
  CampaignView({this.eventType, this.isGameRedirected = false});
  @override
  Widget build(BuildContext context) {
    return BaseView<TopSaverViewModel>(
      onModelReady: (model) {
        model.init(eventType, isGameRedirected);
      },
      builder: (context, model, child) {
        print(model.highestSavings);
        return Scaffold(
          backgroundColor: UiConstants.kBackgroundColor,
          body: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              //The App Bar
              SliverAppBar(
                backgroundColor: UiConstants.kSliverAppBarBackgroundColor,
                leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_back_ios)),
                expandedHeight: SizeConfig.sliverAppExpandableSize,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      //Background image
                      SvgPicture.asset(
                        Assets.visualGridAsset,
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
                              SvgPicture.asset(
                                Assets.coinsIconAsset,
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
                                    model.appbarTitle,
                                    style:
                                        TextStyles.body1.colour(Colors.white),
                                  ),
                                  Text(
                                    model.subTitle,
                                    style: TextStyles.title3
                                        .colour(Colors.white)
                                        .bold,
                                  ),
                                ],
                              )
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(
                                0,
                                SizeConfig.sliverAppBarPaddingLarge,
                                0,
                                SizeConfig.sliverAppBarPaddingSmall),
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
                  padding: EdgeInsets.all(SizeConfig.padding34),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Day ${model.weekDay.toString()}",
                          style: TextStyles.title3.bold.colour(Colors.white),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            //YOUR SAVINGS
                            Container(
                              height: SizeConfig.boxWidthLarge,
                              width: SizeConfig.boxWidthLarge,
                              padding: EdgeInsets.fromLTRB(SizeConfig.padding24,
                                  0, SizeConfig.padding34, 0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(SizeConfig.roundness12),
                                ),
                                color: UiConstants.kDarkBoxColor,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ProfileImageSE(
                                    radius: SizeConfig.profileDPSize,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Your Savings",
                                    style:
                                        TextStyles.body4.colour(Colors.white),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    model.userAmount.toString(),
                                    style: TextStyles.body1.bold
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
                                height: SizeConfig.boxWidthLarge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(SizeConfig.roundness12),
                                  ),
                                  color: Colors.transparent,
                                ),
                                child: Column(
                                  children: [
                                    //HIGHEST SAVINGS
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(
                                            SizeConfig.boxDividerMargins,
                                            0,
                                            0,
                                            (SizeConfig.boxDividerMargins) / 2),
                                        padding: EdgeInsets.all(
                                            SizeConfig.padding16),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                SizeConfig.roundness16),
                                          ),
                                          color: UiConstants.kDarkBoxColor,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Highest\nSavings",
                                              style: TextStyles.body4
                                                  .colour(Colors.white),
                                            ),
                                            Flexible(
                                              child: Text(
                                                "${model.highestSavings} gms",
                                                style: TextStyles.body2.bold
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
                                            SizeConfig.boxDividerMargins,
                                            (SizeConfig.boxDividerMargins) / 2,
                                            0,
                                            0),
                                        padding: EdgeInsets.all(
                                            SizeConfig.padding16),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                SizeConfig.roundness12),
                                          ),
                                          color:
                                              UiConstants.kDarkBoxColor, //TODO
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                                child: Row(
                                              children: [
                                                SvgPicture.asset(
                                                  Assets.rankIconAsset,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "Rank",
                                                  style: TextStyles.body4
                                                      .colour(Colors.white),
                                                ),
                                              ],
                                            )),
                                            Flexible(
                                              child: Text(
                                                model.userRank == 0
                                                    ? 'N/A'
                                                    : model.userRank
                                                        .toString()
                                                        .padLeft(2, '0'),
                                                style: TextStyles.body2.bold
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

              //The banner in the mid
              SliverToBoxAdapter(
                child: Container(
                  height: SizeConfig.bannerHeight,
                  width: double.infinity,
                  child: Image.asset(
                    Assets.bannerTrophy,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // //The banner in the mid
              // SliverToBoxAdapter(
              //   child: Container(
              //     padding: EdgeInsets.all(SizeConfig.padding34),
              //     height: SizeConfig.screenWidth * 0.61,
              //     width: double.infinity,
              //     decoration: BoxDecoration(
              //       color: Colors.transparent,
              //     ),
              //     child: Row(
              //       children: [
              //         //The texts
              //         Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             Text(
              //               "WIN",
              //               style: TextStyles.body1.colour(Colors.white),
              //             ),
              //             Text(
              //               "₹ 250",
              //               style: TextStyles.title0.bold
              //                   .colour(UiConstants.kWinnerPlayerPrimaryColor),
              //             ),
              //             Text(
              //               "Win amazing rewards\nin digital gold",
              //               style: TextStyles.body3
              //                   .colour(UiConstants.kTextFieldTextColor),
              //             ),
              //           ],
              //         ),
              //         Expanded(
              //           child: SvgPicture.asset(
              //             "assets/svg/trophy.svg",
              //             height: double.maxFinite,
              //           ),
              //         )
              //       ],
              //     ),
              //   ),
              // ),

              //The list of past winners
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.all(SizeConfig.padding34),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Past Winners",
                        style: TextStyles.title3.bold.colour(Colors.white),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      model.profileUrlList.isEmpty
                          ? ListLoader(bottomPadding: true)
                          : ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: model.pastWinners.length < 3
                                  ? model.pastWinners.length
                                  : 3,
                              scrollDirection: Axis.vertical,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: SizeConfig.padding20,
                                    horizontal: SizeConfig.padding2,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Text(
                                              '${index + 1}',
                                              style:
                                                  TextStyles.rajdhaniSB.body2,
                                            ),
                                            SizedBox(
                                              width: SizeConfig.padding20,
                                            ),
                                            ClipOval(
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    model.profileUrlList[index],
                                                width: SizeConfig.iconSize5,
                                                height: SizeConfig.iconSize5,
                                              ),
                                            ),
                                            SizedBox(
                                              width: SizeConfig.padding12,
                                            ),
                                            Expanded(
                                              child: Text(
                                                model.pastWinners[index]
                                                    .username,
                                                style: TextStyles
                                                    .sourceSans.body3
                                                    .setOpecity(0.8),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Text(
                                        "${model.pastWinners[index].score} gms"
                                            .toString(),
                                        style: TextStyles.rajdhaniM.body3,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                      TextButton(
                        onPressed: () {
                          //View all the past Winners
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'See All',
                              style: TextStyles.rajdhaniSB.body2,
                            ),
                            SizedBox(
                              width: SizeConfig.padding6,
                            ),
                            SvgPicture.asset(
                              Assets.chevronAsset,
                              width: SizeConfig.iconSize1,
                              height: SizeConfig.iconSize1,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: InfoComponent(
                  heading: "How to participate?",
                  assetList: [
                    Assets.singleStarAsset,
                    Assets.singleCoinAsset,
                    Assets.singleTmbolaTicket,
                  ],
                  titleList: [
                    'Choose a product for\nsaving.',
                    'Enter an amount you\nwant to save. ',
                    'Play games with tokens\nearned.'
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
