import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/ui/elements/change_profile_picture_dialog.dart';
import 'package:felloapp/ui/elements/confirm_action_dialog.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'root.dart';

class EditProfile extends StatefulWidget {
  final String prevImage;
  EditProfile({this.prevImage});
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameFieldController;
  TextEditingController _emailFieldController;
  TextEditingController _ageFieldController;
  bool _isInitialized = false;
  static DBModel dbProvider;
  static BaseUtil baseProvider;
  File profilePic;
  RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  chooseprofilePicture() async {
    final temp = await ImagePicker().getImage(source: ImageSource.gallery);
    // if (temp != null) {
    //   HapticFeedback.vibrate();
    //   print("--------------------------------->" + temp.path);
    //   showDialog(
    //     context: context,
    //     builder: (BuildContext context) => ChangeProfilePicture(
    //       image: File(temp.path),
    //     ),
    //   );
    // }

    setState(() {
      profilePic = File(temp.path);
    });
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
    String imageName = profilePic.path.split("/").last;
    String targetPath = "${tempdir.path}/c-$imageName";
    print("temp path: " + targetPath);
    print("orignal path: " + profilePic.path);
    await testCompressAndGetFile(File(profilePic.path), targetPath);
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("dps/${baseProvider.myUser.uid}/image");
    UploadTask uploadTask = ref.putFile(File(targetPath));
    uploadTask.then((res) async {
      await res.ref.getDownloadURL().then((url) {
        if (url != null) {
          isUploaded = true;
          baseProvider.myUserDpUrl = url;
        }
        print(url);
      });
    });
    return isUploaded;
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      _isInitialized = true;
      baseProvider = Provider.of<BaseUtil>(context, listen: false);
      dbProvider = Provider.of<DBModel>(context, listen: false);
      _nameFieldController =
          (baseProvider.myUser != null && baseProvider.myUser.name != null)
              ? new TextEditingController(text: baseProvider.myUser.name)
              : new TextEditingController();
      _emailFieldController =
          (baseProvider.myUser != null && baseProvider.myUser.email != null)
              ? new TextEditingController(text: baseProvider.myUser.email)
              : new TextEditingController();
      _ageFieldController =
          (baseProvider.myUser != null && baseProvider.myUser.age != null)
              ? new TextEditingController(text: baseProvider.myUser.age)
              : new TextEditingController();
    }

