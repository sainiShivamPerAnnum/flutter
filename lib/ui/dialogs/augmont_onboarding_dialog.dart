import 'package:felloapp/base_util.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-elements/input_field.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/augmont_state_list.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class AugmontOnboarding extends StatefulWidget {
  final Function onSubmit;

  AugmontOnboarding({Key key, this.onSubmit}) : super(key: key);

  @override
  State createState() => AugmontOnboardingState();
}

class AugmontOnboardingState extends State<AugmontOnboarding> {
  final Log log = new Log('AugmontOnboarding');
  BaseUtil baseProvider;
  double _width;
  static TextEditingController panInput = new TextEditingController();
  bool _isInit = false;
  static String stateChosenValue;

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    if (!_isInit) {
      panInput.text = baseProvider.myUser.pan ?? '';
      _isInit = true;
    }
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
    return Stack(
        overflow: Overflow.visible,
        alignment: Alignment.topCenter,
        children: <Widget>[
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
                padding:
                    EdgeInsets.only(top: 30, bottom: 40, left: 35, right: 35),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                        child: SizedBox(
                      child: Image(
                        image: AssetImage(Assets.onboardingSlide[2]),
                        fit: BoxFit.contain,
                      ),
                      width: 150,
                      height: 150,
                    )),
                    Center(
                        child: Text(
                      'Register',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: UiConstants.primaryColor),
                    )),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text("Mobile No"),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        bottom: 20,
                        top: 5,
                      ),
                      padding: EdgeInsets.only(
                          left: 15, bottom: 5, top: 5, right: 15),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            bottom: 11, top: 11, right: 15),
                        child: Text(
                          baseProvider.myUser.mobile,
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text("PAN Card Number"),
                    ),
                    InputField(
                      child: TextFormField(
                        decoration: inputFieldDecoration('PAN Number'),
                        controller: panInput,
                        textCapitalization: TextCapitalization.characters,
                        enabled: true,
                        validator: (value) {
                          RegExp panCheck = RegExp(r"[A-Z]{5}[0-9]{4}[A-Z]{1}");
                          if (value.isEmpty) {
                            return 'PAN field cannot be empty';
                          } else if (panCheck.hasMatch(value)) {
                            return null;
                          } else {
                            return "invalid PAN Number";
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text("Residential State"),
                    ),
                    InputField(
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        iconEnabledColor: UiConstants.primaryColor,
                        hint: Text("Which state do you live in?"),
                        value: stateChosenValue,
                        onChanged: (String newVal) {
                          setState(() {
                            stateChosenValue = newVal;
                            print(newVal);
                          });
                        },
                        items: AugmontResources.augmontStateList
                            .map(
                              (e) => DropdownMenuItem(
                                value: e["id"],
                                child: Text(
                                  e["name"],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 50,
                      height: 50.0,
                      decoration: BoxDecoration(
                        gradient: new LinearGradient(
                            colors: [
                              UiConstants.primaryColor,
                              UiConstants.primaryColor.withBlue(200),
                            ],
                            begin: Alignment(0.5, -1.0),
                            end: Alignment(0.5, 1.0)),
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      child: new Material(
                        child: MaterialButton(
                          child: (!baseProvider.isAugmontRegnInProgress)
                              ? Text(
                                  'REGISTER',
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
                            RegExp panCheck =
                                RegExp(r"[A-Z]{5}[0-9]{4}[A-Z]{1}");
                            if (panInput.text.isEmpty) {
                              baseProvider.showNegativeAlert(
                                  'Invalid Pan',
                                  'Kindly enter a valid PAN Number',
                                  context);
                              return;
                            } else if (!panCheck.hasMatch(panInput.text)) {
                              baseProvider.showNegativeAlert('Invalid Pan',
                                  'Kindly enter a valid PAN Number', context);
                              return;
                            } else {
                              if (stateChosenValue == null ||
                                  stateChosenValue.isEmpty) {
                                baseProvider.showNegativeAlert(
                                    'State missing',
                                    'Kindly enter your current residential state',
                                    context);
                                return;
                              }
                              widget.onSubmit({
                                'pan_number': panInput.text,
                                'state_id': stateChosenValue
                              });
                              baseProvider.isAugmontRegnInProgress = true;
                              setState(() {});
                            }
                          },
                          highlightColor: Colors.white30,
                          splashColor: Colors.white30,
                        ),
                        color: Colors.transparent,
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                    )
                  ],
                )),
          )
        ]);
  }

  regnComplete(bool flag) {
    baseProvider.isAugmontRegnInProgress = false;
    Navigator.of(context).pop();
    if (!flag) {
      baseProvider.showNegativeAlert(
          'Registration Failed', 'Please try again in some time', context);
    }
  }
}
