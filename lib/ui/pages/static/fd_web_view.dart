import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/elements/appbar/appbar.dart';
import 'package:felloapp/util/styles/styles.dart';
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
      await BaseUtil.launchUrl(url);
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
            // Handle payment apps
            if (url.startsWith('upi:') ||
                url.startsWith('intent:') ||
                url.startsWith('phonepe:') ||
                url.startsWith('gpay:') ||
                url.startsWith('paytm:') ||
                url.startsWith('tez:')) {
              _launchURL(url);
              return NavigationDecision.prevent;
            }
            // Handle file URLs
            if (url.startsWith('file:')) {
              return NavigationDecision.navigate;
            }
            // Handle VKYC links
            if (url.contains('vkyc360.unitybank.co.in') ||
                url.contains('vkycuat.unitybank.co.in') ||
                url.contains('vkyc.suryodaybank.com') ||
                url.contains('uat.videocx.io')) {
              _launchURL(url);
              return NavigationDecision.prevent;
            }

            // Handle T&C documents
            if (url.contains('blostem-assets.s3.ap-south-1.amazonaws.com') ||
                url.contains('blostem.com/terms-of-use')) {
              _launchURL(url);
              return NavigationDecision.prevent;
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
    return WillPopScope(
      onWillPop: () async {
        return !Platform.isIOS;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: FAppBar(
            backgroundColor: UiConstants.kTextColor,
            centerTitle: true,
            titleWidget: Text(
              'Fixed Deposit',
              style: TextStyles.rajdhaniSB.body1.colour(
                UiConstants.kTextColor4,
              ),
            ),
            leading: BackButton(
              color: UiConstants.kTextColor4,
              onPressed: () async {
                if (controller != null && await controller!.canGoBack()) {
                  await controller!.goBack();
                } else {
                  await AppState.backButtonDispatcher!.didPopRoute();
                }
              },
            ),
            showAvatar: false,
            showCoinBar: false,
          ),
          body: WebViewWidget(
            controller: controller!,
          ),
        ),
      ),
    );
  }
}
