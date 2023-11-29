import 'dart:async';

import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/shared/recording_disabled_mixin.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

typedef UrlChange = void Function(String?);

class NetBankingWebView extends StatefulWidget {
  final String url;
  final String? title;
  final UrlChange? onUrlChanged;
  final VoidCallback? onPageClosed;

  const NetBankingWebView({
    required this.url,
    this.onUrlChanged,
    this.title,
    this.onPageClosed,
    super.key,
  });

  @override
  State<NetBankingWebView> createState() => _NetBankingWebViewState();
}

class _NetBankingWebViewState extends State<NetBankingWebView>
    with RecordingDisableMixin<NetBankingWebView> {
  WebViewController? controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onUrlChange: (change) => widget.onUrlChanged?.call(change.url),
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  void dispose() {
    controller = null;
    widget.onPageClosed?.call();
    super.dispose();
  }

  Future<void> _onTimerCompleted() async {
    AppState.unblockNavigation();
    AppState.unblockNavigation();
    await AppState.backButtonDispatcher?.didPopRoute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: UiConstants.kBackgroundColor,
        actions: [
          TimerWidget(
            onTimerFinish: _onTimerCompleted,
          ),
        ],
      ),
      body: WebViewWidget(
        controller: controller!,
      ),
    );
  }
}

class TimerWidget extends StatefulWidget {
  final VoidCallback onTimerFinish;

  const TimerWidget({
    required this.onTimerFinish,
    super.key,
  });

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  int _seconds = 300;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        setState(() {
          _seconds--;
        });
      } else {
        _timer.cancel();
        widget.onTimerFinish();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Padding(
        padding: const EdgeInsets.only(right: 18),
        child: Text(
          'Timeout in ${(_seconds ~/ 60).toString().padLeft(2, '0')}:${(_seconds % 60).toString().padLeft(2, '0')}',
          style: TextStyles.sourceSansSB.body2,
        ),
      ),
    );
  }
}
