import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/event_model.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/modals_sheets/event_instructions_modal.dart';
import 'package:felloapp/ui/pages/others/events/topSavers/all_participants.dart';
import 'package:felloapp/ui/pages/others/events/topSavers/top_saver_vm.dart';
import 'package:felloapp/ui/pages/others/games/cricket/cricket_home/cricket_home_view.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_home/tambola_home_view.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/pages/static/winnings_container.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class TopSaverView extends StatelessWidget {
  final EventModel event;
  TopSaverView({this.event});
  @override
  Widget build(BuildContext context) {
    return BaseView<TopSaverViewModel>(
      onModelReady: (model) {
        model.init(event);
      },
      builder: (context, model, child) {
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
                      color: UiConstants.scaffoldColor,
                    ),
                    width: SizeConfig.screenWidth,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(SizeConfig.padding40),
                        topRight: Radius.circular(SizeConfig.padding40),
                      ),
                      child: ListView(
                        physics: ClampingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        children: [
                          Thumbnail(event: event),
                          // if (model.currentParticipants != null)
                          EventLeaderboard(model: model),
                          InstructionsTab(event: event),
                          // if (model.pastWinners != null)
                          WinnersBoard(model: model),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class Thumbnail extends StatelessWidget {
  const Thumbnail({
    Key key,
    @required this.event,
  }) : super(key: key);

  final EventModel event;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        BaseUtil.openModalBottomSheet(
          addToScreenStack: true,
          backgroundColor: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(SizeConfig.roundness32),
            topRight: Radius.circular(SizeConfig.roundness32),
          ),
          isScrollControlled: true,
          hapticVibrate: true,
          isBarrierDismissable: false,
          content: EventInstructionsModal(instructions: event.instructions),
        );
      },
      child: Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenWidth * 0.4,
        margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SizeConfig.roundness32),
          image: DecorationImage(
            image: CachedNetworkImageProvider(event.image),
            fit: BoxFit.cover,
          ),
          color: UiConstants.tertiarySolid,
        ),
      ),
    );
  }
}

class InstructionsTab extends StatelessWidget {
  final EventModel event;
  InstructionsTab({@required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: SizeConfig.padding24),
      child: WinningsContainer(
        shadow: false,
        onTap: () {
          AppState.delegate.appState.setCurrentTabIndex = 0;
          AppState.backButtonDispatcher.didPopRoute();
        },
        child: Container(
          child: Padding(
            padding: EdgeInsets.all(SizeConfig.padding16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'images/svgs/gold.svg',
                  height: SizeConfig.padding54,
                ),
                SizedBox(width: SizeConfig.screenWidth * 0.05),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Join the Event",
                      style: TextStyles.title3.colour(Colors.white).bold,
                    ),
                    SizedBox(height: SizeConfig.padding4),
                    Text(
                      "Buy Digital Gold",
                      style: TextStyles.body2.colour(Colors.white).light,
                    ),
                  ],
                ),
                Lottie.asset("assets/lotties/golden-arrow.json"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WinnersBoard extends StatelessWidget {
  final TopSaverViewModel model;
  WinnersBoard({@required this.model});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(SizeConfig.padding32),
          topRight: Radius.circular(SizeConfig.padding32),
        ),
      ),
      // margin:
      //     EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
      padding:
          EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
      child: Column(
        children: [
          SizedBox(height: SizeConfig.pageHorizontalMargins),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                model.winnerTitle,
                style: TextStyles.title5.bold,
              ),
            ],
          ),
          SizedBox(height: SizeConfig.padding16),
          model.pastWinners != null
              ? (model.pastWinners.isNotEmpty
                  ? Column(
                      children: [
                        Column(
                          children: List.generate(
                            model.pastWinners.length,
                            (i) {
                              return Container(
                                margin: EdgeInsets.only(
                                    bottom: SizeConfig.padding16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig.padding12),
                                  color:
                                      UiConstants.primaryLight.withOpacity(0.2),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        SizeConfig.pageHorizontalMargins / 2,
                                    vertical: SizeConfig.padding16),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: UiConstants.primaryColor,
                                      child: Text(
                                        "${i + 1}",
                                        style: TextStyles.body2
                                            .colour(Colors.white),
                                      ),
                                    ),
                                    SizedBox(width: SizeConfig.padding12),
                                    Expanded(
                                      child: Text(
                                        model.pastWinners[i].username,
                                        style: TextStyles.body3,
                                      ),
                                    ),
                                    SizedBox(width: SizeConfig.padding12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        if (model.pastWinners[i]?.flc != null)
                                          PrizeChip(
                                            color: UiConstants.tertiarySolid,
                                            svg: Assets.tokens,
                                            text: "${model.pastWinners[i].flc}",
                                          ),
                                        if (model.pastWinners[i]?.flc != null)
                                          SizedBox(width: SizeConfig.padding16),
                                        if (model.pastWinners[i]?.amount !=
                                            null)
                                          PrizeChip(
                                            color: UiConstants.primaryColor,
                                            png: Assets.moneyIcon,
                                            text:
                                                "₹ ${model.pastWinners[i].amount}",
                                          )
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : Container(
                      width: SizeConfig.screenWidth,
                      margin: EdgeInsets.only(
                          top: SizeConfig.padding16,
                          bottom: SizeConfig.padding32),
                      child: Opacity(
                        opacity: 0.3,
                        child: NoRecordDisplayWidget(
                          asset: "images/leaderboard.png",
                          text: "Winners will be upadated soon",
                          topPadding: false,
                        ),
                      ),
                    ))
              : ListLoader(bottomPadding: true),
          SizedBox(height: SizeConfig.navBarHeight / 2),
        ],
      ),
    );
  }
}

class EventLeaderboard extends StatelessWidget {
  final TopSaverViewModel model;
  EventLeaderboard({this.model});

