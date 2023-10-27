import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/repository/user_stats_repo.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/modalsheets/want_more_tickets_modal_sheet.dart';
import 'package:felloapp/ui/pages/games/web/web_game/web_game_vm.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebGameView extends StatelessWidget {
  const WebGameView(
      {required this.initialUrl,
      required this.game,
      Key? key,
      this.inLandscapeMode = false})
      : super(key: key);
  final String initialUrl;
  final String? game;
  final bool inLandscapeMode;

  @override
  Widget build(BuildContext context) {
    return BaseView<WebGameViewModel>(
      onModelReady: (model) async {
        model.init(game, inLandscapeMode);
      },
      onModelDispose: (model) {
        if (inLandscapeMode) {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
              overlays: SystemUiOverlay.values); // to re-show bars

          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]);
          AppState.isWebGameLInProgress = false;
        } else {
          AppState.isWebGamePInProgress = false;
        }
      },
      builder: (ctx, model, child) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
              backgroundColor: Colors.black,
              body: inLandscapeMode
                  ? GameView(
                      model: model,
                      inLandscapeMode: inLandscapeMode,
                      initialUrl: initialUrl)
                  : SafeArea(
                      child: GameView(
                          model: model,
                          inLandscapeMode: inLandscapeMode,
                          initialUrl: initialUrl),
                    )),
        );
      },
    );
  }
}

class GameView extends StatefulWidget {
  final bool inLandscapeMode;
  final String initialUrl;
  WebGameViewModel model;

  GameView(
      {required this.inLandscapeMode,
      required this.initialUrl,
      required this.model,
      super.key});

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  int exitCounter = 0;

  WebViewController? controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setBackgroundColor(Colors.black)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'Print',
        onMessageReceived: (message) {
          log(message.message);
          exitCounter++;
          if (message.message == 'insufficient tokens' && exitCounter == 1) {
            widget.model.updateFlcBalance();

            locator<UserStatsRepo>().getGameStats();
            BaseUtil.openModalBottomSheet(
              addToScreenStack: true,
              backgroundColor: UiConstants.gameCardColor,
              content: WantMoreTicketsModalSheet(
                isInsufficientBalance: true,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(SizeConfig.roundness24),
                topRight: Radius.circular(SizeConfig.roundness24),
              ),
              hapticVibrate: true,
              isScrollControlled: true,
              isBarrierDismissible: true,
            );
          }
        },
      )
      ..loadRequest(Uri.parse(widget.initialUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.symmetric(
                horizontal:
                    Platform.isIOS ? MediaQuery.of(context).padding.right : 0),
            child: WebViewWidget(
              controller: controller!,
            ),
          ),
          // inLandscapeMode
          //     ?
          Positioned(
            top: SizeConfig.padding16,
            right: SizeConfig.padding16,
            child: Close(inLandScape: widget.inLandscapeMode),
          )
          // : Positioned(
          //     bottom: SizeConfig.padding16,
          //     right: SizeConfig.padding16,
          //     child: Close(),
          //   )
        ],
      ),
    );
  }
}

class Close extends StatelessWidget {
  final bool inLandScape;

  const Close({super.key, this.inLandScape = false});

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).padding.top != 0 && inLandScape) {
      Future.delayed(const Duration(seconds: 2), () {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
            overlays: [SystemUiOverlay.bottom]);
      });
    }
    return SafeArea(
      child: CircleAvatar(
        radius: SizeConfig.padding16,
        backgroundImage: const CachedNetworkImageProvider(
            "https://firebasestorage.googleapis.com/v0/b/fello-dev-station.appspot.com/o/test%2Fgame-close-icon.png?alt=media&token=1d52f5d5-edca-4e0c-9b06-3e97aa8001ac"),
        backgroundColor: Colors.red.withOpacity(0.5),
        child: Opacity(
          opacity: 0,
          child: IconButton(
            onPressed: AppState.backButtonDispatcher!.didPopRoute,
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
