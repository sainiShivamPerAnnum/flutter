import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_home/tambola_existing_user_page.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_home/tambola_home_view.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_home/tambola_home_vm.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';

import 'package:felloapp/ui/widgets/appbar/appbar.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';

import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:felloapp/util/url_type_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';

class TambolaWrapper extends StatelessWidget {
  const TambolaWrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<TambolaHomeViewModel>(
      onModelReady: (model) {
        model.init();
      },
      builder: (ctx, model, child) {
        if (model.state == ViewState.Busy) {
          return Scaffold(
            body: Center(child: FullScreenLoader()),
            appBar: FAppBar(
              showAvatar: false,
              showCoinBar: false,
              showHelpButton: false,
              title: "Tambola",
              backgroundColor: UiConstants.kArowButtonBackgroundColor,
            ),
            backgroundColor: UiConstants.kBackgroundColor,
          );
        }
        return RefreshIndicator(
            color: UiConstants.primaryColor,
            backgroundColor: Colors.black,
            onRefresh: model.refreshTambolaTickets,
            child: Scaffold(
              body: model.activeTambolaCardCount > 0
                  ? TambolaExistingUserPage(
                      model: model,
                    )
                  : TambolaNewUserPage(
                      model: model,
                    ),
            ));
      },
    );
  }
}

class TambolaNewUserPage extends StatelessWidget {
  const TambolaNewUserPage({Key key, this.model}) : super(key: key);
  final TambolaHomeViewModel model;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FAppBar(
        showAvatar: false,
        showCoinBar: false,
        showHelpButton: false,
        title: "Tambola",
        backgroundColor: UiConstants.kArowButtonBackgroundColor,
      ),
      backgroundColor: UiConstants.kBackgroundColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                TambolaHeader(
                  model: model,
                ),
                SizedBox(
                  height: 14,
                ),
                Text(
                  'Get your tickets and match numbers\neveryday at 6 PM to see if you win 1 Crore',
                  textAlign: TextAlign.center,
                  style: TextStyles.rajdhaniSB.body1
                      .colour(Color(0xffD9D9D9).withOpacity(0.41)),
                ),
                SizedBox(
                  height: 14,
                ),
                TambolaTicketInfo(),
                SizedBox(
                  height: 14,
                ),
                TambolaPrize(
                  model: model,
                ),
                TambolaLeaderBoard(
                  model: model,
                ),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.17,
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding:
                  EdgeInsets.only(top: 14, bottom: 24, left: 32, right: 32),
              width: double.infinity,
              color: Colors.black.withOpacity(0.6),
              height: SizeConfig.screenHeight * 0.17,
              child: Column(
                children: [
                  Text(
                    model.game?.highLight ?? '',
                    style: TextStyles.sourceSans,
                  ),
                  Spacer(),
                  FelloButtonLg(
                    child: Text(
                      'Get your first ticket',
                      style: TextStyles.rajdhaniB.body1,
                    ),
                    onPressed: () {
                      locator<AnalyticsService>().track(
                          eventName: AnalyticsEvents.tambolaSaveTapped,
                          properties: AnalyticsProperties
                              .getDefaultPropertiesMap(extraValuesMap: {
                            "Time left for draw Tambola (mins)":
                                AnalyticsProperties.getTimeLeftForTambolaDraw(),
                            "Tambola Tickets Owned":
                                AnalyticsProperties.getTabolaTicketCount(),
                            "Number of Tickets": 1,
                            "Amount": model.ticketSavedAmount,
                          }));
                      model.updateTicketSavedAmount(1);
                      BaseUtil().openDepositOptionsModalSheet(
                          amount: model.ticketSavedAmount);
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TambolaHeader extends StatelessWidget {
  const TambolaHeader({Key key, this.model}) : super(key: key);
  final TambolaHomeViewModel model;

  UrlType get urlType => UrlTypeHelper.getType(
      'https://dev.w3.org/SVG/tools/svgweb/samples/svg-files/410.svg');

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight * 0.4,
      width: double.infinity,
      margin:
          EdgeInsets.symmetric(horizontal: SizeConfig.padding24, vertical: 12),
      decoration: BoxDecoration(
          color: UiConstants.kSnackBarPositiveContentColor,
          borderRadius: BorderRadius.circular(SizeConfig.roundness12)),
      child: Builder(
        builder: (_) {
          switch (urlType) {
            case UrlType.IMAGE:
              return SvgPicture.network(
                  'https://dev.w3.org/SVG/tools/svgweb/samples/svg-files/410.svg');
            case UrlType.VIDEO:
              return TambolaVideoPlayer(
                  link:
                      'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4');

            default:
              return SizedBox();
          }
        },
      ),
    );
  }
}

class TambolaTicketInfo extends StatelessWidget {
  const TambolaTicketInfo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight * 0.12,
      width: SizeConfig.screenWidth * 0.80,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xff627F8E)),
        borderRadius: BorderRadius.circular(SizeConfig.roundness12),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          tileMode: TileMode.mirror,
          end: Alignment.centerRight,
          stops: [0, 0.5, 0.5, 1],
          colors: [
            Color(
              0xff627F8E,
            ).withOpacity(0.2),
            Color(
              0xff627F8E,
            ).withOpacity(0.2),
            Colors.transparent,
            Colors.transparent
          ],
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: SizeConfig.screenWidth * 0.37,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "₹ " +
                      (BaseRemoteConfig.remoteConfig
                              .getString(BaseRemoteConfig.TAMBOLACOST)
                              .isEmpty
                          ? '500'
                          : BaseRemoteConfig.remoteConfig
                              .getString(BaseRemoteConfig.TAMBOLACOST)),
                  style: TextStyles.sourceSansB.title3,
                ),
                Text(
                  'invested',
                  style: TextStyles.sourceSansSB.body3,
                )
              ],
            ),
          ),
          Text('=', style: TextStyles.sourceSansB.title1),
          SizedBox(
            width: SizeConfig.screenWidth * 0.37,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('1 Ticket', style: TextStyles.sourceSansB.title3),
                Text(
                  'every week for lifetime',
                  style: TextStyles.sourceSansSB.body4,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class TambolaVideoPlayer extends StatefulWidget {
  const TambolaVideoPlayer({Key key, this.link}) : super(key: key);
  final String link;
  @override
  State<TambolaVideoPlayer> createState() => _TambolaVideoPlayerState();
}

class _TambolaVideoPlayerState extends State<TambolaVideoPlayer> {
  VideoPlayerController _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
        _controller.play();
      });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : Container();
  }
}
