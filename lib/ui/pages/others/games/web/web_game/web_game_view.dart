import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/cache_type_enum.dart';
import 'package:felloapp/core/service/cache_manager.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/games/web/web_game/web_game_vm.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebGameView extends StatelessWidget {
  const WebGameView(
      {Key key,
      @required this.initialUrl,
      @required this.game,
      this.inLandscapeMode = false})
      : super(key: key);
  final String initialUrl;
  final String game;
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
            body: Stack(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: Platform.isIOS
                          ? MediaQuery.of(context).padding.right
                          : 0),
                  child: WebView(
                    initialUrl: initialUrl,
                    javascriptMode: JavascriptMode.unrestricted,
                  ),
                ),
                inLandscapeMode
                    ? Positioned(
                        top: SizeConfig.padding16,
                        right: SizeConfig.padding16,
                        child: Close(inLandScape: inLandscapeMode),
                      )
                    : Positioned(
                        bottom: SizeConfig.padding16,
                        right: SizeConfig.padding16,
                        child: Close(),
                      )
              ],
            ),
          ),
        );
      },
    );
  }
}

class Close extends StatelessWidget {
  final bool inLandScape;
  Close({this.inLandScape = false});
  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).padding.top != 0 && inLandScape) {
      Future.delayed(Duration(seconds: 2), () {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
            overlays: [SystemUiOverlay.bottom]);
      });
    }
    return SafeArea(
      child: CircleAvatar(
        radius: SizeConfig.padding16,
        backgroundImage: CachedNetworkImageProvider(
            "https://firebasestorage.googleapis.com/v0/b/fello-dev-station.appspot.com/o/test%2Fgame-close-icon.png?alt=media&token=1d52f5d5-edca-4e0c-9b06-3e97aa8001ac"),
        backgroundColor: Colors.red.withOpacity(0.5),
        child: Opacity(
          opacity: 0,
          child: IconButton(
            onPressed: AppState.backButtonDispatcher.didPopRoute,
            icon: Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
