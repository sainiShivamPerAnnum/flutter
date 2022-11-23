import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  WebViewScreen({required this.url});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  bool _viewLoader = false;

  get viewLoader => this._viewLoader;

  set viewLoader(value) {
    if (mounted)
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        this._viewLoader = value;
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: UiConstants.kBackgroundColor,
        title: Text(
          widget.url,
          style: TextStyles.body2,
        ),
        actions: [
          if (viewLoader)
            Row(
              children: [
                Container(
                  width: kToolbarHeight / 2.5,
                  height: kToolbarHeight / 2.5,
                  child: CircularProgressIndicator(strokeWidth: 2),
                  margin:
                      EdgeInsets.only(right: SizeConfig.pageHorizontalMargins),
                ),
              ],
            )
        ],
      ),
      body: WebView(
        backgroundColor: Colors.black,
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
        onPageFinished: (_) => viewLoader = false,
        onPageStarted: (_) => viewLoader = true,
      ),
    );
  }
}
