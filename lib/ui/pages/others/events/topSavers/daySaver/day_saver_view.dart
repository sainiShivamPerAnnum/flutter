import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/event_model.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/modals_sheets/event_instructions_modal.dart';
import 'package:felloapp/ui/pages/others/events/topSavers/daySaver/day_saver_vm.dart';
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
                    child: NestedScrollView(
                      headerSliverBuilder: (context, _) {
                        return [
                          SliverList(
                            delegate: SliverChildListDelegate(
                              [
                                Thumbnail(event: event),
                                PastWinners(model: model),
                                SizedBox(height: SizeConfig.padding24),
                                InstructionsTab(),
                              ],
                            ),
                          ),
                        ];
                      },
                      body: Column(
                        children: [
                          SizedBox(height: SizeConfig.padding24),
                          if (model.currentParticipants != null)
                            SaverBoards(
                              title: "Current Leaderboard",
                              model: model,
                            ),
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
          image: NetworkImage(event.image),
          fit: BoxFit.cover,
        ),
        color: UiConstants.tertiarySolid,
      ),
    );
  }
}

class InstructionsTab extends StatelessWidget {
  const InstructionsTab({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WinningsContainer(
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
          content: EventInstructionsModal(),
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
    );
  }
}

class SaverBoards extends StatelessWidget {
  final String title;
  final TopSaverViewModel model;
  SaverBoards({@required this.title, @required this.model});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(SizeConfig.padding32),
            topRight: Radius.circular(SizeConfig.padding32),
          ),
        ),
        margin:
            EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.pageHorizontalMargins / 2),
        child: Column(
          children: [
            SizedBox(height: SizeConfig.pageHorizontalMargins),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: TextStyles.title5.bold.colour(Colors.black54),
                ),
                // Spacer(),
                // Row(
                //   children: [
                //     Text(
                //       "More ",
                //       style: TextStyles.body3.bold
                //           .colour(UiConstants.primaryColor),
                //     ),
                //     Icon(
                //       Icons.arrow_forward_ios_rounded,
                //       color: UiConstants.primaryColor,
                //       size: SizeConfig.iconSize3,
                //     )
                //   ],
                // )
              ],
            ),
            SizedBox(height: SizeConfig.padding16),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: List.generate(
                  50,
                  (i) => Container(
                    margin: EdgeInsets.only(bottom: SizeConfig.padding12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(SizeConfig.padding12),
                      color: Colors.grey.withOpacity(0.1),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: SizeConfig.padding4,
                          horizontal: SizeConfig.pageHorizontalMargins / 2),
                      leading: CircleAvatar(
                        backgroundColor: UiConstants.primaryColor,
                        child: Text(
                          i.toString(),
                          style: TextStyles.body2.colour(Colors.white),
                        ),
                      ),
                      title: Text(
                        model.currentParticipants[0].username,
                        style: TextStyles.body3.bold.colour(Colors.black54),
                      ),
                      // subtitle: Text("This Week"),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            model.currentParticipants[0].score.toString(),
                            style: TextStyles.body2.bold
                                .colour(UiConstants.primaryColor),
                          ),
                          Text(
                            "transactions",
                            style: TextStyles.body4.light.colour(Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PastWinners extends StatelessWidget {
  final TopSaverViewModel model;
  PastWinners({this.model});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeConfig.roundness32),
        color: Colors.white,
        // boxShadow: [
        //   BoxShadow(
        //       blurRadius: 4,
        //       offset: Offset(0, 0),
        //       color: UiConstants.darkPrimaryColor.withOpacity(0.1),
        //       spreadRadius: 4)
        // ],
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
                            WinnerAvatar(position: 2, model: model),
                            WinnerAvatar(position: 1, model: model),
                            WinnerAvatar(position: 3, model: model),
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
                                color: Colors.grey.withOpacity(0.1),
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
                                title: Text(
                                  "username",
                                  style: TextStyles.body3.bold,
                                ),
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
                ],
              ),
            ),
          ],
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
  bool showDp = false;
  getDP() {
    widget.model.getWinnerDP().then((url) {
      if (url != null && mounted) {
        dpUrl = url;
        showDp = true;
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getDP();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.position == 1)
          Lottie.asset("assets/lotties/crown.json",
              width: SizeConfig.screenWidth * 0.2),
        Container(
          width: widget.position == 1
              ? SizeConfig.screenWidth * 0.31
              : SizeConfig.screenWidth * 0.2,
          height: widget.position == 1
              ? SizeConfig.screenWidth * 0.33
              : SizeConfig.screenWidth * 0.22,
          child: Stack(
            children: [
              Container(
                width: widget.position == 1
                    ? SizeConfig.screenWidth * 0.31
                    : SizeConfig.screenWidth * 0.2,
                height: widget.position == 1
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
                      image: DecorationImage(
                        image: AssetImage(
                          Assets.profilePic,
                        ),
                      )),
                  padding: EdgeInsets.all(widget.position == 1
                      ? SizeConfig.padding4
                      : SizeConfig.padding2),
                  child: CircleAvatar(
                    radius: SizeConfig.screenWidth * 0.25,
                    backgroundImage: showDp
                        ? CachedNetworkImageProvider(
                            dpUrl,
                          )
                        : AssetImage(
                            Assets.profilePic,
                          ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: widget.position == 1
                      ? SizeConfig.screenWidth * 0.096
                      : SizeConfig.screenWidth * 0.064,
                  width: widget.position == 1
                      ? SizeConfig.screenWidth * 0.096
                      : SizeConfig.screenWidth * 0.064,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: UiConstants.primaryColor,
                    border: Border.all(
                        width: widget.position == 1
                            ? SizeConfig.padding4
                            : SizeConfig.padding2,
                        color: Colors.white),
                  ),
                  child: Center(
                    child: Text(
                      widget.position.toString(),
                      style: widget.position == 1
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
