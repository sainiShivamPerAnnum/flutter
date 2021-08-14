import 'dart:io';
import 'dart:ui';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_analytics.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class ChangeProfilePicture extends StatefulWidget {
  final File image;

  ChangeProfilePicture({this.image});

  @override
  _ChangeProfilePictureState createState() => _ChangeProfilePictureState();
}

class _ChangeProfilePictureState extends State<ChangeProfilePicture> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  BaseUtil baseProvider;
  DBModel dbProvider;
  bool isUploading = false;
  bool isUploaded = false;

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    dbProvider = Provider.of<DBModel>(context, listen: false);
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

  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    return file;
  }

  Future<bool> updatePicture(BuildContext context) async {
    bool isUploaded = false;
    Directory tempdir = await getTemporaryDirectory();
    String imageName = widget.image.path.split("/").last;
    String targetPath = "${tempdir.path}/c-$imageName";
    print("temp path: " + targetPath);
    print("orignal path: " + widget.image.path);
    await testCompressAndGetFile(File(widget.image.path), targetPath);
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("dps/${baseProvider.myUser.uid}/image");
    UploadTask uploadTask = ref.putFile(File(targetPath));

    try {
      var res = await uploadTask;
      String url = await res.ref.getDownloadURL();
      if (url != null) {
        isUploaded = true;
        baseProvider.isProfilePictureUpdated = true;
        //baseProvider.myUserDpUrl = url;
        baseProvider.setDisplayPictureUrl(url);
        print(url);
      }
      return isUploaded;
    } catch (e) {
      if(baseProvider.myUser.uid!=null) {
        var errorDetails = {
          'Error message' : 'Method call to upload picture failed',
        };
        dbProvider.logFailure(baseProvider.myUser.uid, FailType.ProfilePictureUpdateFailed, errorDetails);
      }
      print('$e');
      return false;
    }
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
                              });
                              if (widget.image != null) {
                                updatePicture(context).then((flag) {
                                  if (flag) {
                                    BaseAnalytics.logProfilePictureAdded();
                                    baseProvider.showPositiveAlert(
                                        'Complete',
                                        'Your profile Picture has been updated',
                                        context);
                                  } else {
                                    baseProvider.showNegativeAlert(
                                        'Failed',
                                        'Your Profile Picture could not be updated at the moment',
                                        context);
                                  }
                                  setState(() {
                                    isUploading = false;
                                  });
                                  Navigator.pop(context);
                                });
                              }
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
                              "Cancle",
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
