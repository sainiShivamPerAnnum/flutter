import 'dart:io';
import 'dart:ui';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
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

  Future<void> updatePicture(BuildContext context) async {
    setState(() {
      if (isUploading == false) {
        isUploading = true;
      }
    });
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
      String url = await res.ref.getDownloadURL();
      if (url != null) {
        isUploaded = true;
      }
      print(url);
    });
    setState(() {
      isUploading = false;
    });
    Navigator.popAndPushNamed(context, '/editProf');
  }

  dialogContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        gradient: new LinearGradient(
          colors: [
            UiConstants.primaryColor,
            UiConstants.primaryColor.withGreen(400),
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      height: SizeConfig.screenHeight * 0.5,
      width: SizeConfig.screenWidth,
      padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: SizeConfig.screenHeight * 0.2,
            width: SizeConfig.screenHeight * 0.2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
            ),
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
          SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: () {
              updatePicture(context);
              // .then((_) {
              //   if (isUploaded == true) {
              //     Navigator.pop(context);
              //   } else {
              //     print("Unable to upload");
              //     // Scaffold.of(context).showSnackBar(SnackBar(
              //     //   content: Text("Unable to upload, please try again"),
              //     // ));
              //   }
              // });
            },
            child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockSizeHorizontal * 10),
              height: 70,
              width: SizeConfig.screenWidth,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: isUploading
                    ? SpinKitThreeBounce(
                        color: UiConstants.spinnerColor2,
                        size: 18.0,
                      )
                    : Text(
                        "Change Profile Picture",
                        style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: SizeConfig.mediumTextSize),
                      ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockSizeHorizontal * 10),
              height: 70,
              width: SizeConfig.screenWidth,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: Text(
                  "Cancel",
                  style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: SizeConfig.mediumTextSize),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
