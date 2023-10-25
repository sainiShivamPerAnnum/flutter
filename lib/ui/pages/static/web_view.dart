import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  final String? title;

  const WebViewScreen({required this.url, this.title});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  bool _viewLoader = false;

  get viewLoader => _viewLoader;

  set viewLoader(value) {
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _viewLoader = value;
        setState(() {});
      });
    }
  }

  WebViewController? controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (_) => viewLoader = true,
          onPageFinished: (_) => viewLoader = false,
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  void dispose() {
    controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: UiConstants.kBackgroundColor,
        actions: [
          if (viewLoader)
            Row(
              children: [
                Container(
                  width: kToolbarHeight / 2.5,
                  height: kToolbarHeight / 2.5,
                  margin:
                      EdgeInsets.only(right: SizeConfig.pageHorizontalMargins),
                  child: const CircularProgressIndicator(strokeWidth: 2),
                ),
              ],
            )
        ],
      ),
      body: WebViewWidget(
        controller: controller!,
      ),
    );
  }
}
