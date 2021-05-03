import 'package:felloapp/core/ops/kyc_ops.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class KycWebview extends StatefulWidget {
  final String url;

  KycWebview({Key key, this.url}) : super(key: key);

  @override
  KycWebviewState createState() => KycWebviewState();
}

class KycWebviewState extends State<KycWebview> {
  KYCModel kycModel = KYCModel();

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: WebView(
        initialUrl: "${widget.url}",
        javascriptMode: JavascriptMode.unrestricted,
        navigationDelegate: (request) {
          if (request.url.contains('connect-success')) {
            print('success');
            // TODO when api success
          } else if (request.url.contains('connect-fail')) {
            // TODO when api fail
          }
          return NavigationDecision.navigate;
        },
      ),
    );
  }

  Future<bool> _willPopCallback() async {
    var result = await kycModel.saveAadharEsignPdf();
    var success = false;

    if (result['flag']) {
      var signedPdf = result['fields'];

      var finalResult = await kycModel.saveSignedPdf(signedPdf);

      if (finalResult['flag']) {
        var lastStage = await kycModel.kycVerificationEngine();
        print(lastStage);

        if (lastStage['flag']) {
          success = true;

          print('verified successfully');
          print(lastStage['fields']);
          Navigator.of(context).pop(success);
        } else {
          print(lastStage['message']);
          Navigator.of(context).pop(success);
        }
      } else {
        print(finalResult['message']);
      }
    } else {
      print(result['message']);
    }
  }
// checkCompleted()async

}
