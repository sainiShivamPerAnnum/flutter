import 'dart:developer';
import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FreshDeskHelp extends StatefulWidget {
  const FreshDeskHelp({super.key});

  @override
  State<FreshDeskHelp> createState() => _FreshDeskHelpState();
}

class _FreshDeskHelpState extends State<FreshDeskHelp> {
  WebViewController? _webViewController;
  int counter = 0;
  int exitCounter = 0;
  bool isLoading = true;
  final UserService _userService = locator<UserService>();

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..addJavaScriptChannel('Print', onMessageReceived: (message) {
        log(message.message);
        exitCounter++;
        if (message.message == 'Close the window' && exitCounter == 1) {
          log("Close the freshdesk window");
          AppState.backButtonDispatcher!.didPopRoute();
        }
      })
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) async {
            //Open Widget on startup
            await _webViewController!.runJavaScript('openWidget()');
            //prefill form with name email mobile and userid
            await _webViewController!.runJavaScript(
                'prefillForm("${_userService!.baseUser!.name}","${_userService!.baseUser!.email}","${_userService!.baseUser!.mobile}","${_userService!.baseUser!.uid}" )');
            //hide fields which are disabled and uneditable
            await _webViewController!.runJavaScript('hideFields()');
            exitLoading();
            //observe for window existence
            Future.delayed(const Duration(seconds: 3), () async {
              _webViewController!
                  .runJavaScriptReturningResult(
                      'setTimeout(function() {observeWindow()}, 1000);')
                  .then((value) {
                log("This is value " + value.toString());
              });
            });
          },
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(
          'https://fello-assets.s3.ap-south-1.amazonaws.com/freshdesk/freshdesk.html'));
  }

  exitLoading() {
    if (BaseUtil.showNoInternetAlert()) return;
    Future.delayed(const Duration(seconds: 3), () {
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
      backgroundColor: UiConstants.kBackgroundColor,
      floatingActionButton: keyboardIsOpen && Platform.isIOS
          ? FloatingActionButton(
              child: const Icon(
                Icons.done,
                color: Colors.white,
              ),
              backgroundColor: UiConstants.tertiarySolid,
              onPressed: () =>
                  SystemChannels.textInput.invokeMethod('TextInput.hide'),
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
                      icon: const Icon(Icons.arrow_back),
                      color: Colors.white,
                      onPressed: () async {
                        if (await _webViewController!.canGoBack()) {
                          _webViewController!.goBack();
                        }
                      },
                    ),
                  ),
                  SizedBox(width: SizeConfig.padding6),
                  Container(
                    decoration: BoxDecoration(
                        color: const Color(0xff227c74),
                        borderRadius:
                            BorderRadius.circular(SizeConfig.roundness12)),
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      color: Colors.white,
                      onPressed: () {
                        AppState.backButtonDispatcher!.didPopRoute();
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
