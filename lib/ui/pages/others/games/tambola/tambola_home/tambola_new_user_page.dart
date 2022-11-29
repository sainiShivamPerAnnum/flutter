import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_home/tambola_existing_user_page.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_home/tambola_home_view.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_home/tambola_home_vm.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';

import 'package:felloapp/ui/widgets/appbar/appbar.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/fello_button.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';

import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:felloapp/util/url_type_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';

class TambolaWrapper extends StatelessWidget {
  const TambolaWrapper({Key? key}) : super(key: key);

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
            body: (model.activeTambolaCardCount ?? 0) > 0
                ? TambolaExistingUserPage(
                    model: model,
                  )
                : TambolaNewUserPage(
                    model: model,
                  ),
          ),
        );
      },
    );
  }
}

class TambolaNewUserPage extends StatefulWidget {
  const TambolaNewUserPage(
      {Key? key, required this.model, this.showPrizeSection = false})
      : super(key: key);
  final TambolaHomeViewModel model;
  final bool showPrizeSection;
  @override
  State<TambolaNewUserPage> createState() => _TambolaNewUserPageState();
}

class _TambolaNewUserPageState extends State<TambolaNewUserPage> {
  ScrollController? _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();

    if (widget.showPrizeSection) {
      Future.delayed(Duration(seconds: 1), () {
        WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
          _scrollController?.animateTo(SizeConfig.screenWidth! * 1.2,
              duration: Duration(milliseconds: 500),
              curve: Curves.fastLinearToSlowEaseIn);
        });
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FAppBar(
        showAvatar: false,
        showCoinBar: false,
        showHelpButton: false,
        title: "Tambola",
        type: FaqsType.play,
        backgroundColor: UiConstants.kArowButtonBackgroundColor,
      ),
      backgroundColor: UiConstants.kBackgroundColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                TambolaHeader(
                  model: widget.model,
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: SizeConfig.padding12),
                  width: SizeConfig.screenWidth! * 0.9,
                  child: Text(
                    widget.model.game!.description!,
                    textAlign: TextAlign.center,
                    style: TextStyles.rajdhaniSB.body2
                        .colour(Color(0xffD9D9D9).withOpacity(0.41)),
                  ),
                ),
                TambolaTicketInfo(),
                SizedBox(height: SizeConfig.padding20),
                TambolaPrize(
                  model: widget.model,
                ),
                TambolaLeaderBoard(
                  model: widget.model,
                ),
                SizedBox(
                  height: SizeConfig.screenHeight! * 0.17,
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
              color: UiConstants.kBackgroundColor,
              // height: SizeConfig.screenHeight! * 0.17,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: SizeConfig.padding12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(Assets.sparklingStar),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          widget.model.game?.highLight ?? '',
                          style: TextStyles.sourceSans.body4
                              .colour(Color(0xffA7A7A8)),
                        ),
                      ],
                    ),
                  ),
                  AppPositiveBtn(
                    btnText: (widget.model.activeTambolaCardCount ?? 0) >= 1
                        ? "Get Tickets"
                        : 'Get your first ticket',
                    onPressed: () {
                      locator<AnalyticsService>().track(
                          eventName: AnalyticsEvents.tambolaSaveTapped,
                          properties: AnalyticsProperties
                              .getDefaultPropertiesMap(extraValuesMap: {
                            "Time left for draw Tambola (mins)":
                                AnalyticsProperties.getTimeLeftForTambolaDraw(),
                            "Tambola Tickets Owned":
                                AnalyticsProperties.getTambolaTicketCount(),
                            "Number of Tickets": 1,
                            "Amount": widget.model.ticketSavedAmount,
                          }));
                      widget.model.updateTicketSavedAmount(1);
                      BaseUtil().openDepositOptionsModalSheet(
                          amount: widget.model.ticketSavedAmount);
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
  const TambolaHeader({Key? key, required this.model}) : super(key: key);
  final TambolaHomeViewModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight! * 0.4,
      width: double.infinity,
      margin:
          EdgeInsets.symmetric(horizontal: SizeConfig.padding24, vertical: 12),
      decoration: BoxDecoration(
          color: UiConstants.kBackgroundColor,
          borderRadius: BorderRadius.circular(SizeConfig.roundness12)),
      child: Builder(
        builder: (_) {
          switch (UrlTypeHelper.getType(model.game!.walkThroughUri!)) {
            case UrlType.IMAGE:
              return SvgPicture.network(model.game!.walkThroughUri!);
            case UrlType.VIDEO:
              return TambolaVideoPlayer(link: model.game!.walkThroughUri!);

            default:
              return SizedBox();
          }
        },
      ),
    );
  }
}

class TambolaTicketInfo extends StatelessWidget {
  const TambolaTicketInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight! * 0.10,
      width: SizeConfig.screenWidth! * 0.80,
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
            width: SizeConfig.screenWidth! * 0.37,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "₹ " +
                      (AppConfig.getValue<String?>(AppConfigKey.tambola_cost)
                                  ?.isEmpty ??
                              true
                          ? '500'
                          : AppConfig.getValue<String>(
                              AppConfigKey.tambola_cost)),
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
            width: SizeConfig.screenWidth! * 0.37,
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
  const TambolaVideoPlayer({Key? key, required this.link}) : super(key: key);
  final String link;
  @override
  State<TambolaVideoPlayer> createState() => _TambolaVideoPlayerState();
}

class _TambolaVideoPlayerState extends State<TambolaVideoPlayer> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.network(widget.link)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
        _controller?.setLooping(true);
        _controller?.play();
      });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller?.value.isInitialized ?? false
        ? ClipRRect(
            borderRadius: BorderRadius.circular(SizeConfig.roundness12),
            child: AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: VideoPlayer(_controller!),
            ),
          )
        : Container();
  }
}
