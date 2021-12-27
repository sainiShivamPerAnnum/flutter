import 'dart:io';
import 'dart:ui';

import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text("Update Profile Picture",
                    style: TextStyles.title3.bold),
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
                  ? Container(
                      alignment: Alignment.center,
                      height: SizeConfig.screenWidth * 0.26,
                      child: Container(
                        height: SizeConfig.padding40,
                        width: SizeConfig.padding40,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: UiConstants.primaryColor,
                          backgroundColor: UiConstants.tertiarySolid,
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        Container(
                          width: SizeConfig.screenWidth,
                          child: FelloButtonLg(
                            child: Text(
                              "Update",
                              style: TextStyles.body3.bold.colour(Colors.white),
                            ),
                            onPressed: () {
                              setState(() {
                                isUploading = true;
                                widget.upload(true);
                              });
                            },
                          ),
                        ),
                        SizedBox(height: SizeConfig.padding12),
                        Container(
                          width: SizeConfig.screenWidth,
                          child: FelloButtonLg(
                              color: Colors.grey[300],
                              child: Text(
                                "Cancel",
                                style: TextStyles.body3.bold,
                              ),
                              onPressed: () =>
                                  AppState.backButtonDispatcher.didPopRoute()),
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
