import 'dart:async';
import 'dart:developer';

import 'package:felloapp/core/model/paytm_models/create_paytm_subscription_response_model.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaytmLoader extends StatefulWidget {
  final String mid;
  final String vpa;
  final CreateSubscriptionResponseModel paytmSubscriptionModel;

  PaytmLoader({
    @required this.mid,
    @required this.vpa,
    @required this.paytmSubscriptionModel,
  });

  @override
  State<PaytmLoader> createState() => _PaytmLoaderState();
}

class _PaytmLoaderState extends State<PaytmLoader> {
  WebViewController _webViewController;
  String htmlCode;

  _loadHtmlContent() {
    htmlCode = """
      <form name="paytm_form" method="POST" action="https://securegw-stage.paytm.in/order/pay?mid=${widget.mid}&orderId=${widget.paytmSubscriptionModel.data.orderId}">
         <input type="hidden" name="txnToken" value="${widget.paytmSubscriptionModel.data.temptoken}" />
         <input type="hidden" name="SUBSCRIPTION_ID" value="${widget.paytmSubscriptionModel.data.subscriptionId}" />
         <input type="hidden" name="paymentMode" value="UPI" />
         <input type="hidden" name="AUTH_MODE" value="USRPWD" />
         <input type="hidden" name="payerAccount" value="${widget.vpa}" />
      </form>
      <script type="text/javascript">
         document.paytm_form.submit();
      </script>
      """;
    _webViewController.loadHtmlString(htmlCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebView(
          initialUrl: "https://fello.in",
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController controller) {
            _webViewController = controller;
            _loadHtmlContent();
          },
          onPageFinished: (url) {
            if (url.contains('paytmCallback'))
              AppState.backButtonDispatcher.didPopRoute();
          },
        ),
      ),
    );
  }
}
