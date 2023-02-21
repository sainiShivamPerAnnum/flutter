import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/support/faq/faq_page.dart';

import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import './kyc_details_vm.dart';

class KycHelpView extends StatelessWidget {
  const KycHelpView({super.key, required this.callBack});
  final VoidCallback callBack;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiConstants.kBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {
                    callBack.call();
                  },
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ),
              Center(
                child: Text(
                  'KYC',
                  style: TextStyles.rajdhaniB.title4.colour(
                    Color(0xff62e1c2),
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  width: SizeConfig.screenWidth! * 0.8,
                  child: Text(
                    'To withdraw your money you need to complete KYC and Bank account verification.Fello verifies these details to make sure the withdrawal process is safe&secure',
                    textAlign: TextAlign.center,
                    style: TextStyles.sourceSans.body3.colour(
                      Color(0xff959595),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.padding12,
              ),
              Padding(
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
                      'Upload a clear picture of your pan card with all your details clearly visible',
                      style: TextStyles.rajdhaniSB.body3,
                    ),
                    SizedBox(
                      height: SizeConfig.padding12,
                    ),
                    Center(
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(6)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.padding12,
                          ),
                          child: Text(
                            'Name in your PAN Card=Name on your Bank Account',
                            style: TextStyles.sourceSansSB.body3,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.padding12,
                    ),
                    Image.asset('assets/images/pancard dummy.webp'),
                    SizedBox(
                      height: SizeConfig.padding16,
                    ),
                    Text(
                      'Step 2',
                      style: TextStyles.rajdhaniSB.body1,
                    ),
                    Text(
                      'Tap on upload and wait for your an verification to be done',
                      style: TextStyles.rajdhaniSB.body3,
                    ),
                    SizedBox(
                      height: SizeConfig.padding12,
                    ),
                    Image.asset('assets/images/upload screen.webp'),
                    SizedBox(
                      height: SizeConfig.padding16,
                    ),
                    Text(
                      'Step 3',
                      style: TextStyles.rajdhaniSB.body1,
                    ),
                    Text(
                      'You will receive a success message as soon as your PAN is verified!',
                      style: TextStyles.rajdhaniSB.body3,
                    ),
                    SizedBox(
                      height: SizeConfig.padding32,
                    ),
                    Center(
                      child: AppPositiveBtn(
                        width: SizeConfig.screenWidth! * 0.65,
                        btnText: 'PROCEED TO KYC',
                        onPressed: () {
                          callBack.call();
                        },
                      ),
                    ),
                    Center(
                      child: TextButton(
                          onPressed: () {
                            AppState.delegate!.appState.currentAction =
                                PageAction(
                              state: PageState.addWidget,
                              page: FaqPageConfig,
                              widget: FAQPage(
                                type: FaqsType.yourAccount,
                              ),
                            );
                          },
                          child: Text(
                            'Still need help?',
                            style: TextStyles.rajdhaniB.body2
                                .colour(Color(0xff12BC9D)),
                          )),
                    ),
                    SizedBox(
                      height: SizeConfig.padding28,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
