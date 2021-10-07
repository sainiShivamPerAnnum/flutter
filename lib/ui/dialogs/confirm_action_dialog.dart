import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConfirmActionDialog extends StatefulWidget {
  final String title, description, buttonText, cancelBtnText;
  final Function confirmAction, cancelAction;
  final Widget asset;

  ConfirmActionDialog(
      {@required this.title,
      @required this.description,
      @required this.buttonText,
      @required this.confirmAction,
      @required this.cancelAction,
      this.asset,
      this.cancelBtnText = 'Cancel'});

  @override
  State createState() => _FormDialogState();
}

class _FormDialogState extends State<ConfirmActionDialog> {
  Log log = new Log('ConfirmActionDialog');
  final _formKey = GlobalKey<FormState>();
  final fdbkController = TextEditingController();

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
            top: 5 + SizeConfig.cardBorderRadius,
            bottom: SizeConfig.cardBorderRadius,
            left: SizeConfig.cardBorderRadius,
            right: SizeConfig.cardBorderRadius,
          ),
          margin: EdgeInsets.all(10),
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
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16.0),
              widget.asset ?? SizedBox(),
              Text(
                widget.description,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: SizeConfig.mediumTextSize,
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: TextButton(
                      onPressed: () {
                        Haptic.vibrate();
                        log.debug('DialogAction cancelled');
                        AppState.backButtonDispatcher.didPopRoute();
                        return widget.cancelAction();
                      },
                      child: Text(
                        widget.cancelBtnText,
                        style: GoogleFonts.montserrat(
                            color: UiConstants.primaryColor),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed: () {
                        Haptic.vibrate();
                        log.debug('DialogAction clicked');
                        AppState.backButtonDispatcher.didPopRoute();
                        return widget.confirmAction();
                      },
                      child: Text(
                        widget.buttonText,
                        style: GoogleFonts.montserrat(
                            color: UiConstants.primaryColor),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
