import 'dart:io';
import 'dart:ui';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChangeProfilePicture extends StatefulWidget {
  final File image;
  final ValueChanged<bool> upload;

  ChangeProfilePicture({this.image, this.upload});

  @override
  _ChangeProfilePictureState createState() => _ChangeProfilePictureState();
}

class _ChangeProfilePictureState extends State<ChangeProfilePicture> {
  Log log = new Log('ChangeProfilePicture');

  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
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

  dialogContent(BuildContext context) {
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
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Update Profile Picture",
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w500,
                    fontSize: SizeConfig.largeTextSize,
                  ),
                ),
              ),
              Container(
                height: SizeConfig.screenHeight * 0.2,
                width: SizeConfig.screenHeight * 0.2,
                margin: EdgeInsets.symmetric(vertical: 16),
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.black),
                child: Stack(
                  children: [
                    ClipOval(
                      child: Image.file(
                        widget.image,
                        height: SizeConfig.screenHeight * 0.2,
                        width: SizeConfig.screenHeight * 0.2,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              isUploading
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SpinKitThreeBounce(
                        color: UiConstants.primaryColor,
                        size: 24.0,
                      ),
                    )
                  : Column(
                      children: [
                        Container(
                          width: SizeConfig.screenWidth * 0.7,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: UiConstants.primaryColor),
                            onPressed: () {
                              setState(() {
                                isUploading = true;
                                widget.upload(true);
                              });
                            },
                            child: Text(
                              "Update",
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: SizeConfig.mediumTextSize,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: SizeConfig.screenWidth * 0.7,
                          child: ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(primary: Colors.white),
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              "Cancel",
                              style: GoogleFonts.montserrat(
                                color: Colors.black,
                                fontSize: SizeConfig.mediumTextSize,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
