import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/user_augmont_details_model.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/http_ops.dart';
import 'package:felloapp/core/ops/icici_ops.dart';
import 'package:felloapp/main.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-elements/input_field.dart';
import 'package:felloapp/util/augmont_state_list.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/styles/palette.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AugmontRegisterModalSheet extends StatefulWidget {
  AugmontRegisterModalSheet({Key key}) : super(key: key);

  AugmontRegisterModalSheetState createState() =>
      AugmontRegisterModalSheetState();
}

class AugmontRegisterModalSheetState extends State<AugmontRegisterModalSheet> {
  AugmontRegisterModalSheetState();

  Log log = new Log('AugmontRegisterModalSheet');
  var heightOfModalBottomSheet = 100.0;
  BaseUtil baseProvider;
  final depositformKey3 = GlobalKey<FormState>();
  bool _isInitialized = false;
  AugmontModel augmontProvider;
  ICICIModel iProvider;
  HttpModel httpProvider;
  DBModel dbProvider;
  static String stateChosenValue;

  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    augmontProvider = Provider.of<AugmontModel>(context, listen: false);
    iProvider = Provider.of<ICICIModel>(context, listen: false);
    httpProvider = Provider.of<HttpModel>(context, listen: false);
    dbProvider = Provider.of<DBModel>(context, listen: false);
    return new Wrap(
      children: <Widget>[
        new Padding(
          padding: EdgeInsets.fromLTRB(
              25.0, 15.0, 25.0, 25 + MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            child: _formContent(context),
          ),
        ),
      ],
    );
  }

  Widget _formContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Augmont Registration',
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: FelloColorPalette.augmontFundPalette().primaryColor,
                ),
              ),
            ),
            Spacer(),
            IconButton(
              icon: Icon(
                Icons.clear_rounded,
                size: 30,
              ),
              onPressed: () {
                AppState.backButtonDispatcher.didPopRoute();
              },
            )
          ],
        ),
        // Center(
        //   child: Text(
        //     'Digital Gold Registration',
        //     textAlign: TextAlign.center,
        //     style: TextStyle(
        //       fontSize: 28,
        //       fontWeight: FontWeight.w700,
        //       color:  FelloColorPalette.augmontFundPalette().primaryColor,
        //     ),
        //   ),
        // ),
        SizedBox(
          height: 24,
        ),
        TextFormField(
          decoration: augmontFieldInputDecoration(
              baseProvider.myUser.mobile, Icons.phone),
          enabled: false,
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            border: Border.all(
                color: FelloColorPalette.augmontFundPalette().primaryColor),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonFormField(
            decoration: InputDecoration(
                border: InputBorder.none, enabledBorder: InputBorder.none),
            iconEnabledColor:
                FelloColorPalette.augmontFundPalette().primaryColor,
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
        SizedBox(height: 24),
        Container(
          width: SizeConfig.screenWidth,
          height: 50.0,
          decoration: BoxDecoration(
            gradient: new LinearGradient(colors: [
              FelloColorPalette.augmontFundPalette().primaryColor,
              FelloColorPalette.augmontFundPalette().primaryColor2
              // UiConstants.primaryColor,
              // UiConstants.primaryColor.withBlue(200),
            ], begin: Alignment(0.5, -1.0), end: Alignment(0.5, 1.0)),
            borderRadius: new BorderRadius.circular(10.0),
          ),
          child: new Material(
            child: MaterialButton(
              child: (!baseProvider.isAugmontRegnInProgress &&
                      !baseProvider.isAugmontRegnCompleteAnimateInProgress)
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
              onPressed: () async {
                _onSubmit();
              },
              highlightColor: Colors.white30,
              splashColor: Colors.white30,
            ),
            color: Colors.transparent,
            borderRadius: new BorderRadius.circular(30.0),
          ),
        ),
        //AugmontInfoTiles()
      ],
    );
  }

  void _onSubmit() async {
    if (!_preVerifyInputs()) {
      return;
    }
    baseProvider.isAugmontRegnInProgress = true;
    setState(() {});

    ///now register the augmont user
    UserAugmontDetail detail = await augmontProvider.createSimpleUser(
        baseProvider.myUser.mobile, stateChosenValue);
    if (detail == null) {
      baseProvider.showNegativeAlert('Registration Failed',
          'Failed to regsiter at the moment. Please try again.', context);
      baseProvider.isAugmontRegnInProgress = false;
      setState(() {});
      return;
    } else {
      ///show completion animation
      baseProvider.showPositiveAlert('Registration Successful',
          'You are successfully registered!', context);
      baseProvider.isAugmontRegnInProgress = false;
      setState(() {});
      AppState.backButtonDispatcher.didPopRoute();
    }
    setState(() {});
    return;
  }

  bool _preVerifyInputs() {
    if (stateChosenValue == null || stateChosenValue.isEmpty) {
      baseProvider.showNegativeAlert('State missing',
          'Kindly enter your current residential state', context);
      return false;
    }
    return true;
  }
}

class AugmontInfoTiles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BaseUtil baseProvider = Provider.of<BaseUtil>(context, listen: false);
    return Positioned(
      bottom: 0,
      child: Container(
        width: SizeConfig.screenWidth,
        padding: EdgeInsets.symmetric(vertical: 10),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                icon: Text("💰"),
                onPressed: () async {
                  Haptic.vibrate();
                  const url = "https://www.augmont.com/about-us";
                  if (await canLaunch(url))
                    await launch(url);
                  else
                    baseProvider.showNegativeAlert('Failed to launch URL',
                        'Please try again in sometime', context);
                },
                label: Text(
                  'More about Augmont',
                  style: TextStyle(
                      fontSize: SizeConfig.smallTextSize * 1.3,
                      decoration: TextDecoration.underline,
                      color: FelloColorPalette.augmontFundPalette()
                          .secondaryColor
                          .withOpacity(0.8)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
