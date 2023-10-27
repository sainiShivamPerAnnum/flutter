import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({required this.url, Key? key}) : super(key: key);
  final String url;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
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
