import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_analytics.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/main.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/change_profile_picture_dialog.dart';
import 'package:felloapp/ui/elements/confirm_action_dialog.dart';
import 'package:felloapp/ui/pages/login/screens/Field-Container.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-elements/input_field.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../root.dart';

class EditProfile extends StatefulWidget {
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
  AppState appState;
  File profilePic;
  int gender = 1;
  bool isPlayer = false;
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
      AppState.unsavedChanges = true;
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
          baseProvider.isProfilePictureUpdated = true;
          baseProvider.myUserDpUrl = url;
        }
        print(url);
      });
    });
    return isUploaded;
  }

  static DateTime selectedDate = DateTime.now();
  TextEditingController _dateController = new TextEditingController(
      text: '${selectedDate.toLocal()}'.split(' ')[0]);

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1940, 8),
        lastDate: DateTime(2101),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: UiConstants.primaryColor,
                onPrimary: Colors.black,
                surface: UiConstants.primaryColor,
                onSurface: Colors.black,
              ),
              dialogBackgroundColor: Colors.blueGrey[50],
            ),
            child: child,
          );
        });
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
  }

  @override
  Widget build(BuildContext context) {
    appState = Provider.of<AppState>(context, listen: false);
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
    double picSize = SizeConfig.screenWidth * 0.36;

    return WillPopScope(
      onWillPop: () async {
        print("Hello frandsssss");
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

        if (!noChanges) {}
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.blockSizeHorizontal * 5),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: kToolbarHeight / 3,
                    ),
                    InkWell(
                      onTap: () => backButtonDispatcher.didPopRoute(),
                      child: Icon(
                        Icons.arrow_back_rounded,
                        size: SizeConfig.cardTitleTextSize,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        "Edit Profile",
                        style: TextStyle(
                          fontSize: SizeConfig.cardTitleTextSize,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      child: Container(
                        height: picSize,
                        width: picSize,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: UiConstants.primaryColor, width: 4)),
                        child: Stack(
                          children: [
                            Center(
                              child: ClipOval(
                                child: profilePic != null
                                    ? Image.file(
                                        profilePic,
                                        height: picSize,
                                        width: picSize,
                                        fit: BoxFit.cover,
                                      )
                                    : (baseProvider.myUserDpUrl == null
                                        ? CachedNetworkImage(
                                            imageUrl:
                                                "https://cdn3.vectorstock.com/i/thumbs/93/47/flat-user-icon-member-sign-avatar-button-vector-13229347.jpg",
                                            fit: BoxFit.cover,
                                            height: picSize,
                                            width: picSize,
                                          )
                                        : CachedNetworkImage(
                                            imageUrl: baseProvider.myUserDpUrl,
                                            height: picSize,
                                            width: picSize,
                                            fit: BoxFit.cover,
                                          )),
                              ),
                            ),
                            //Container(
                            // decoration: BoxDecoration(
                            //   shape: BoxShape.circle,
                            //   color: Colors.black.withOpacity(0.2),
                            // ),
                            //child:
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: InkWell(
                                onTap: () => showDialog(
                                    context: context,
                                    builder: (ctx) {
                                      return ConfirmActionDialog(
                                          title: "Permission",
                                          description:
                                              "We need your gallery access in order to complete this process. Kindly provide the permission.",
                                          buttonText: "Continue",
                                          asset: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8),
                                            child: Lottie.asset(
                                                "images/lottie/storage-permission.json",
                                                height: SizeConfig.screenWidth *
                                                    0.3),
                                          ),
                                          confirmAction: () {
                                            Navigator.pop(context);
                                            chooseprofilePicture();
                                          },
                                          cancelAction: () =>
                                              Navigator.pop(context));
                                    }),
                                child: CircleAvatar(
                                  backgroundColor: UiConstants.primaryColor,
                                  child: Icon(
                                    Icons.photo_camera_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            //),
                            // Positioned(
                            //   bottom: SizeConfig.screenHeight * 0.02,
                            //   left: SizeConfig.screenHeight * 0.05,
                            //   child: GestureDetector(
                            //     onTap: chooseprofilePicture,
                            //     child: Container(
                            //       height: SizeConfig.screenHeight * 0.05,
                            //       width: SizeConfig.screenHeight * 0.1,
                            //       decoration: BoxDecoration(
                            //           color: Colors.black.withOpacity(0.8),
                            //           borderRadius: BorderRadius.circular(100)),
                            //       child: Center(
                            //         child: Text(
                            //           "Edit",
                            //           textAlign: TextAlign.center,
                            //           style: TextStyle(
                            //             color: Colors.white,
                            //             fontSize: SizeConfig.mediumTextSize,
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Text(
                      "Name",
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextFormField(
                      controller: _nameFieldController,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        fontSize: SizeConfig.largeTextSize,
                        fontWeight: FontWeight.w700,
                      ),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: UiConstants.primaryColor),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: UiConstants.primaryColor),
                        ),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        border: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: UiConstants.primaryColor),
                        ),
                      ),
                      onChanged: (val) {
                        AppState.unsavedChanges = true;
                      },
                      validator: (value) {
                        return value.isEmpty ? 'Please enter your name' : null;
                      },
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).nextFocus();
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //Text("Email"),
                    //                   TextFormField(
                    //                     controller: _emailFieldController,
                    //                     keyboardType: TextInputType.emailAddress,
                    //                     decoration: InputDecoration(
                    //                       //hintText: 'Email(optional)',
                    //                       //errorText: _validate ? null : "Invalid!",
                    //                       labelText: 'Email',
                    //                       focusColor: UiConstants.primaryColor,
                    //                       border: OutlineInputBorder(
                    //                         borderRadius: BorderRadius.circular(10),
                    //                       ),
                    //                       prefixIcon: Icon(Icons.email),
                    //                     ),
                    //                     onChanged: (val) {
                    //                       AppState.unsavedChanges = true;
                    //                     },
                    //                     validator: (value) {
                    //                       print(value);
                    //                       return (value != null &&
                    //                               value.isNotEmpty &&
                    //                               emailRegex.hasMatch(value))
                    //                           ? null
                    //                           : 'Please enter a valid email';
                    //                     },
                    // //                        onChanged: (value) {
                    //                     //this._email = value;
                    // //                    if(!_validate) setState(() {
                    // //                      _validate = true;
                    // //                    });
                    // //                        },
                    //                   ),
                    //                   SizedBox(
                    //                     height: 20,
                    //                   ),
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 18.0),
                    //   child: TextFormField(
                    //     controller: _ageFieldController,
                    //     keyboardType: TextInputType.number,
                    //     decoration: InputDecoration(
                    //       labelText: 'Age',
                    //       prefixIcon: Icon(Icons.perm_contact_calendar),
                    //     ),
                    //     validator: (value) {
                    //       print(value);
                    //       return (value != null && value.isNotEmpty)
                    //           ? null
                    //           : 'Please enter your age';
                    //     },
                    //     onFieldSubmitted: (v) {
                    //       FocusScope.of(context).nextFocus();
                    //     },
                    //   ),
                    // ),
                    //Text("Date of Birth"),
                    // InkWell(
                    //   onTap: () {
                    //     _selectDate(context);
                    //   },
                    //   child: TextFormField(
                    //     textAlign: TextAlign.start,
                    //     enabled: false,
                    //     keyboardType: TextInputType.text,
                    //     validator: (value) {
                    //       return null;
                    //     },
                    //     controller: _dateController,
                    //     decoration: InputDecoration(
                    //       focusColor: UiConstants.primaryColor,
                    //       border: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(10),
                    //       ),
                    //       labelText: 'DOB',
                    //       hintText: 'Enter Date',
                    //       prefixIcon: Icon(
                    //         Icons.calendar_today,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    // InputField(
                    //   child: DropdownButtonHideUnderline(
                    //     child: DropdownButton(
                    //         value: gender,
                    //         items: [
                    //           DropdownMenuItem(
                    //             child: Text(
                    //               "Male",
                    //               style: TextStyle(),
                    //             ),
                    //             value: 1,
                    //           ),
                    //           DropdownMenuItem(
                    //             child: Text(
                    //               "Female",
                    //               style: TextStyle(),
                    //             ),
                    //             value: 2,
                    //           ),
                    //           DropdownMenuItem(
                    //               child: Text(
                    //                 "Rather Not Say",
                    //                 style: TextStyle(),
                    //               ),
                    //               value: 3),
                    //         ],
                    //         onChanged: (value) {
                    //           gender = value;
                    //           //   isLoading = true;
                    //           setState(() {});
                    //           //   filterTransactions();
                    //         }),
                    //   ),
                    // ),
                    // Container(
                    //   margin: EdgeInsets.only(bottom: 25),
                    //   child: Row(
                    //     children: [
                    //       Spacer(),
                    //       Text("Ever invested in Mutual Funds?"),
                    //       SizedBox(
                    //         width: 20,
                    //       ),
                    //       Switch.adaptive(
                    //           value: isPlayer,
                    //           activeColor: UiConstants.primaryColor,
                    //           onChanged: (val) {
                    //             setState(() {
                    //               isPlayer = val;
                    //             });
                    //           }),
                    //       // Spacer(),
                    //     ],
                    //   ),
                    // ),
                    new Container(
                      height: 50.0,
                      width: double.infinity,
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
                          child: (!baseProvider.isEditProfileNextInProgress)
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
                              FocusScope.of(context).unfocus();
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
                                BaseAnalytics.logUserProfile(
                                    baseProvider.myUser);
                                if (profilePic != null) {
                                  updatePicture(context).then((flag) {
                                    if (flag) {
                                      BaseAnalytics.logProfilePictureAdded();
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
                                    // Navigator.pushReplacement(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (ctx) => Root(),
                                    //   ),
                                    // );
                                    AppState.unsavedChanges = false;
                                    baseProvider.showPositiveAlert(
                                        'Complete',
                                        'Your details have been updated',
                                        context);

                                    appState.currentAction = PageAction(
                                      state: PageState.pop,
                                    );
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
                    Spacer(),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
