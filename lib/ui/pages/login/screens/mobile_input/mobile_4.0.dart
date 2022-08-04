import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/login/login_components/login_textfield.dart';

import 'package:felloapp/ui/pages/login/screens/mobile_input/mobile_input_vm.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MobileView4 extends StatefulWidget {
  static const int index = 0; //pager index
  const MobileView4({Key key}) : super(key: key);
  @override
  State<MobileView4> createState() => MobileView4State();
}

class MobileView4State extends State<MobileView4> {
  MobileInputScreenViewModel model;
  @override
  Widget build(BuildContext context) {
    return BaseView<MobileInputScreenViewModel>(
      onModelReady: (model) {
        this.model = model;
      },
      onModelDispose: (model) {},
      builder: (ctx, model, child) {
        return Stack(
          alignment: AlignmentDirectional.center,
          children: [
            NewSquareBackground(),
            Positioned(
              top: 0,
              child: Container(
                height: SizeConfig.screenHeight * 0.5,
                width: SizeConfig.screenWidth,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF135756),
                      UiConstants.kBackgroundColor,
                    ],
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: SizeConfig.padding80),
                SvgPicture.asset('assets/svg/flag_svg.svg'),
                SizedBox(height: SizeConfig.padding80),
                Text(
                  'Hey!',
                  style: TextStyles.rajdhaniB.title2,
                ),
                SizedBox(height: SizeConfig.padding12),
                Text(
                  'Enter mobile number to sign up',
                  style: TextStyles.sourceSans.body3.colour(Color(0xFFBDBDBE)),
                ),
                SizedBox(height: SizeConfig.padding40),
                //input
                Form(
                  key: model.formKey,
                  child: LogInTextField(
                    hintText: '0000000000',
                    textFieldKey: model.phoneFieldKey,
                    textInputType: TextInputType.phone,
                    inputFormatter: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    maxLength: 10,
                    controller: model.mobileController,
                    onTap: model.showAvailablePhoneNumbers,
                    validator: (value) => model.validateMobile(),
                    // onChanged: (val) {
                    //   if (val.length == 10) FocusScope.of(context).unfocus();
                    // },
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  ),
                ),
                Spacer(),
                Text(
                  '100% Safe & Secure',
                  style: TextStyles.sourceSans.body3.colour(Color(0xFFBDBDBE)),
                ),
                SizedBox(height: SizeConfig.padding16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BankingLogo(
                      asset: 'assets/images/augmont_logo.png',
                    ),
                    BankingLogo(
                      asset: 'assets/images/icici_logo.png',
                    ),
                    BankingLogo(
                      asset: 'assets/images/cbi_logo.png',
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.padding40),
              ],
            ),
            // if (isKeyboardOpen)
            // Positioned(
            //   bottom: MediaQuery.of(context).viewInsets.bottom,

            //   child: GestureDetector(
            //     onTap: () {
            //       FocusManager.instance.primaryFocus.unfocus();
            //     },
            //     child: Container(
            //       width: SizeConfig.screenWidth,
            //       height: 50,
            //       color: Colors.black54,
            //       padding: EdgeInsets.symmetric(
            //         horizontal: SizeConfig.pageHorizontalMargins,
            //       ),
            //       alignment: Alignment.centerRight,
            //       child: Text(
            //         "Next",
            //         style: TextStyles.body2.bold
            //             .colour(UiConstants.primaryColor),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        );
      },
    );
  }
}

class BankingLogo extends StatelessWidget {
  final String asset;

  const BankingLogo({Key key, this.asset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding12),
      height: SizeConfig.screenWidth * 0.085,
      width: SizeConfig.screenWidth * 0.085,
      decoration: BoxDecoration(
        color: Color(0xFF39393C),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Image.asset(
          asset,
          height: SizeConfig.screenWidth * 0.053,
          width: SizeConfig.screenWidth * 0.053,
        ),
      ),
    );
  }
}
