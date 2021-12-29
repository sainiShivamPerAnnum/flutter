import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/login/screens/mobile_input/mobile_input_vm.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MobileInputScreenView extends StatefulWidget {
  static const int index = 0; //pager index
  const MobileInputScreenView({Key key}) : super(key: key);

  @override
  State<MobileInputScreenView> createState() => MobileInputScreenViewState();
}

class MobileInputScreenViewState extends State<MobileInputScreenView> {
  MobileInputScreenViewModel model;
  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return BaseView<MobileInputScreenViewModel>(
      onModelReady: (m) {
        model = m;
      },
      builder: (ctx, model, child) => Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: SizeConfig.blockSizeVertical * 5),
              SvgPicture.asset(Assets.enterPhoneNumber,
                  width: SizeConfig.screenHeight * 0.16),
              SizedBox(height: SizeConfig.blockSizeVertical * 5),
              Text(
                locale.obEnterMobile,
                textAlign: TextAlign.center,
                style: TextStyles.title4.bold,
              ),
              SizedBox(height: SizeConfig.padding12),
              Text(
                locale.obMobileDesc,
                textAlign: TextAlign.center,
                style: TextStyles.body2,
              ),
              SizedBox(height: SizeConfig.padding40),
              Row(
                children: [
                  Text(
                    locale.obMobileLabel,
                    textAlign: TextAlign.start,
                    style: TextStyles.body3.colour(Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.padding6),
              Form(
                key: model.formKey,
                child: Column(
                  children: [
                    TextFormField(
                      key: model.phoneFieldKey,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      maxLength: 10,
                      cursorColor: UiConstants.primaryColor,
                      style: TextStyles.body3.colour(Colors.black),
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(SizeConfig.padding4),
                          child: Image.asset(
                            Assets.indFlag,
                            width: SizeConfig.padding8,
                          ),
                        ),
                        prefixText: "+91 ",
                        prefixStyle: TextStyles.body3.colour(Colors.black),
                      ),
                      onChanged: (val) {
                        if (val.length == 10) FocusScope.of(context).unfocus();
                      },
                      onTap: model.showAvailablePhoneNumbers,
                      controller: model.mobileController,
                      validator: (value) => model.validateMobile(),
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical,
                    ),
                    model.hasReferralCode
                        ? TextFormField(
                            controller: model.referralCodeController,
                            onChanged: (val) {},
                            //maxLength: 10,
                            decoration: InputDecoration(
                              hintText: "Enter your referral code here",
                              hintStyle: TextStyles.body3.colour(Colors.grey),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zA-Z0-9]'))
                            ],
                            validator: (val) {
                              if (val.trim().length == 0 || val == null)
                                return null;
                              if (val.trim().length < 3 ||
                                  val.trim().length > 10)
                                return "Invalid referral code";
                              return null;
                            })
                        : TextButton(
                            onPressed: () {
                              setState(() {
                                model.hasReferralCode = true;
                              });
                            },
                            child: Text(
                              "Have a referral code?",
                              style: TextStyles.body2.bold
                                  .colour(UiConstants.primaryColor),
                            ),
                          ),
                    if (model.hasReferralCode)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Referral codes are case-sensitive",
                          textAlign: TextAlign.start,
                          style: TextStyles.body4.colour(Colors.black54),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: SizeConfig.blockSizeVertical * 4),
              SizedBox(
                  height: SizeConfig.screenHeight * 0.2 +
                      MediaQuery.of(context).padding.bottom)
            ],
            //)
          ),
        ),
      ),
    );
  }
}
