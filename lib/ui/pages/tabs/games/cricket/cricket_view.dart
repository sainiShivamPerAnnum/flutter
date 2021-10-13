import 'dart:async';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CricketView extends StatelessWidget {
  final String sessionId;
  final String userId;
  final String userName;
  final String stage;

  CricketView({this.sessionId, this.userId, this.userName, this.stage});

  final _logger = locator<Logger>();

  @override
  Widget build(BuildContext context) {
    Completer<WebViewController> _controller = Completer<WebViewController>();

    String _url =
        '${Constants.GAME_CRICKET_URI}?userId=$userId&userName=$userName&sessionId=$sessionId&stage=$stage&gameId=cric2020';
    _logger.d("Webview URL - $_url");

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => AppState.backButtonDispatcher.didPopRoute(),
        child: Icon(
          Icons.exit_to_app,
          color: Colors.white,
        ),
        backgroundColor: Colors.amber,
      ),
      body: SafeArea(
        child: WebView(
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
