import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/connectivity_status.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/palette.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FeedbackDialog extends StatefulWidget {
  final String title, description, buttonText;
  final Function dialogAction;
  final Image image;

  FeedbackDialog({
    @required this.title,
    @required this.description,
    @required this.buttonText,
    @required this.dialogAction,
    this.image,
  });

  @override
  State createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  Log log = new Log('FeedbackDialog');
  final _formKey = GlobalKey<FormState>();
  final fdbkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ConnectivityStatus connectivityStatus =
        Provider.of<ConnectivityStatus>(context);
    BaseUtil baseProvider = Provider.of<BaseUtil>(context, listen: false);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SizeConfig.cardBorderRadius),
      ),
      backgroundColor: Colors.transparent,
      child: dialogContent(context, connectivityStatus, baseProvider),
    );
  }

  dialogContent(BuildContext context, ConnectivityStatus connectivityStatus,
      BaseUtil baseProvider) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.globalMargin,
        vertical: SizeConfig.globalMargin * 2,
      ),
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SizeConfig.cardBorderRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            CrossAxisAlignment.start, // To make the card compact
        children: <Widget>[
          Text(
            widget.title,
            style: GoogleFonts.montserrat(
              fontSize: SizeConfig.largeTextSize,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            widget.description,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(fontSize: SizeConfig.mediumTextSize),
          ),
          SizedBox(height: 16.0),
          Form(
            key: _formKey,
            child: TextFormField(
                enableSuggestions: true,
                keyboardType: TextInputType.multiline,
                autofocus: true,
                maxLines: 3,
                controller: fdbkController,
                validator: (value) {
                  return (value == null || value.isEmpty)
                      ? 'Please add some feedback'
                      : null;
                },
                cursorColor: UiConstants.primaryColor,
                decoration: new InputDecoration(
                  labelText: "Feedback",
                  //fillColor: Colors.white,
                  labelStyle: GoogleFonts.montserrat(
                    color: UiConstants.primaryColor,
                  ),
                  focusedBorder: new OutlineInputBorder(
                    borderRadius:
                        new BorderRadius.circular(SizeConfig.cardBorderRadius),
                    borderSide: new BorderSide(color: UiConstants.primaryColor),
                  ),
                  border: new OutlineInputBorder(
                    borderRadius:
                        new BorderRadius.circular(SizeConfig.cardBorderRadius),
                    borderSide: new BorderSide(color: UiConstants.primaryColor),
                  ),
                )),
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary:
                        FelloColorPalette.augmontFundPalette().secondaryColor),
                onPressed: () {
                  AppState.backButtonDispatcher.didPopRoute();
                },
                child: Text(
                  "Cancel",
                  style: GoogleFonts.montserrat(color: Colors.white),
                ),
              ),
              SizedBox(width: 16),
              ElevatedButton(
                style:
                    ElevatedButton.styleFrom(primary: UiConstants.primaryColor),
                onPressed: () {
                  Haptic.vibrate();
                  log.debug('DialogAction clicked');
                  if (connectivityStatus == ConnectivityStatus.Offline)
                    baseProvider.showNoInternetAlert(context);
                  else if (_formKey.currentState.validate()) {
                    widget.dialogAction(fdbkController.text);
                  }
                },
                child: Text(
                  widget.buttonText,
                  style: GoogleFonts.montserrat(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
