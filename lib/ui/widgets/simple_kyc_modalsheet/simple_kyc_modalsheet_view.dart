//Project Imports
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/dialogs/augmont_regn_security_dialog.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/widgets/simple_kyc_modalsheet/simple_kyc_modelsheet_vm.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/palette.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
//Dart and Flutter Imports
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//Pub Imports
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SimpleKycModalSheetView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<SimpleKycModelsheetViewModel>(
      builder: (context, model, child) => Wrap(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.fromLTRB(25.0, 15.0, 25.0,
                  25 + MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                child: Form(
                  key: model.depositformKey3,
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
                                if (model.isKycInProgress) return;
                                AppState.backButtonDispatcher.didPopRoute();
                              },
                            )
                          ],
                        ),
                      ),
                      Divider(
                        endIndent: SizeConfig.screenWidth * 0.3,
                      ),
                      TextFieldLabel("PAN Card Number"),
                      TextFormField(
                        controller: model.panInput,
                        autofocus: true,
                        textCapitalization: TextCapitalization.characters,
                        enabled: true,
                      ),
                      TextFieldLabel("Your name as per your PAN Card"),
                      TextFormField(
                        controller: model.panHolderNameInput,
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
                          gradient: new LinearGradient(
                              colors: [
                                UiConstants.primaryColor,
                                UiConstants.primaryColor.withBlue(700)
                              ],
                              begin: Alignment(0.5, -1.0),
                              end: Alignment(0.5, 1.0)),
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                        child: new Material(
                          child: MaterialButton(
                            child: (!model.isKycInProgress)
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
                              model.onSubmit(context);
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
              )),
        ],
      ),
    );
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
                    color: FelloColorPalette.augmontFundPalette()
                        .secondaryColor
                        .withOpacity(0.8)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
