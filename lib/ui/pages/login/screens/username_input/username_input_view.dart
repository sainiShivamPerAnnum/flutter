import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/login/screens/username_input/username_input_vm.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum UsernameResponse { AVAILABLE, UNAVAILABLE, INVALID, EMPTY, SHORT, LONG }

class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}

class Username extends StatefulWidget {
  static const int index = 3;

  Username({Key key}) : super(key: key);

  @override
  UsernameState createState() => UsernameState();
}

class UsernameState extends State<Username> {
  UsernameInputScreenViewModel model;
  FocusNode focusNode;

  @override
  void dispose() {
    focusNode?.dispose();
    super.dispose();
  }

  Widget showResult(model) {
    print(model.response);
    if (model.isLoading) {
      return Container(
        height: 16,
        width: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      );
    } else if (model.response == UsernameResponse.EMPTY)
      return FittedBox(
        child: Text("username cannot be empty",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
      );
    else if (model.response == UsernameResponse.AVAILABLE)
      return FittedBox(
        child: Text("@${model.usernameController.text.trim()} is available",
            style: TextStyle(
                color: UiConstants.primaryColor, fontWeight: FontWeight.w500)),
      );
    else if (model.response == UsernameResponse.UNAVAILABLE)
      return FittedBox(
        child: Text("@${model.usernameController.text.trim()} is not available",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),
      );
    else if (model.response == UsernameResponse.INVALID) {
      if (model.usernameController.text.trim().length < 5)
        return FittedBox(
          child: Text("please enter a username with more than 4 characters.",
              maxLines: 2,
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),
        );
      else if (model.usernameController.text.trim().length > 20)
        return FittedBox(
          child: Text("please enter a username with less than 20 characters.",
              maxLines: 2,
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),
        );
      else
        return FittedBox(
          child: Text("@${model.usernameController.text.trim()} is invalid",
              maxLines: 2,
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),
        );
    }

    return SizedBox(
      height: 16,
    );
  }

  @override
  void didChangeDependencies() {
    if (mounted)
      Future.delayed(Duration(seconds: 2), () {
        if (mounted) FocusScope.of(context).requestFocus(focusNode);
      });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return BaseView<UsernameInputScreenViewModel>(
      onModelReady: (model) => this.model = model,
      builder: (ctx, model, child) => Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: SizeConfig.blockSizeVertical * 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    Assets.username,
                    width: SizeConfig.screenWidth * 0.28,
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.blockSizeVertical * 5),
              TextFieldLabel(locale.obUsernameLabel),
              SizedBox(height: SizeConfig.padding6),
              Form(
                key: model.formKey,
                child: Container(
                  child: TextFormField(
                    focusNode: focusNode,
                    controller: model.usernameController,
                    inputFormatters: [
                      LowerCaseTextFormatter(),
                      //FilteringTextInputFormatter.allow(regex)
                    ],
                    textCapitalization: TextCapitalization.none,
                    autofocus: true,
                    enabled: model.enabled,
                    cursorColor: UiConstants.primaryColor,
                    keyboardType: TextInputType.text,
                    validator: (val) {
                      if (val == null || val.isEmpty)
                        return "username cannot be empty";
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: locale.obUsernameHint,
                      prefixIcon: Icon(
                        Icons.alternate_email_rounded,
                        size: 20,
                        color: UiConstants.primaryColor,
                      ),
                    ),
                    onChanged: (value) {
                      model.validate();
                    },
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 16),
                padding: EdgeInsets.only(
                  bottom: 24,
                  left: 8,
                ),
                height: 40,
                child: showResult(model),
              ),
              //Text(responseText),
              SizedBox(height: SizeConfig.padding40),
              Text(
                locale.obUsernameRulesTitle,
                style: TextStyles.title4.bold,
              ),
              SizedBox(
                height: SizeConfig.padding16,
              ),
              RuleTile(rule: locale.obUsernameRule1),
              RuleTile(rule: locale.obUsernameRule2),
              RuleTile(rule: locale.obUsernameRule3),
              // RuleTile(rule: locale.obUsernameRule4),
              SizedBox(
                height: SizeConfig.screenHeight * 0.3,
              ),
              SizedBox(
                height: SizeConfig.viewInsets.bottom,
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
                        if (val.trim().length == 0 || val == null) return null;
                        if (val.trim().length < 3 || val.trim().length > 10)
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
      ),
    );
  }
}

class RuleTile extends StatelessWidget {
  final String rule;

  const RuleTile({this.rule});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: SizeConfig.padding16),
      child: Row(
        children: [
          CircleAvatar(
              backgroundColor: UiConstants.primaryColor,
              radius: SizeConfig.padding4),
          SizedBox(width: SizeConfig.padding4 * 2),
          Expanded(
            child: Text(
              rule,
              style: TextStyle(color: Colors.black26),
            ),
          ),
        ],
      ),
    );
  }
}
