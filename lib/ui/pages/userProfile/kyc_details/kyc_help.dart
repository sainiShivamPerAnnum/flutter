import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/ui/elements/appbar/appbar.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class KycHelpView extends StatelessWidget {
  const KycHelpView({required this.callBack, super.key});
  final VoidCallback callBack;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiConstants.kBackgroundColor,
      appBar: FAppBar(
        title: 'How to do KYC?',
        showCoinBar: false,
        showLeading: false,
        showAvatar: false,
        leading: BackButton(
          onPressed: () => callBack.call(),
          color: Colors.white,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.pageHorizontalMargins)
                    .copyWith(right: SizeConfig.padding32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Step 1',
                      style: TextStyles.rajdhaniSB.body1,
                    ),
                    Text(
                      'Upload a clear picture of your PAN card with all your details clearly visible',
                      style: TextStyles.sourceSansSB.body3,
                    ),
                    SizedBox(
                      height: SizeConfig.padding12,
                    ),
                    Center(
                      child: Image.asset(
                        'assets/images/pancard dummy.webp',
                        height: SizeConfig.screenWidth! * 0.4,
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.padding16,
                    ),
                    Text.rich(
                      TextSpan(
                        style: TextStyles.rajdhani.body2,
                        children: [
                          const TextSpan(text: 'Name on your'),
                          TextSpan(
                              text: ' PAN card', style: TextStyles.body2.bold),
                          const TextSpan(
                              text: ' should be the same as the name on'),
                          TextSpan(
                              text: ' Bank Account',
                              style: TextStyles.body2.bold),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: SizeConfig.padding16,
                    ),
                    Text(
                      'Step 2',
                      style: TextStyles.rajdhaniSB.body1,
                    ),
                    Text(
                      'Tap on upload and wait for your verification to be done',
                      style: TextStyles.sourceSansSB.body3,
                    ),
                    SizedBox(
                      height: SizeConfig.padding12,
                    ),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(12)),
                        child: Image.asset(
                          'assets/images/upload screen.webp',
                          height: SizeConfig.screenWidth! * 0.5,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.padding16,
                    ),
                    Text(
                      'Step 3',
                      style: TextStyles.rajdhaniSB.body1,
                    ),
                    Text(
                      'Verify your Email Address with google and your KYC is done',
                      style: TextStyles.sourceSansSB.body3,
                    ),
                    SizedBox(
                      height: SizeConfig.padding32,
                    ),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(12)),
                        child: Image.asset(
                          'assets/images/verify_gmail.jpg',
                          height: SizeConfig.screenWidth! * 0.3,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.padding16,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: AppPositiveBtn(
              width: SizeConfig.screenWidth! * 0.8,
              btnText: 'PROCEED TO KYC',
              onPressed: () {
                locator<AnalyticsService>().track(
                  eventName: 'Proceed to kyc',
                );
                callBack.call();
              },
            ),
          ),
          SizedBox(
            height: SizeConfig.padding16,
          ),
        ],
      ),
    );
  }
}
