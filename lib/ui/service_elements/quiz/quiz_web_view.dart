import 'dart:developer';
import 'dart:io';

import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';

class QuizWebView extends StatefulWidget {
  const QuizWebView({super.key, this.url});

  final String? url;

  @override
  State<QuizWebView> createState() => _QuizWebViewState();
}

class _QuizWebViewState extends State<QuizWebView> {
  WebViewController? _webViewController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    AppState.blockNavigation();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..addJavaScriptChannel('Print', onMessageReceived: (message) async {
        log(message.message);
        String data = message.message;
        if (data.startsWith('exit|')) {
          log("Close the quiz web window");
          AppState.unblockNavigation();
          AppState.backButtonDispatcher!.didPopRoute();
        } else if (data.startsWith('share|')) {
          String text = data.substring(6);
          await Share.share(text);
        }
      })
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (url) {
          log("onPageFinished: $url");
          setState(() {
            isLoading = false;
          });
        },
      ))
      ..loadRequest(Uri.parse(widget.url ?? ""));
  }

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    log("build run", name: "QuizWebView");
    return Scaffold(
      backgroundColor: UiConstants.kBackgroundColor,
      floatingActionButton: keyboardIsOpen && Platform.isIOS
          ? FloatingActionButton(
              backgroundColor: UiConstants.tertiarySolid,
              onPressed: () =>
                  SystemChannels.textInput.invokeMethod('TextInput.hide'),
              child: const Icon(
                Icons.done,
                color: Colors.white,
              ),
            )
          : const SizedBox(),
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: const Color(0xff227c74),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(
              controller: _webViewController!,
            ),
            if (isLoading)
              Container(
                color: Colors.black,
                child: const Center(
                  child: FullScreenLoader(),
                ),
              ),
            Positioned(
              right: SizeConfig.padding8,
              top: SizeConfig.padding8,
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: const Color(0xff227c74),
                        borderRadius:
                            BorderRadius.circular(SizeConfig.roundness12)),
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      color: Colors.white,
                      onPressed: () {
                        AppState.unblockNavigation();
                        AppState.backButtonDispatcher!.didPopRoute();

                        locator<AnalyticsService>()
                            .track(eventName: AnalyticsEvents.quizCrossTapped);
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
