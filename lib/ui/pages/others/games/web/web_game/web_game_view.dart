import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/games/web/web_game/web_game_vm.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebGameView extends StatelessWidget {
  const WebGameView({Key key, @required this.initialUrl, @required this.game})
      : super(key: key);
  final String initialUrl;
  final String game;
  @override
  Widget build(BuildContext context) {
    return BaseView<WebGameViewModel>(
      onModelReady: (model) {
        model.init(game);
        AppState.webGameInProgress = true;
      },
      onModelDispose: (model) {
        AppState.webGameInProgress = false;
      },
      builder: (ctx, model, child) {
        return Scaffold(
          backgroundColor: Colors.black,
          floatingActionButton: CircleAvatar(
            backgroundColor: Colors.red.withOpacity(0.5),
            child: IconButton(
              onPressed: AppState.backButtonDispatcher.didPopRoute,
              icon: Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
          body: Container(
            margin: EdgeInsets.only(top: SizeConfig.viewInsets.top),
            child: WebView(
              initialUrl: initialUrl,
              javascriptMode: JavascriptMode.unrestricted,
            ),
          ),
        );
      },
    );
  }
}
