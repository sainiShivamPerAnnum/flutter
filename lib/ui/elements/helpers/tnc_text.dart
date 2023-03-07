import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({Key? key, required this.url}) : super(key: key);
  final String url;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: GestureDetector(
          onTap: () async {
            AppState.delegate!
                .parseRoute(Uri.parse(url), title: "Terms and Conditions");
          },
          child: Text(
            "Terms and Conditions",
            style: TextStyles.rajdhaniSB.body3
                .colour(Colors.white.withOpacity(0.6))
                .copyWith(decoration: TextDecoration.underline),
          ),
        ),
      ),
    );
  }
}
