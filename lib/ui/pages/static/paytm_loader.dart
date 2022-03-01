import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaytmLoader extends StatelessWidget {
  final String htmlCode;
  PaytmLoader({this.htmlCode});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebView(
          initialUrl:
              Uri.dataFromString(htmlCode, mimeType: 'text/html').toString(),
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
