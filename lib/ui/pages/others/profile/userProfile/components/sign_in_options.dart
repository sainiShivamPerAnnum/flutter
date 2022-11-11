import 'package:felloapp/base_util.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class SignInOptions extends StatefulWidget {
  final Function onGoogleSignIn, onEmailSignIn;
  SignInOptions({this.onEmailSignIn, this.onGoogleSignIn});
  @override
  _SignInOptionsState createState() => _SignInOptionsState();
}

class _SignInOptionsState extends State<SignInOptions> {
  bool _isGoogleSigningInProgress = false;

  get isGoogleSigningInProgress => this._isGoogleSigningInProgress;

  set isGoogleSigningInProgress(value) {
    if (mounted)
      setState(() {
        this._isGoogleSigningInProgress = value;
      });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        AppState.backButtonDispatcher.didPopRoute();
        return true;
      },
      child: Wrap(
        children: [
          Container(
            decoration: BoxDecoration(),
            padding: EdgeInsets.all(
              SizeConfig.blockSizeHorizontal * 5,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Choose an email option",
                    style: TextStyles.rajdhaniB.title5),
                Divider(
                    height: 32, thickness: 1, color: UiConstants.kTextColor2),
                ListTile(
                  leading: SvgPicture.asset(
                    Assets.google,
                    height: 24,
                    width: 24,
                  ),
                  trailing: isGoogleSigningInProgress
                      ? Container(
                          child: CircularProgressIndicator(
                            strokeWidth: 0.5,
                          ),
                        )
                      : SizedBox(),
                  title: Text(
                    "Continue with Google",
                    style: TextStyles.sourceSans.body2,
                  ),
                  onTap: () async {
                    BaseUtil.showNoInternetAlert();
                    if (isGoogleSigningInProgress) return;
                    isGoogleSigningInProgress = true;
                    await widget.onGoogleSignIn();
                    isGoogleSigningInProgress = false;
                  },
                ),
                Divider(),
                ListTile(
                    leading: Icon(
                      Icons.alternate_email,
                      color: UiConstants.primaryColor,
                    ),
                    title: Text("Use another email",
                        style: TextStyles.sourceSans.body2),
                    onTap: () {
                      if (!isGoogleSigningInProgress) {
                        widget.onEmailSignIn();
                      }
                    }),
                SizedBox(
                  height: 24,
                )
              ],
            ),
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
