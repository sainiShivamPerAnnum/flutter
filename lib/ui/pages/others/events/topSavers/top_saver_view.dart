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
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/pages/static/winnings_container.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
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
                          if (model.currentParticipants != null)
                            EventLeaderboard(model: model),
                          InstructionsTab(event: event),
                          if (model.pastWinners != null)
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
    return Container(
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "How to participate in\nthe event",
                      style: TextStyles.body1.colour(Colors.white).light,
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
          model.pastWinners.isNotEmpty
              ? Column(
                  children: [
                    if (model.pastWinners.length >= 3)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          WinnerAvatar(position: 1, model: model),
                          WinnerAvatar(position: 0, model: model),
                          WinnerAvatar(position: 2, model: model),
                        ],
                      ),
                    Column(
                      children: List.generate(
                        model.pastWinners.length >= 3
                            ? model.pastWinners.length - 3
                            : model.pastWinners.length,
                        (i) {
                          int index = model.pastWinners.length >= 3 ? i + 3 : i;
                          return Container(
                            margin:
                                EdgeInsets.only(bottom: SizeConfig.padding12),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(SizeConfig.padding12),
                              color: Colors.grey.withOpacity(0.1),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: UiConstants.primaryColor,
                                child: Text(
                                  "${i + 1}",
                                  style: TextStyles.body2.colour(Colors.white),
                                ),
                              ),
                              title: Text(
                                model.pastWinners[index].username,
                                style: TextStyles.body3.bold,
                              ),
                              subtitle: Text(model.pastWinners[index].gameType),
                              trailing: Text(
                                  model.pastWinners[index].score.toString()),
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
                      top: SizeConfig.padding16, bottom: SizeConfig.padding32),
                  child: NoRecordDisplayWidget(
                    asset: "images/leaderboard.png",
                    text: "Winners will be upadated soon",
                    topPadding: false,
                  ),
                ),
          SizedBox(height: SizeConfig.navBarHeight / 2),
        ],
      ),
    );
  }
}

