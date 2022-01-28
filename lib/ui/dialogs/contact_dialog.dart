import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsDialog extends StatefulWidget {
//  final String title, description, buttonText;
//  final Function dialogAction;
//  final Image image;
  final bool isResident;
  final Function onClick;
  final bool isUnavailable;

  ContactUsDialog(
      {@required this.isResident,
      @required this.onClick,
      @required this.isUnavailable});

  @override
  State createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUsDialog> {
  Log log = new Log('FormDialog');
  final _formKey = GlobalKey<FormState>();
  final fdbkController = TextEditingController();
  static bool _isCallbackInitiated = false;

  @override
  void dispose() {
    _isCallbackInitiated = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SizeConfig.cardBorderRadius),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        //...bottom card part,
        Container(
          padding: EdgeInsets.only(
            top: SizeConfig.cardBorderRadius + 30,
            bottom: SizeConfig.cardBorderRadius + 30,
            left: SizeConfig.cardBorderRadius,
            right: SizeConfig.cardBorderRadius,
          ),
          //margin: EdgeInsets.only(top: UiConstants.avatarRadius),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(SizeConfig.cardBorderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              InkWell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.email,
                      size: 25,
                    ),
                    Text(
                      ' hello@${Constants.APP_NAME.toLowerCase()}.in',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                onTap: () async {
                  const url =
                      "mailto:support@fello.in?subject=Fello Support&body=Hello";
                  if (await canLaunch(url)) {
                    await launch(url);
                  }
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              InkWell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.phone,
                      size: 25,
                    ),
                    Text(
                      ' +91 79932 52690',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                onTap: () async {
                  const url = "tel://+917993252690";
                  if (await canLaunch(url)) {
                    await launch(url);
                  }
                },
              ),
              SizedBox(height: 16.0),
              InkWell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: Image(
                        image: AssetImage(Assets.whatsappIcon),
                        fit: BoxFit.contain,
                        color: Colors.black,
                      ),
                      width: 25,
                    ),
                    Text(
                      ' +91 79932 52690',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                onTap: () async {
                  const url = "whatsapp://send?phone=+917993252690";
                  if (await canLaunch(url)) {
                    await launch(url);
                  }
                },
              ),
              SizedBox(height: 15.0),
              Text(
                'OR',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 16.0),
              Material(
                color:
                    (widget.isResident) ? UiConstants.accentColor : Colors.grey,
                child: MaterialButton(
                  child: (!_isCallbackInitiated)
                      ? Text(
                          'Request a callback',
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        )
                      : SpinKitThreeBounce(
                          color: UiConstants.spinnerColor2,
                          size: 25.0,
                        ),
                  minWidth: double.infinity,
                  onPressed: () {
                    if (widget.isUnavailable || !widget.isResident)
                      widget.onClick();
                    else if (!_isCallbackInitiated) {
                      Haptic.vibrate();
                      setState(() {
                        _isCallbackInitiated = true;
                      });
                      widget.onClick();
                    }
                  },
                ),
                borderRadius: new BorderRadius.circular(10.0),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
