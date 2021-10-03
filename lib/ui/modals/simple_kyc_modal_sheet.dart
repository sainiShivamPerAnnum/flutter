import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/AugGoldRates.dart';
import 'package:felloapp/core/model/signzy_pan/signzy_login.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/http_ops.dart';
import 'package:felloapp/core/ops/icici_ops.dart';
import 'package:felloapp/main.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/dialogs/augmont_confirm_register_dialog.dart';
import 'package:felloapp/ui/dialogs/augmont_regn_security_dialog.dart';
import 'package:felloapp/ui/dialogs/more_info_dialog.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-elements/input_field.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/icici_api_util.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/palettes.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class SimpleKycModalSheet extends StatefulWidget {
  SimpleKycModalSheet({Key key}) : super(key: key);

  SimpleKycModalSheetState createState() => SimpleKycModalSheetState();
}

class SimpleKycModalSheetState extends State<SimpleKycModalSheet>
    with SingleTickerProviderStateMixin {
  SimpleKycModalSheetState();

  Log log = new Log('SimpleKycModalSheet');
  var heightOfModalBottomSheet = 100.0;
  BaseUtil baseProvider;
  final depositformKey3 = GlobalKey<FormState>();
  AugmontModel augmontProvider;
  ICICIModel iProvider;
  HttpModel httpProvider;
  DBModel dbProvider;

  static TextEditingController _panInput = new TextEditingController();
  static TextEditingController _panHolderNameInput =
      new TextEditingController();

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
          child: _depositDialog(),
        ),
      ],
    );
  }

  Widget _depositDialog() {
    return Container(
      child: Form(
        key: depositformKey3,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: Row(
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'KYC Verification',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: UiConstants.primaryColor),
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.clear_rounded,
                      size: 30,
                    ),
                    onPressed: () {
                      if (baseProvider.isSimpleKycInProgress) return;
                      AppState.backButtonDispatcher.didPopRoute();
                    },
                  )
                ],
              ),
            ),
            Divider(
              endIndent: SizeConfig.screenWidth * 0.3,
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(labelText: "PAN Card Number"),
              controller: _panInput,
              autofocus: false,
              textCapitalization: TextCapitalization.characters,
              enabled: true,
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration:
                  InputDecoration(labelText: 'Your name as per your PAN Card'),
              controller: _panHolderNameInput,
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.characters,
              enabled: true,
              autofocus: false,
              validator: (value) {
                return null;
              },
            ),
            SizedBox(height: 24),
            Container(
              width: SizeConfig.screenWidth,
              height: 50.0,
              decoration: BoxDecoration(
                gradient: new LinearGradient(colors: [
                  UiConstants.primaryColor,
                  UiConstants.primaryColor.withBlue(700)
                  // UiConstants.primaryColor,
                  // UiConstants.primaryColor.withBlue(200),
                ], begin: Alignment(0.5, -1.0), end: Alignment(0.5, 1.0)),
                borderRadius: new BorderRadius.circular(10.0),
              ),
              child: new Material(
                child: MaterialButton(
                  child: (!baseProvider.isSimpleKycInProgress)
                      ? Text(
                          'DONE',
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
            SizedBox(
              height: 30,
            ),
            KycInfoTiles()
          ],
        ),
      ),
    );
  }

  void _onSubmit() async {
    if (!_preVerifyInputs()) {
      return;
    }
    FocusScope.of(context).unfocus();
    baseProvider.isSimpleKycInProgress = true;
    setState(() {});

    ///next get all details required for registration
    Map<String, dynamic> veriDetails =
        await _getVerifiedDetails(_panInput.text, _panHolderNameInput.text);
    if (veriDetails != null &&
        veriDetails['flag'] != null &&
        veriDetails['flag']) {
      AppState.screenStack.add(ScreenItem.dialog);

      ///show confirmation dialog to user
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AugmontConfirmRegnDialog(
          panNumber: _panInput.text,
          panName: _panHolderNameInput.text,
          bankHolderName: "",
          bankBranchName: "",
          bankAccNo: "",
          bankIfsc: "",
          bankName: "",
          dialogColor: UiConstants.primaryColor,
          onAccept: () async {
            bool _p = true;
            bool _q = true;

            ///add the pan number
            if (baseProvider.userRegdPan == null ||
                baseProvider.userRegdPan.isEmpty ||
                baseProvider.userRegdPan != _panInput.text) {
              baseProvider.userRegdPan = _panInput.text;
              _p = await baseProvider.panService
                  .saveUserPan(baseProvider.userRegdPan);
            }
            if (baseProvider.myUser.isSimpleKycVerified == null ||
                !baseProvider.myUser.isSimpleKycVerified) {
              baseProvider.myUser.isSimpleKycVerified = true;
              baseProvider.setKycVerified(true);
              _q = await dbProvider.updateUser(baseProvider.myUser);
            }
            if (!_p || !_q) {
              baseProvider.showNegativeAlert('Verification Failed',
                  'Failed to verify at the moment. Please try again.', context);
              baseProvider.isSimpleKycInProgress = false;
              setState(() {});
              return;
            } else {
              baseProvider.showPositiveAlert('Verification Successful',
                  'You are successfully verified!', context);
              baseProvider.isSimpleKycInProgress = false;
              setState(() {});
              AppState.backButtonDispatcher.didPopRoute();
            }
          },
          onReject: () {
            baseProvider.showNegativeAlert(
                'Registration Cancelled', 'Please try again', context);
            baseProvider.isSimpleKycInProgress = false;
            setState(() {});
            return;
          },
        ),
      );
    } else {
      print('inside failed name');
      if (veriDetails['fail_code'] == 0)
        showDialog(
            context: context,
            builder: (BuildContext context) => MoreInfoDialog(
                  text: veriDetails['reason'],
                  imagePath: Assets.dummyPanCardShowNumber,
                  title: 'Invalid Details',
                ));
      else
        baseProvider.showNegativeAlert('Registration failed',
            veriDetails['reason'] ?? 'Please try again', context);

      baseProvider.isSimpleKycInProgress = false;
      setState(() {});
      return;
    }
  }

  bool _preVerifyInputs() {
    RegExp panCheck = RegExp(r"[A-Z]{5}[0-9]{4}[A-Z]{1}");
    if (_panInput.text.isEmpty) {
      baseProvider.showNegativeAlert(
          'Invalid Pan', 'Kindly enter a valid PAN Number', context);
      return false;
    } else if (!panCheck.hasMatch(_panInput.text) ||
        _panInput.text.length != 10) {
      baseProvider.showNegativeAlert(
          'Invalid Pan', 'Kindly enter a valid PAN Number', context);
      return false;
    } else if (_panHolderNameInput.text.isEmpty) {
      baseProvider.showNegativeAlert('Name missing',
          'Kindly enter your name as per your pan card', context);
      return false;
    }
    return true;
  }

  Future<Map<String, dynamic>> _getVerifiedDetails(
      String enteredPan, String enteredPanName) async {
    if (enteredPan == null || enteredPan.isEmpty)
      return {'flag': false, 'reason': 'Invalid Details'};
    bool _flag = true;
    int _failCode = 0;
    String _reason = '';
    if (!iProvider.isInit()) await iProvider.init();

    bool registeredFlag = await httpProvider.isPanRegistered(enteredPan);
    if (registeredFlag) {
      _flag = false;
      _failCode = 1;
      _reason =
          'This PAN number is already associated with a different account';
    }
    var kObj;
    if (_flag) {
      SignzyPanLogin _signzyPanLogin =
      await dbProvider.getActiveSignzyPanApiKey();

      try {
        bool isPanVerified = await httpProvider.verifyPanSignzy(
            baseUrl: _signzyPanLogin.baseUrl,
            panNumber: enteredPan,
            panName: enteredPanName,
            authToken: _signzyPanLogin.accessToken,
            patronId: _signzyPanLogin.userId);

        _flag = isPanVerified;
      } catch (e) {
        _flag = false;
        _reason = e.toString();
      }
    }
    if (!_flag) {
      print('returning false flag');
      return {'flag': _flag, 'fail_code': _failCode, 'reason': _reason};
    }

    return {
      'flag': true,
      'pan_name': enteredPanName,
    };
  }
}

class KycInfoTiles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              icon: Text("🔒"),
              onPressed: () {
                Haptic.vibrate();
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        AugmontRegnSecurityDialog(
                          text: Assets.infoAugmontRegnSecurity,
                          imagePath: 'images/aes256.png',
                          title: 'Security > Rest',
                        ));
              },
              label: Text(
                'Note on Security',
                style: TextStyle(
                    fontSize: SizeConfig.smallTextSize * 1.3,
                    decoration: TextDecoration.underline,
                    color: augmontGoldPalette.secondaryColor.withOpacity(0.8)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
