import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/games/web/web_game/web_game_vm.dart';
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
      onModelReady: (model) {
        if (inLandscapeMode) {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeRight,
            DeviceOrientation.landscapeLeft,
          ]);
          AppState.isWebGameLInProgress = true;
        } else {
          AppState.isWebGamePInProgress = true;
        }

        model.init(game);
      },
      onModelDispose: (model) {
        if (inLandscapeMode) {
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
        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: SizeConfig.viewInsets.top),
                child: WebView(
                  initialUrl: initialUrl,
                  javascriptMode: JavascriptMode.unrestricted,
                ),
              ),
              Positioned(
                top: SizeConfig.padding16,
                right: SizeConfig.padding16,
                child: SafeArea(
                  child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                        "https://firebasestorage.googleapis.com/v0/b/fello-dev-station.appspot.com/o/test%2Fgame-close-icon.png?alt=media&token=1d52f5d5-edca-4e0c-9b06-3e97aa8001ac"),
                    backgroundColor: Colors.red.withOpacity(0.5),
                    child: IconButton(
                      onPressed: AppState.backButtonDispatcher.didPopRoute,
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
