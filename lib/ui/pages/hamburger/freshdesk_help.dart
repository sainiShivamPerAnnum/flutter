import 'dart:developer';
import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FreshDeskHelp extends StatefulWidget {
  @override
  State<FreshDeskHelp> createState() => _FreshDeskHelpState();
}

class _FreshDeskHelpState extends State<FreshDeskHelp> {
  WebViewController _webViewController;
  int counter = 0;
  int exitCounter = 0;
  bool isLoading = true;
  final _userService = locator<UserService>();
  _loadHtmlFromAssets() async {
    _webViewController.loadFlutterAsset('resources/freshdesk.html');
  }

  exitLoading() {
    if (BaseUtil.showNoInternetAlert()) return;
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    log("build run");
    return Scaffold(
      backgroundColor: UiConstants.primaryColor,
      floatingActionButton: keyboardIsOpen && Platform.isIOS
          ? FloatingActionButton(
              child: Icon(
                Icons.done,
                color: Colors.white,
              ),
              backgroundColor: UiConstants.tertiarySolid,
              onPressed: () =>
                  SystemChannels.textInput.invokeMethod('TextInput.hide'),
            )
          : SizedBox(),
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: Color(0xff227c74),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            WebView(
              initialUrl: 'https://www.fello.in/',
              javascriptMode: JavascriptMode.unrestricted,
              onPageFinished: (_) async {
                //Open Widget on startup
                await _webViewController.runJavascript('openWidget()');
                //prefill form with name email mobile and userid
                await _webViewController.runJavascript(
                    'prefillForm("${_userService.baseUser.name}","${_userService.baseUser.email}","${_userService.baseUser.mobile}","${_userService.baseUser.uid}" )');
                //hide fields which are disabled and uneditable
                await _webViewController.runJavascript('hideFields()');
                exitLoading();
                //observe for window existence
                Future.delayed(Duration(seconds: 3), () async {
                  _webViewController
                      .runJavascriptReturningResult('observeWindow()')
                      .then((value) {
                    log(value);
                  });
                });
              },
              javascriptChannels: Set.from([
                JavascriptChannel(
                    name: 'Print',
                    onMessageReceived: (JavascriptMessage message) {
                      log(message.message);
                      exitCounter++;
                      if (message.message == 'Close the window' &&
                          exitCounter == 1) {
                        log("Close the freshdesk window");
                        AppState.backButtonDispatcher.didPopRoute();
                      }
                    })
              ]),
              onWebViewCreated: (WebViewController controller) {
                _webViewController = controller;
                _loadHtmlFromAssets();
              },
            ),
            Positioned(
              top: 0,
              child: Container(
                height: SizeConfig.padding4,
                width: SizeConfig.screenWidth,
                color: UiConstants.primaryColor,
              ),
            ),
            if (isLoading)
              Container(
                color: Colors.white,
                child: Center(
                  child: SpinKitWave(
                    color: UiConstants.primaryColor,
                    size: SizeConfig.padding40,
                  ),
                ),
              ),
            Positioned(
              right: SizeConfig.padding8,
              top: SizeConfig.padding8,
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Color(0xff227c74),
                        borderRadius:
                            BorderRadius.circular(SizeConfig.roundness12)),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back),
                      color: Colors.white,
                      onPressed: () async {
                        if (await _webViewController.canGoBack())
                          _webViewController.goBack();
                      },
                    ),
                  ),
                  SizedBox(width: SizeConfig.padding6),
                  Container(
                    decoration: BoxDecoration(
                        color: Color(0xff227c74),
                        borderRadius:
                            BorderRadius.circular(SizeConfig.roundness12)),
                    child: IconButton(
                      icon: Icon(Icons.close),
                      color: Colors.white,
                      onPressed: () {
                        AppState.backButtonDispatcher.didPopRoute();
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