  bool isInteger(num value) => value is int || value == value.roundToDouble();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeConfig.roundness32),
        color: Colors.white,
      ),
      margin:
          EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(SizeConfig.roundness32),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.pageHorizontalMargins),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.padding16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Current Standings",
                    style: TextStyles.title5.bold,
                  ),
                  Spacer(),
                  Text(
                    "Your rank: ${model.userRank == 0 ? '-' : model.userRank.toString().padLeft(2, '0')} ",
                    style: TextStyles.body3,
                  )
                ],
              ),
              SizedBox(height: SizeConfig.padding12),
              model.currentParticipants != null
                  ? (model.currentParticipants.isNotEmpty
                      ? Column(
                          children: [
                            Column(
                              children: List.generate(
                                // model.currentParticipants.length,
                                model.currentParticipants.length > 4
                                    ? 4
                                    : model.currentParticipants.length,
                                (i) => Container(
                                  margin: EdgeInsets.only(
                                      bottom: SizeConfig.padding12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        SizeConfig.padding12),
                                    color: Colors.grey.withOpacity(0.05),
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal:
                                            SizeConfig.pageHorizontalMargins /
                                                2,
                                        vertical:
                                            SizeConfig.pageHorizontalMargins /
                                                4),
                                    leading: CircleAvatar(
                                      backgroundColor: UiConstants.primaryColor,
                                      child: Text(
                                        "${i + 1}",
                                        style: TextStyles.body2
                                            .colour(Colors.white),
                                      ),
                                    ),
                                    title: Text(
                                      model.currentParticipants[i].username,
                                      style: TextStyles.body3.bold
                                          .colour(Colors.black54),
                                    ),
                                    // subtitle: Text("This Week"),
                                    trailing: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                              text:
                                                  "${isInteger(model.currentParticipants[i].score) ? model.currentParticipants[i].score.toInt() : model.currentParticipants[i].score.toStringAsFixed(2)}",
                                              style: TextStyles.body2.bold.colour(UiConstants.primaryColor),
                                              children: [
                                                TextSpan(
                                                    text: " gm",
                                                    style: TextStyles
                                                        .body4.light
                                                        .colour(Colors.grey))
                                              ]),
                                        ),
                                        // Text(
                                        //   model.currentParticipants[i].score
                                        //       .toString(),
                                        //   style: TextStyles.body2.bold
                                        //       .colour(UiConstants.primaryColor),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            (model.currentParticipants.length > 5)
                                ? Padding(
                                    padding: EdgeInsets.only(
                                        bottom: SizeConfig.padding16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            AppState.delegate
                                                    .appState.currentAction =
                                                PageAction(
                                                    widget: AllParticipantsView(
                                                      participants: model
                                                          .currentParticipants,
                                                      type: model.saverType,
                                                    ),
                                                    page:
                                                        AllParticipantsViewPageConfig,
                                                    state: PageState.addWidget);
                                          },
                                          child: Text(
                                            "View All",
                                            style: TextStyles.body2.bold.colour(
                                                UiConstants.primaryColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : SizedBox(height: SizeConfig.padding8)
                          ],
                        )
                      : Container(
                          width: SizeConfig.screenWidth,
                          margin: EdgeInsets.only(
                              top: SizeConfig.padding16,
                              bottom: SizeConfig.padding32),
                          child: Opacity(
                            opacity: 0.3,
                            child: NoRecordDisplayWidget(
                              asset: "images/leaderboard.png",
                              text: "Leaderboard will be upadated soon",
                              topPadding: false,
                              bottomPadding: true,
                            ),
                          ),
                        ))
                  : ListLoader(
                      bottomPadding: true,
                    )
            ],
          ),
        ),
      ),
    );
  }
}