class EventLeaderboard extends StatelessWidget {
  final TopSaverViewModel model;
  EventLeaderboard({this.model});
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
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Current Leaderboard",
                    style: TextStyles.title5.bold,
                  ),
                  Spacer(),
                ],
              ),
              SizedBox(height: SizeConfig.padding12),
              model.currentParticipants.isNotEmpty
                  ? Column(
                      children: [
                        Column(
                          children: List.generate(
                            // model.currentParticipants.length,
                            model.currentParticipants.length > 5
                                ? 5
                                : model.currentParticipants.length,
                            (i) => Container(
                              margin:
                                  EdgeInsets.only(bottom: SizeConfig.padding12),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(SizeConfig.padding12),
                                color: Colors.grey.withOpacity(0.1),
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: SizeConfig.padding4,
                                    horizontal:
                                        SizeConfig.pageHorizontalMargins / 2),
                                leading: CircleAvatar(
                                  backgroundColor: UiConstants.primaryColor,
                                  child: Text(
                                    "${i + 1}",
                                    style:
                                        TextStyles.body2.colour(Colors.white),
                                  ),
                                ),
                                title: Text(
                                  model.currentParticipants[i].username,
                                  style: TextStyles.body3.bold
                                      .colour(Colors.black54),
                                ),
                                // subtitle: Text("This Week"),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      model.currentParticipants[i].score
                                          .toString(),
                                      style: TextStyles.body2.bold
                                          .colour(UiConstants.primaryColor),
                                    ),
                                    Text(
                                      "score",
                                      style: TextStyles.body4.light
                                          .colour(Colors.grey),
                                    ),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        AppState.delegate.appState.currentAction =
                                            PageAction(
                                                widget: AllParticipantsView(
                                                    participants: model
                                                        .currentParticipants),
                                                page:
                                                    AllParticipantsViewPageConfig,
                                                state: PageState.addWidget);
                                      },
                                      child: Text(
                                        "View All",
                                        style: TextStyles.body2.bold
                                            .colour(UiConstants.primaryColor)
                                            .underline,
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
                      child: NoRecordDisplayWidget(
                        asset: "images/leaderboard.png",
                        text: "Leaderboard will be upadated soon",
                        topPadding: false,
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}

class WinnerAvatar extends StatefulWidget {
  final int position;
  final TopSaverViewModel model;
  WinnerAvatar({@required this.position, this.model});

  @override
  State<WinnerAvatar> createState() => _WinnerAvatarState();
}

class _WinnerAvatarState extends State<WinnerAvatar> {
  String dpUrl;
  getDP() {
    widget.model.getWinnerDP(widget.position).then((url) {
      if (url != null && mounted) {
        setState(() {
          dpUrl = url;
        });
      }
    });
  }

  setDefaultUserDP() {
    if (mounted) {
      setState(() {
        dpUrl = null;
      });
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getDP();
    });
    super.initState();
  }

  Color getColor() {
    if (widget.position == 0)
      return Color(0xffFFC107);
    else if (widget.position == 1)
      return Color(0xff861139);
    else
      return UiConstants.darkPrimaryColor;
  }

  String getImage() {
    if (widget.position == 0)
      return "assets/images/crown.png";
    else if (widget.position == 1)
      return "assets/images/give-love.png";
    else
      return "assets/images/clapping.png";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.position == 0)
          Image.asset(getImage(),
              width: widget.position == 0
                  ? SizeConfig.screenWidth * 0.1
                  : SizeConfig.screenWidth * 0.07),
        Container(
          width: widget.position == 0
              ? SizeConfig.screenWidth * 0.31
              : SizeConfig.screenWidth * 0.2,
          height: widget.position == 0
              ? SizeConfig.screenWidth * 0.33
              : SizeConfig.screenWidth * 0.22,
          child: Stack(
            children: [
              Container(
                width: widget.position == 0
                    ? SizeConfig.screenWidth * 0.31
                    : SizeConfig.screenWidth * 0.2,
                height: widget.position == 0
                    ? SizeConfig.screenWidth * 0.31
                    : SizeConfig.screenWidth * 0.2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      getColor(),
                      Colors.white,
                    ],
                  ),
                ),
                padding: EdgeInsets.all(3),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(
                          Assets.profilePic,
                        ),
                      )),
                  padding: EdgeInsets.all(widget.position == 0
                      ? SizeConfig.padding4
                      : SizeConfig.padding2),
                  child: CircleAvatar(
                    radius: SizeConfig.screenWidth * 0.25,
                    backgroundImage: dpUrl != null
                        ? CachedNetworkImageProvider(dpUrl,
                            errorListener: setDefaultUserDP)
                        : AssetImage(
                            Assets.profilePic,
                          ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: widget.position == 0
                      ? SizeConfig.screenWidth * 0.096
                      : SizeConfig.screenWidth * 0.064,
                  width: widget.position == 0
                      ? SizeConfig.screenWidth * 0.096
                      : SizeConfig.screenWidth * 0.064,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: getColor(),
                    border: Border.all(
                        width: widget.position == 0
                            ? SizeConfig.padding4
                            : SizeConfig.padding2,
                        color: Colors.white),
                  ),
                  child: Center(
                    child: Text(
                      "${widget.position + 1}",
                      style: widget.position == 0
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
          widget.model?.pastWinners[widget.position]?.username ?? "username",
          style: TextStyles.body3,
        ),
        SizedBox(height: SizeConfig.padding4),
        Text(
          widget.model?.pastWinners[widget.position]?.score?.toString() ??
              "000",
          style: TextStyles.body1.bold.colour(UiConstants.primaryColor),
        ),
        SizedBox(
          height: SizeConfig.padding16,
        ),
      ],
    );
  }
}
