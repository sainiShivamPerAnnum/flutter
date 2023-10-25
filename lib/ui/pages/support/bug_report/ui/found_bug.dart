import 'dart:developer';
import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/dialogs/more_info_dialog.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class FoundBug extends StatefulWidget {
  const FoundBug({super.key});

  @override
  State<FoundBug> createState() => _FoundBugState();
}

class _FoundBugState extends State<FoundBug> {
  /// Create a text controller. Later, use it to retrieve the
  /// current value of the TextField.
  late TextEditingController _bugReasonController;

  /// Form Keys For Validating
  final _bugReasonFormKey = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();

  bool value = false;
  String? dropDownValue;
  String reason = "";
  String? errorMsg;
  String? dropDownErrorMsg;
  XFile? capturedImage;
  double? fileSize;

  @override
  void initState() {
    super.initState();
    _bugReasonController = TextEditingController();
  }

  final List<String> optionsList = [
    'Getting started',
    'Savings',
    'Autosave',
    'Withdrawals',
    'Rewards/Winnings',
    'Digital Gold',
    'Fello Flo',
    'Journey',
    'Login / SignUp',
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        AppState.removeOverlay();
        return true;
      },
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            top: SizeConfig.pageHorizontalMargins,
            left: SizeConfig.pageHorizontalMargins,
            right: SizeConfig.pageHorizontalMargins,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            color: const Color(0xff39393C),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(SizeConfig.roundness16),
              topRight: Radius.circular(SizeConfig.roundness16),
            ),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x29000000),
                  offset: Offset(0, -3),
                  blurRadius: 6,
                  spreadRadius: 0)
            ],
            // color: Colors.white,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Report a Bug", style: TextStyles.sourceSansSB.title5),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: SizeConfig.padding24,
                ),
                Text("Please select a category of the issue",
                    style: TextStyles.sourceSans.body3),
                SizedBox(
                  height: SizeConfig.padding8,
                ),
                Column(
                  children: [
                    DropdownButtonFormField<String>(
                      dropdownColor: UiConstants.kSecondaryBackgroundColor,
                      iconSize: SizeConfig.padding20,
                      decoration: InputDecoration(
                        border: (dropDownErrorMsg == null)
                            ? OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              )
                            : const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 1),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                  topLeft: Radius.circular(8),
                                ),
                              ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.padding10),
                        enabledBorder: (dropDownErrorMsg == null)
                            ? OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              )
                            : const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 1),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                  topLeft: Radius.circular(8),
                                ),
                              ),
                        filled: true,
                        fillColor: const Color(0xff1A1A1A),
                        focusedErrorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 1),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                            topLeft: Radius.circular(8),
                          ),
                        ),
                        errorStyle: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(
                                height: -10,
                                color: Colors.transparent,
                                fontSize: 0),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 1),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                            topLeft: Radius.circular(8),
                          ),
                        ),
                      ),
                      iconEnabledColor: UiConstants.kTextColor,
                      elevation: 0,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                      hint: Text(
                        'Select One',
                        style: TextStyles.sourceSans.body4
                            .colour(UiConstants.kTextColor),
                      ),
                      value: dropDownValue,
                      items: [
                        for (String option in optionsList)
                          DropdownMenuItem(
                            value: option,
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: SizeConfig.padding10,
                                  right: SizeConfig.padding10),
                              child: Text(
                                option,
                                style: TextStyles.sourceSans.body3
                                    .colour(Colors.white),
                              ),
                            ),
                          ),
                      ],
                      onChanged: (val) {
                        // if (_formKey.currentState?.validate() ?? false) {
                        setState(() {
                          dropDownValue = val;
                          dropDownErrorMsg = null;
                        });
                        // }
                      },
                      validator: (value) {
                        if (value == null) {
                          dropDownErrorMsg = "Please Choose One Option";
                          print("dropDownErrorMsg $dropDownErrorMsg");
                          return dropDownErrorMsg;
                        }
                        return null;
                      },
                    ),
                    if (dropDownErrorMsg != null)
                      const CommonInputErrorLabel(
                        errorMessage: "Please Choose One Option",
                      )
                  ],
                ),
                SizedBox(
                  height: SizeConfig.padding18,
                ),
                Text(
                  "How would you describe the bug?",
                  style: TextStyles.sourceSans.body3,
                ),
                SizedBox(
                  height: SizeConfig.padding8,
                ),
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xff1A1A1A),
                        borderRadius:
                            BorderRadius.circular(SizeConfig.padding8),
                      ),
                      child: TextFormField(
                        controller: _bugReasonController,
                        maxLines: 5,
                        onChanged: (val) {
                          if (_bugReasonFormKey.currentState?.validate() ??
                              false) {}
                          setState(() {
                            reason = val;
                            errorMsg = null;
                          });
                        },
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 3) {
                            errorMsg = "Please be more descriptive";
                            return errorMsg;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Start typing here...',
                          hintStyle: TextStyles.sourceSans.body3
                              .colour(Colors.white.withOpacity(0.5)),
                          focusedBorder: InputBorder.none,
                          border: (errorMsg == null)
                              ? OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                )
                              : const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 1),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                    topLeft: Radius.circular(8),
                                  ),
                                ),
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.all(SizeConfig.padding16),
                          focusedErrorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 1),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                              topLeft: Radius.circular(8),
                            ),
                          ),
                          errorStyle: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(
                                  height: -10,
                                  color: Colors.transparent,
                                  fontSize: 0),
                          errorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 1),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                              topLeft: Radius.circular(8),
                            ),
                          ),
                        ),
                        autofocus: false,
                        keyboardType: TextInputType.streetAddress,
                        style: TextStyles.sourceSans.body3.colour(
                          UiConstants.kTextColor,
                        ),
                      ),
                    ),
                    if (errorMsg != null)
                      const CommonInputErrorLabel(
                        errorMessage: 'Please be more descriptive',
                      )
                  ],
                ),
                SizedBox(
                  height: SizeConfig.padding18,
                ),
                // Text(
                //   "Attach Screenshot (Optional)",
                //   style: TextStyles.sourceSans.body3,
                // ),
                // SizedBox(
                //   height: SizeConfig.padding12,
                // ),
                // GestureDetector(
                //   onTap: () {
                //     fetchImage(ImageSource.gallery);
                //   },
                //   child: Container(
                //     width: SizeConfig.padding72,
                //     height: SizeConfig.padding72,
                //     decoration: BoxDecoration(
                //       borderRadius: const BorderRadius.all(Radius.circular(12)),
                //       border:
                //           Border.all(color: const Color(0xffcacaca), width: 1),
                //       color: const Color(0xff1A1A1A),
                //     ),
                //     child: Center(
                //       //Display captured image
                //       // how to do it
                //       //
                //       child: capturedImage != null
                //           ? FutureBuilder<List<int>>(
                //               future: capturedImage!.readAsBytes(),
                //               builder: (context, snapshot) {
                //                 if (snapshot.hasData) {
                //                   final bytes =
                //                       Uint8List.fromList(snapshot.data!);
                //                   return Image.memory(
                //                     bytes,
                //                     fit: BoxFit.cover,
                //                   );
                //                 } else if (snapshot.hasError) {
                //                   // Handle error case
                //                   return const Icon(
                //                     Icons.error,
                //                     color: Colors.white,
                //                     size: 35,
                //                   );
                //                 } else {
                //                   // Display a loading indicator while the image is being loaded
                //                   return const CircularProgressIndicator();
                //                 }
                //               },
                //             )
                //           : const Icon(
                //               Icons.add,
                //               color: Colors.white,
                //               size: 35,
                //             ),
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: SizeConfig.padding18,
                // ),
                AppPositiveBtn(
                  btnText: 'SUBMIT',
                  onPressed: () {
                    setState(() {});
                    if (_formKey.currentState?.validate() ?? false) {
                      openGmail(capturedImage);

                      AppState.backButtonDispatcher?.didPopRoute();

                      locator<AnalyticsService>().track(
                        eventName: AnalyticsEvents.reportBugSubmit,
                        properties: {
                          'category': dropDownValue,
                          'reason': reason,
                        },
                      );
                    }
                  },
                ),
                SizedBox(
                  height: SizeConfig.padding18,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> fetchImage(ImageSource source) async {
    try {
      capturedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      verifyImage();
    } catch (ex) {
      debugPrint("Exception => $ex");
      BaseUtil.showNegativeAlert(
          'Something went wrong!', 'Please try again later');
    }
  }

  void verifyImage() {
    S locale = locator<S>();
    if (capturedImage == null) return;
    final String ext = capturedImage!.name.split('.').last.toLowerCase();

    if (ext == 'png' || ext == 'jpg' || ext == 'jpeg') {
      File imageFile = File(capturedImage!.path);
      fileSize =
          BaseUtil.digitPrecision(imageFile.lengthSync() / 1048576, 2, true);
      print("File size: $fileSize");
      if ((fileSize ?? 0) > 5) {
        capturedImage = null;
        BaseUtil.openDialog(
            addToScreenStack: true,
            isBarrierDismissible: false,
            hapticVibrate: true,
            content: MoreInfoDialog(
                title: locale.invalidFile, text: locale.invalidFileSubtitle));
      } else {
        log("imageFile => $imageFile || fileSize => $fileSize");
      }

      setState(() {});
      return;
    } else {
      capturedImage = null;
      BaseUtil.openDialog(
          addToScreenStack: true,
          isBarrierDismissible: false,
          hapticVibrate: true,
          content: MoreInfoDialog(
              title: locale.invalidFile, text: locale.invalidFileSubtitle));
    }
  }

  Future<void> openGmail(XFile? imageFile) async {
    var recipientEmail = Uri.encodeComponent('support@fello.in');
    var subject = Uri.encodeComponent('Found Bug: $dropDownValue');
    var body = Uri.encodeComponent('Description:\n$reason');

    // Add the note text at the bottom of the email
    body +=
        '\n\n\nNote: You can attach media such as images or videos to your email.';

    log(subject);
    Uri mail = Uri.parse("mailto:$recipientEmail?subject=$subject&body=$body");

    if (await canLaunchUrl(mail)) {
      BaseUtil.showPositiveAlert('You can attach media in Gmail',
          'You can easily attach media, such as images or videos, to your Gmail App.');
      // add delay of 2 seconds
      await Future.delayed(const Duration(seconds: 2));
      await launchUrl(mail);
    } else {
      BaseUtil.openDialog(
        addToScreenStack: true,
        isBarrierDismissible: false,
        hapticVibrate: true,
        content: MoreInfoDialog(
          title: 'Email not found',
          text: 'Please set up an email account to use this feature.',
        ),
      );
    }
  }

  @override
  void dispose() {
    _bugReasonController.dispose();
    super.dispose();
  }
}

class CommonInputErrorLabel extends StatelessWidget {
  final String? errorMessage;

  const CommonInputErrorLabel({Key? key, this.errorMessage = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        decoration: const BoxDecoration(
            color: Color(0xFFfa6400),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10))),
        padding: const EdgeInsets.all(5),
        child: Text(
          errorMessage!,
          style: const TextStyle(
              color: Color(0xffffffff),
              fontWeight: FontWeight.w600,
              fontFamily: "Inter-Regular_",
              fontStyle: FontStyle.normal,
              fontSize: 10),
        ),
      ),
    );
  }
}
