import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/ui/elements/appbar/appbar.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class BankDetailsHelpView extends StatelessWidget {
  const BankDetailsHelpView({required this.changeView, super.key});
  final VoidCallback changeView;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FAppBar(
        title: 'Verify Bank Account',
        showCoinBar: false,
        showLeading: false,
        showAvatar: false,
        leading: BackButton(
          onPressed: () => changeView.call(),
          color: Colors.white,
        ),
      ),
      backgroundColor: UiConstants.kBackgroundColor,
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: SizeConfig.padding16,
            ),
            Text(
              'Step 1',
              style: TextStyles.rajdhaniSB.body1,
            ),
            Text(
              'Gather your bank account details like - Bank account number, IFSC Code and Name (as per the bank)',
              style: TextStyles.rajdhaniSB.body3,
            ),
            SizedBox(
              height: SizeConfig.padding12,
            ),
            Image.asset(
              'assets/images/SBI-Passbook-1024x463.webp',
              height: SizeConfig.screenHeight! * 0.2,
            ),
            SizedBox(
              height: SizeConfig.padding12,
            ),
            Text.rich(
              TextSpan(
                style: TextStyles.rajdhani.body2,
                children: [
                  const TextSpan(text: 'Name on your'),
                  TextSpan(text: ' PAN card', style: TextStyles.body2.bold),
                  const TextSpan(text: ' should be the same as the name on'),
                  TextSpan(text: ' Bank Account', style: TextStyles.body2.bold),
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
              'Input these details in the next screen under the respective fields',
              style: TextStyles.rajdhaniSB.body3,
            ),
            SizedBox(
              height: SizeConfig.padding12,
            ),
            Center(
              child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(16)),
                  child: Image.asset(
                    'assets/images/bank details.webp',
                    height: SizeConfig.screenHeight! * 0.25,
                  )),
            ),
            const Spacer(),
            AppPositiveBtn(
              btnText: 'PROCEED TO Add Bank Details',
              onPressed: () {
                locator<AnalyticsService>().track(
                  eventName: 'proceed to bank account tapped',
                );
                changeView.call();
              },
            ),
            SizedBox(
              height: SizeConfig.padding16,
            ),
          ],
        ),
      ),
    );
  }
}
