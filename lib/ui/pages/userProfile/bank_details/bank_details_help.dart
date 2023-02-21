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

class BankDetailsHelpView extends StatelessWidget {
  const BankDetailsHelpView({super.key, required this.changeView});
  final VoidCallback changeView;
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
                    changeView.call();
                  },
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ),
              Center(
                child: Text(
                  'BANK ACCOUNT DETAILS',
                  style: TextStyles.rajdhaniB.title4.colour(
                    Color(0xff62e1c2),
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  width: SizeConfig.screenWidth! * 0.7,
                  child: Text(
                    'You can easily update your bank details \nand submit as shown below:',
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
                      'Type in your bank account number,IFSC code and name as per Bank. ',
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
                    Image.asset('assets/images/SBI-Passbook-1024x463.webp'),
                    SizedBox(
                      height: SizeConfig.padding16,
                    ),
                    Text(
                      'Step 2',
                      style: TextStyles.rajdhaniSB.body1,
                    ),
                    Text(
                      'Tap on Add and wait for your an verification to be done',
                      style: TextStyles.rajdhaniSB.body3,
                    ),
                    SizedBox(
                      height: SizeConfig.padding12,
                    ),
                    Image.asset('assets/images/bank details.webp'),
                    SizedBox(
                      height: SizeConfig.padding16,
                    ),
                    Text(
                      'Step 3',
                      style: TextStyles.rajdhaniSB.body1,
                    ),
                    Text(
                      'You will receive a success message as soon as your Bank Account is verified!',
                      style: TextStyles.rajdhaniSB.body3,
                    ),
                    SizedBox(
                      height: SizeConfig.padding32,
                    ),
                    Center(
                      child: AppPositiveBtn(
                        // width: SizeConfig.screenWidth! * 0.,
                        btnText: 'PROCEED TO Add Bank Details',
                        onPressed: () {
                          changeView.call();
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
