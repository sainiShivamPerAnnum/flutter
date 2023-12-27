import 'dart:developer';
import 'dart:io';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';

class QuizWebView extends StatefulWidget {
  const QuizWebView({super.key});

  @override
  State<QuizWebView> createState() => _QuizWebViewState();
}

class _QuizWebViewState extends State<QuizWebView> {
  WebViewController? _webViewController;
  bool isLoading = true;

  String _onTapQuizSection() {
    final jwt = JWT(
      {'uid': locator<UserService>().baseUser!.uid},
    );
    String token = jwt.sign(
        SecretKey(
            '3565d165c367a0f1c615c27eb957dddfef33565b3f5ad1dda3fe2efd07326c1f'),
        expiresIn: const Duration(hours: 1));
    return token;
  }

  String constructBaseUrl() {
    Map<String, dynamic> quizSectionData =
        AppConfig.getValue(AppConfigKey.quiz_config);

    var key = _onTapQuizSection();

    return "${quizSectionData['baseUrl']}?token=$key";
  }

  Future<void> _onExitQuiz() async {
    log("Close the quiz web window");

    AppState.unblockNavigation();

    final superFelloIndex = AppState.delegate!.pages.indexWhere(
      (element) => element.name == FelloBadgeHomeViewPageConfig.path,
    );

    if (superFelloIndex != -1) {
      AppState.isQuizInProgress = false;
      while (AppState.delegate!.pages.last.name !=
          FelloBadgeHomeViewPageConfig.path) {
        await AppState.backButtonDispatcher!.didPopRoute();
      }

      await AppState.backButtonDispatcher!.didPopRoute();

      await Future.delayed(const Duration(milliseconds: 100));

      AppState.delegate!.appState.currentAction = PageAction(
        state: PageState.addPage,
        page: FelloBadgeHomeViewPageConfig,
      );
    } else {
      await AppState.backButtonDispatcher!.didPopRoute();
    }
  }

  @override
  void initState() {
    super.initState();

    String finalUrl = constructBaseUrl();

    AppState.blockNavigation();
    AppState.isQuizInProgress = true;
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..addJavaScriptChannel('Print', onMessageReceived: (message) async {
        log(message.message);
        String data = message.message;
        if (data.startsWith('exit|')) {
          await _onExitQuiz();
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
      ..loadRequest(Uri.parse(finalUrl));
  }

  @override
  Widget build(BuildContext context) {
    final keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;

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
                  IconButton(
                    icon: const Icon(Icons.close),
                    color: Colors.white,
                    onPressed: () {
                      AppState.unblockNavigation();
                      AppState.backButtonDispatcher!.didPopRoute();

                      locator<AnalyticsService>()
                          .track(eventName: AnalyticsEvents.quizCrossTapped);
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    AppState.isQuizInProgress = false;
    super.dispose();
  }
}
