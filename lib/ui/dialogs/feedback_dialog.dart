import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/connectivity_status.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/logger.dart';
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
        borderRadius: BorderRadius.circular(UiConstants.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context, connectivityStatus, baseProvider),
    );
  }

  dialogContent(BuildContext context, ConnectivityStatus connectivityStatus,
      BaseUtil baseProvider) {
    return Stack(
      children: <Widget>[
        //...bottom card part,
        Container(
          padding: EdgeInsets.only(
            //top: UiConstants.avatarRadius + UiConstants.padding,
            top: UiConstants.padding + 30,
            bottom: UiConstants.padding,
            left: UiConstants.padding,
            right: UiConstants.padding,
          ),
          //margin: EdgeInsets.only(top: UiConstants.avatarRadius),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(UiConstants.padding),
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
                style: GoogleFonts.montserrat(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                widget.description,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 16.0),
              Form(
                key: _formKey,
                child: TextFormField(
                    enableSuggestions: true,
                    keyboardType: TextInputType.multiline,
                    autofocus: true,
                    maxLines: 6,
                    controller: fdbkController,
                    validator: (value) {
                      return (value == null || value.isEmpty)
                          ? 'Please add some feedback'
                          : null;
                    },
                    decoration: new InputDecoration(
                      labelText: "Feedback",
                      //fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                    )),
              ),
              SizedBox(height: 16.0),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
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
                    style: GoogleFonts.montserrat(),
                  ),
                ),
              ),
            ],
          ),
        ),
        //...top circlular image part,
//        Positioned(
//          left: UiConstants.padding,
//          right: UiConstants.padding,
//          child: CircleAvatar(
//            backgroundColor: Colors.blueAccent,
//            radius: UiConstants.avatarRadius,
//          ),
//        ),
      ],
    );
  }
}
