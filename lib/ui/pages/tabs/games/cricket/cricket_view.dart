import 'dart:async';
import 'package:felloapp/navigator/app_state.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CricketView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Completer<WebViewController> _controller = Completer<WebViewController>();

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
          initialUrl: "https://www.google.com",
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController controller) {
            _controller.complete(controller);
          },
        ),
      ),
    );
  }
}
