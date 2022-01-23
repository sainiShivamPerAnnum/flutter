import 'dart:async';

import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/games/cricket/cricket_game/cricket_game_vm.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CricketGameView extends StatelessWidget {
  final String sessionId;
  final String userId;
  final String userName;
  final String stage;

  CricketGameView({this.sessionId, this.userId, this.userName, this.stage});
  final _logger = locator<CustomLogger>();
  @override
  Widget build(BuildContext context) {
    Completer<WebViewController> _controller = Completer<WebViewController>();
    String _url =
        '${Constants.GAME_CRICKET_URI}?userId=$userId&userName=$userName&sessionId=$sessionId&stage=$stage&gameId=cric2020';
    _logger.d("Webview URL - $_url");
    AppState.circGameInProgress = true;
    return BaseView<CricketGameViewModel>(
      builder: (ctx, model, child) => Scaffold(
        backgroundColor: UiConstants.primaryColor,
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
        body: WebView(
          initialUrl: _url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController controller) {
            _controller.complete(controller);
          },
        ),
      ),
    );
  }
}
