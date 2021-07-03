import 'dart:ui';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UpdateNameDialog extends StatefulWidget {
  @override
  _UpdateNameDialogState createState() => _UpdateNameDialogState();
}

class _UpdateNameDialogState extends State<UpdateNameDialog> {
  BaseUtil baseProvider;
  bool isUploading = false;
  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        child: dialogContent(context),
      ),
    );
  }

  Widget dialogContent(BuildContext context) {
    return Wrap(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  "Update Name",
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w500,
                    fontSize: SizeConfig.largeTextSize,
                  ),
                ),
              ),
              TextField(
                autofocus: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: UiConstants.primaryColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: UiConstants.primaryColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isUploading = true;
                  });
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 24),
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: UiConstants.primaryColor,
                  ),
                  alignment: Alignment.center,
                  child: isUploading
                      ? SpinKitThreeBounce(
                          color: UiConstants.spinnerColor2,
                          size: 18.0,
                        )
                      : Text(
                          "Update",
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: SizeConfig.mediumTextSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              ),
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  margin: EdgeInsets.only(bottom: 24),
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: UiConstants.primaryColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: isUploading
                      ? SpinKitThreeBounce(
                          color: UiConstants.spinnerColor2,
                          size: 18.0,
                        )
                      : Text(
                          "Cancle",
                          style: GoogleFonts.montserrat(
                            color: UiConstants.primaryColor,
                            fontSize: SizeConfig.mediumTextSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
