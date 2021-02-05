import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:webview_flutter/webview_flutter.dart';

class KycWebview extends StatefulWidget {
  @override
  KycWebviewState createState() => KycWebviewState();
}

class KycWebviewState extends State<KycWebview> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.


  }

  @override
  Widget build(BuildContext context)
  {
    return WebView(initialUrl: 'https://esign-preproduction.signzy.tech/nsdl-esign-customer2/5b2e4ddd84b5cd6c465019ed/token/8aBTTkfgtqiOZvUotD6GJ1yaalNTTmBAg04RTOzSsLSvGAbFAvC1l3mvjiCX1612553003805',
      javascriptMode: JavascriptMode.unrestricted,

    );
  }
}