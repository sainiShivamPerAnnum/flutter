import 'package:felloapp/base_util.dart';
import 'package:felloapp/ui/elements/pin_input_custom_text_field.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class IciciRedemptionOtpDialog extends StatefulWidget {
  final ValueChanged<String> otpEntered;

  IciciRedemptionOtpDialog({Key key, this.otpEntered}) : super(key: key);

  @override
  State createState() => IciciRedemptionOtpDialogState();
}

class IciciRedemptionOtpDialogState extends State<IciciRedemptionOtpDialog> {
  final Log log = new Log('IciciRedemptionOtpDialog');
  double _width;
  final otpController = new TextEditingController();
  BaseUtil baseProvider;

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    _width = MediaQuery.of(context).size.width;
    return Dialog(
      insetPadding: EdgeInsets.only(left: 20, top: 50, bottom: 80, right: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.white,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
          padding: EdgeInsets.only(top: 30, bottom: 40, left: 35, right: 35),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                child: Image(
                  image: AssetImage(Assets.onboardingSlide[2]),
                  fit: BoxFit.contain,
                ),
                width: 150,
                height: 150,
              ),
              Text(
                "Please enter the OTP sent to your mobile and email",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: UiConstants.accentColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 18.0),
                  child: PinInputTextField(
                    enabled: true,
                    pinLength: 5,
                    decoration: UnderlineDecoration(
                        color: Colors.grey,
                        textStyle:
                            TextStyle(fontSize: 20, color: Colors.black)),
                    controller: otpController,
                    autoFocus: true,
                    textInputAction: TextInputAction.go,
                    onSubmit: (pin) {
                      print("Pressed submit for pin: " +
                          pin.toString() +
                          "\n  No action taken.");
                    },
                  )),
              SizedBox(
                height: 10,
              ),
              new Container(
                  height: 50.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(colors: [
                      UiConstants.primaryColor,
                      UiConstants.primaryColor.withBlue(200),
                    ], begin: Alignment(0.5, -1.0), end: Alignment(0.5, 1.0)),
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  child: Material(
                    child: MaterialButton(
                      child: (!baseProvider.isRedemptionOtpInProgress)
                          ? Text(
                              'CONFIRM',
                              style: Theme.of(context)
                                  .textTheme
                                  .button
                                  .copyWith(color: Colors.white),
                            )
                          : SpinKitThreeBounce(
                              color: UiConstants.spinnerColor2,
                              size: 18.0,
                            ),
                      onPressed: () {
                        Haptic.vibrate();
                        if (!baseProvider.isRedemptionOtpInProgress &&
                            otpController.text.length == 5) {
                          widget.otpEntered(otpController.text);
                          baseProvider.isRedemptionOtpInProgress = true;
                          setState(() {});
                        }
                      },
                      highlightColor: Colors.white30,
                      splashColor: Colors.white30,
                    ),
                    color: Colors.transparent,
                    borderRadius: new BorderRadius.circular(30.0),
                  )),
            ],
          )),
    );
  }

  onOtpVerifyComplete(bool isSuccess) {
    if (isSuccess) {
      baseProvider.isRedemptionOtpInProgress = false;
      setState(() {});
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      BaseUtil.showPositiveAlert(
          'Success', 'Your transaction has been completed');
      baseProvider.showRefreshIndicator(context);
    } else {
      baseProvider.isRedemptionOtpInProgress = false;
      setState(() {});
      BaseUtil.showNegativeAlert('Invalid OTP', 'Please try again');
    }
  }
}
