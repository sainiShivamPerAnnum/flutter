import 'package:felloapp/base_util.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

// typedef UrlChange = void Function(String?);

class FdWebView extends StatefulWidget {
  final String url;
  final String? title;
  // final UrlChange? onUrlChanged;
  final VoidCallback? onPageClosed;

  const FdWebView({
    required this.url,
    // this.onUrlChanged,
    this.title,
    this.onPageClosed,
    super.key,
  });

  @override
  State<FdWebView> createState() => _FdWebViewState();
}

class _FdWebViewState extends State<FdWebView> {
  WebViewController? controller;

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      BaseUtil.showNegativeAlert('Error Occured', 'Could not launch: $url');
    }
  }

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onUrlChange: (change) => (change.url),
          onNavigationRequest: (request) {
            final url = request.url;
            if (url.startsWith('upi:') ||
                url.startsWith('intent:') ||
                url.startsWith('phonepe:') ||
                url.startsWith('gpay:') ||
                url.startsWith('paytm:') ||
                url.startsWith('tez:')) {
              _launchURL(url);
              return NavigationDecision.prevent;
            }
            if (url.startsWith('file:')) {
              return NavigationDecision.navigate;
            }
            return NavigationDecision.navigate;
          },
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: WebViewWidget(
          controller: controller!,
        ),
      ),
    );
  }
}
