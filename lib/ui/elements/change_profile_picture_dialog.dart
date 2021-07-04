import 'dart:io';
import 'dart:ui';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_analytics.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
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
  bool isUploading = false;
  bool isUploaded = false;

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

  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    int quality = 50;
    double filesize = file.lengthSync() / (1024 * 1024);
    if (filesize < 1) {
      quality = 75;
    }
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: quality,
      rotate: 0,
    );

    print(file.lengthSync());
    print(result.lengthSync());

    return result;
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

    uploadTask.then((res) async {
      await res.ref.getDownloadURL().then((url) {
        if (url != null) {
          isUploaded = true;
          baseProvider.isProfilePictureUpdated = true;
          //baseProvider.myUserDpUrl = url;
          baseProvider.setDisplayPictureUrl(url);
        }
        print(url);
      });
    });
    return isUploaded;
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
                padding: const EdgeInsets.symmetric(vertical: 16.0),
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
              InkWell(
                onTap: () {
                  setState(() {
                    isUploading = true;
                  });
                  if (widget.image != null) {
                    updatePicture(context).then((flag) {
                      if (flag) {
                        BaseAnalytics.logProfilePictureAdded();
                        baseProvider.showPositiveAlert('Complete',
                            'Your profile Picture have been updated', context);
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
                child: Container(
                  margin: EdgeInsets.only(top: 24, bottom: 8),
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
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
                    borderRadius: BorderRadius.circular(8),
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