    return WillPopScope(
      onWillPop: () async {
        var pName = _nameFieldController.text;
        var pEmail = _emailFieldController.text;
        var pAge = _ageFieldController.text;

        var curName = baseProvider.myUser.name;
        var curEmail = baseProvider.myUser.email;
        var curAge = baseProvider.myUser.age;

        bool noChanges = true;
        if (curName == null || pName != curName) noChanges = false;
        if (curEmail == null || pEmail != curEmail) noChanges = false;
        if (curAge == null || pAge != curAge) noChanges = false;
        if (profilePic != null) noChanges = false;

        if (!noChanges) {
          return (await showDialog(
            context: context,
            builder: (ctx) => ConfirmActionDialog(
              title: "You have unsaved changes here?",
              description: "Are you sure, you want to cancle?",
              buttonText: "Stay",
              confirmAction: () {
                Navigator.pop(context);
              },
              cancelAction: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ));
        }
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: BaseUtil.getAppBar(),
        body: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 24),
                  child: Container(
                    height: SizeConfig.screenHeight * 0.2,
                    width: SizeConfig.screenHeight * 0.2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                    child: Stack(
                      children: [
                        ClipOval(
                          child: profilePic != null
                              ? Image.file(
                                  profilePic,
                                  height: SizeConfig.screenHeight * 0.2,
                                  width: SizeConfig.screenHeight * 0.2,
                                  fit: BoxFit.cover,
                                )
                              : (widget.prevImage == null
                                  ? Image.asset(
                                      "images/profile.png",
                                      height: SizeConfig.screenHeight * 0.2,
                                      width: SizeConfig.screenHeight * 0.2,
                                      fit: BoxFit.cover,
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: widget.prevImage,
                                      height: SizeConfig.screenHeight * 0.2,
                                      width: SizeConfig.screenHeight * 0.2,
                                      fit: BoxFit.cover,
                                    )),
                        ),
                        Positioned(
                          bottom: SizeConfig.screenHeight * 0.02,
                          left: SizeConfig.screenHeight * 0.05,
                          child: GestureDetector(
                            onTap: chooseprofilePicture,
                            child: Container(
                              height: SizeConfig.screenHeight * 0.05,
                              width: SizeConfig.screenHeight * 0.1,
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(100)),
                              child: Center(
                                child: Text(
                                  "Edit",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontSize: SizeConfig.mediumTextSize,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 18.0),
                  child: TextFormField(
                    controller: _nameFieldController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      return value.isEmpty ? 'Please enter your name' : null;
                    },
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).nextFocus();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 18.0),
                  child: TextFormField(
                    controller: _emailFieldController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      //hintText: 'Email(optional)',
                      //errorText: _validate ? null : "Invalid!",
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      print(value);
                      return (value != null &&
                              value.isNotEmpty &&
                              emailRegex.hasMatch(value))
                          ? null
                          : 'Please enter a valid email';
                    },
//                        onChanged: (value) {
                    //this._email = value;
//                    if(!_validate) setState(() {
//                      _validate = true;
//                    });
//                        },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 18.0),
                  child: TextFormField(
                    controller: _ageFieldController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Age',
                      prefixIcon: Icon(Icons.perm_contact_calendar),
                    ),
                    validator: (value) {
                      print(value);
                      return (value != null && value.isNotEmpty)
                          ? null
                          : 'Please enter your age';
                    },
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).nextFocus();
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      new Container(
                        width: MediaQuery.of(context).size.width - 50,
                        height: 50.0,
                        decoration: BoxDecoration(
                          gradient: new LinearGradient(
                              colors: [
                                UiConstants.primaryColor,
                                UiConstants.primaryColor.withBlue(200),
                              ],
                              begin: Alignment(0.5, -1.0),
                              end: Alignment(0.5, 1.0)),
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                        child: new Material(
                          child: MaterialButton(
                            child: (!baseProvider.isLoginNextInProgress)
                                ? Text(
                                    'UPDATE',
                                    style: Theme.of(context)
                                        .textTheme
                                        .button
                                        .copyWith(color: Colors.white),
                                  )
                                : SpinKitThreeBounce(
                                    color: UiConstants.spinnerColor2,
                                    size: 18.0,
                                  ),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                // baseProvider.firebaseUser = await FirebaseAuth.instance.currentUser();
                                var pName = _nameFieldController.text;
                                var pEmail = _emailFieldController.text;
                                var pAge = _ageFieldController.text;

                                var curName = baseProvider.myUser.name;
                                var curEmail = baseProvider.myUser.email;
                                var curAge = baseProvider.myUser.age;

                                bool noChanges = true;
                                if (curName == null || pName != curName)
                                  noChanges = false;
                                if (curEmail == null || pEmail != curEmail)
                                  noChanges = false;
                                if (curAge == null || pAge != curAge)
                                  noChanges = false;
                                if (profilePic != null) noChanges = false;

                                if (noChanges) {
                                  baseProvider.showNegativeAlert('No Update',
                                      'No changes were made', context);

                                  return;
                                } else {
                                  baseProvider.myUser.name = pName;
                                  baseProvider.myUser.email = pEmail;
                                  baseProvider.myUser.age = pAge;
                                  if (profilePic != null) {
                                    updatePicture(context).then((flag) {
                                      if (flag) {
                                        baseProvider.showPositiveAlert(
                                            'Complete',
                                            'Your profile Picture have been updated',
                                            context);
                                      } else {
                                        baseProvider.showNegativeAlert(
                                            'Failed',
                                            'Your Profile Picture could not be updated at the moment',
                                            context);
                                      }
                                    });
                                  }

                                  dbProvider
                                      .updateUser(baseProvider.myUser)
                                      .then((flag) {
                                    if (flag) {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (ctx) => Root()));
                                      baseProvider.showPositiveAlert(
                                          'Complete',
                                          'Your details have been updated',
                                          context);
                                    } else {
                                      baseProvider.showNegativeAlert(
                                          'Failed',
                                          'Your details could not be updated at the moment',
                                          context);
                                    }
                                  });
                                }
                              }
                            },
                            highlightColor: Colors.white30,
                            splashColor: Colors.white30,
                          ),
                          color: Colors.transparent,
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Text("Profile Picture will be updated after a restart of app"),
              ],
            )),
      ),
    );
  }
}
