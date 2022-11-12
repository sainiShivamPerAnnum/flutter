import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/profile/kyc_details/kyc_details_vm.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/ui/widgets/appbar/appbar.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

getKycView(KYCDetailsViewModel model) {
  switch (model.kycVerificationStatus) {
    case KycVerificationStatus.VERIFIED:
      return KycSuccessView(model: model);
    case KycVerificationStatus.UNVERIFIED:
      return KycUnVerifiedView(model: model);
    case KycVerificationStatus.INPROCESS:
      return KycInProcessView(model: model);
    case KycVerificationStatus.FAILED:
      return KycFailedView(model: model);
  }
}

class KYCDetailsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom !=
        SizeConfig.viewInsets.bottom;

    S locale = S.of(context);
    return BaseView<KYCDetailsViewModel>(
      onModelReady: (model) {
        model.init();
      },
      builder: (ctx, model, child) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: FAppBar(
          type: FaqsType.yourAccount,
          title: 'Add KYC Details',
          backgroundColor: UiConstants.kSecondaryBackgroundColor,
          showAvatar: false,
          showCoinBar: false,
          showHelpButton: false,
        ),
        backgroundColor: UiConstants.kBackgroundColor,
        body: model.state == ViewState.Busy
            ? Center(
                child: FullScreenLoader(),
              )
            : Padding(
                padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextFieldLabel(
                      locale.pkPanLabel,
                    ),
                    AppTextField(
                      focusNode: model.panFocusNode,
                      inputFormatters: [
                        // UpperCaseTextFormatter(),
                        FilteringTextInputFormatter.deny(RegExp(r'^0+(?!$)')),
                        LengthLimitingTextInputFormatter(10)
                      ],
                      textCapitalization: TextCapitalization.characters,
                      keyboardType: model.panTextInputType,
                      onChanged: (val) {
                        print("val changed");
                        model.checkForKeyboardChange(val.trim());
                      },
                      isEnabled: model.inEditMode,
                      textEditingController: model.panController,
                      validator: (String value) {
                        return '';
                      },
                    ),
                    SizedBox(height: SizeConfig.padding24),
                    AppTextFieldLabel(locale.kycNameLabel),
                    AppTextField(
                      focusNode: model.kycNameFocusNode,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]'))
                      ],
                      // textCapitalization: TextCapitalization.characters,
                      isEnabled: model.inEditMode,
                      textEditingController: model.nameController,
                      validator: (String value) {
                        return '';
                      },
                      keyboardType: TextInputType.name,
                    ),
                    SizedBox(height: SizeConfig.padding24),
                    getKycView(model),
                    !isKeyboardOpen
                        ? Spacer()
                        : SizedBox(
                            height: SizeConfig.padding32,
                          ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          vertical: SizeConfig.pageHorizontalMargins),
                      padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.padding16,
                          horizontal: SizeConfig.padding20),
                      decoration: BoxDecoration(
                        color: UiConstants.kBackgroundColor3,
                        borderRadius: BorderRadius.all(
                            Radius.circular(SizeConfig.roundness12)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            "assets/svg/safety_asset.svg",
                            width: SizeConfig.padding20,
                          ),
                          SizedBox(
                            width: SizeConfig.padding14,
                          ),
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'This is required to securely verify your identity.',
                                style: TextStyles.sourceSans.body3
                                    .colour(UiConstants.kTextColor2),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    model.hasDetails
                        ? SizedBox()
                        : model.inEditMode
                            ? ReactivePositiveAppButton(
                                onPressed: () async {
                                  model.panFocusNode.unfocus();
                                  await model.onSubmit(context);
                                },
                                btnText: locale.btnSumbit,
                                width: SizeConfig.screenWidth,
                              )
                            : AppPositiveBtn(
                                btnText: 'Update',
                                onPressed: () => model.inEditMode = true,
                              ),
                    SizedBox(height: SizeConfig.padding10),
                  ],
                ),
              ),
      ),
    );
  }
}

class KycSuccessView extends StatelessWidget {
  final KYCDetailsViewModel model;

  const KycSuccessView({Key key, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KycBriefTile(
      title: "PAN Verified",
      model: model,
      trailing: Icon(
        Icons.check_box_outline_blank_rounded,
        color: UiConstants.primaryColor,
      ),
    );
  }
}

class KycFailedView extends StatelessWidget {
  final KYCDetailsViewModel model;

  const KycFailedView({Key key, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KycBriefTile(
      title: "PAN Verification Failed",
      model: model,
      trailing: Icon(
        Icons.reset_tv,
        color: Colors.red,
      ),
    );
  }
}

class KycInProcessView extends StatelessWidget {
  final KYCDetailsViewModel model;
  const KycInProcessView({Key key, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KycBriefTile(
      title: "PAN Verification in Process",
      model: model,
      trailing: Icon(
        Icons.hourglass_bottom_rounded,
        color: UiConstants.tertiarySolid,
      ),
    );
  }
}

class KycUnVerifiedView extends StatelessWidget {
  final KYCDetailsViewModel model;
  const KycUnVerifiedView({Key key, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        model.capturedImage != null
            ? KycBriefTile(
                title: "Upload your PAN Card",
                model: model,
                trailing: IconButton(
                  icon: Icon(Icons.delete_rounded),
                  color: Colors.red,
                  onPressed: () {
                    model.capturedImage = null;
                  },
                ),
              )
            : Container(
                width: SizeConfig.screenWidth,
                height: SizeConfig.screenWidth / 2.5,
                child: Row(children: [
                  FileCaptureOption(
                    icon: Icon(Icons.camera_alt_rounded,
                        color: UiConstants.tertiarySolid),
                    desc: "Use Camera",
                    func: () async {
                      final cameras = await availableCameras();
                      final firstCamera = cameras.first;
                      BaseUtil.openModalBottomSheet(
                        addToScreenStack: true,
                        backgroundColor: UiConstants.kBackgroundColor,
                        content: TakePictureScreen(
                          camera: firstCamera,
                          model: model,
                        ),
                        hapticVibrate: true,
                        isBarrierDismissable: false,
                      );
                    },
                  ),
                  SizedBox(width: SizeConfig.pageHorizontalMargins / 2),
                  FileCaptureOption(
                    icon: Icon(Icons.file_upload_outlined,
                        color: UiConstants.primaryColor),
                    desc: "Upload from device",
                    func: () async {
                      model.capturedImage = await ImagePicker().pickImage(
                          source: ImageSource.gallery, imageQuality: 45);
                      if (model.capturedImage != null) {
                        log(model.capturedImage.path);
                      }
                    },
                  ),
                ]),
              ),
        AppTextFieldLabel("Max size: 5 MB"),
        AppTextFieldLabel("Formats: PNG, JPEG, JPG"),
      ],
    );
  }
}

class KycBriefTile extends StatelessWidget {
  const KycBriefTile(
      {Key key,
      @required this.model,
      @required this.trailing,
      @required this.title})
      : super(key: key);

  final KYCDetailsViewModel model;
  final Widget trailing;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextFieldLabel(
          title,
          leftPadding: 0,
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.pageHorizontalMargins,
            vertical: SizeConfig.padding20,
          ),
          decoration: BoxDecoration(
            color: UiConstants.kBackgroundColor3,
            borderRadius: BorderRadius.circular(SizeConfig.roundness8),
          ),
          child: ListTile(
              leading: Icon(
                Icons.check_circle_outline_rounded,
                color: UiConstants.primaryColor,
              ),
              title: FittedBox(
                child: Text(
                  model.capturedImage.name,
                  style: TextStyles.sourceSansSB.body2.colour(Colors.white),
                ),
              ),
              trailing: trailing),
        ),
      ],
    );
  }
}

class FileCaptureOption extends StatelessWidget {
  final Icon icon;
  final String desc;
  final Function func;
  const FileCaptureOption({
    Key key,
    @required this.icon,
    @required this.desc,
    @required this.func,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onDoubleTap: func,
        child: Container(
          decoration: BoxDecoration(
            color: UiConstants.kBackgroundColor3,
            borderRadius: BorderRadius.circular(SizeConfig.roundness8),
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              padding: EdgeInsets.all(SizeConfig.padding12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                shape: BoxShape.circle,
                color: UiConstants.kBackgroundColor2,
              ),
              child: IconButton(
                icon: icon,
                onPressed: () => func(),
              ),
            ),
            SizedBox(height: SizeConfig.padding8),
            Text(
              desc,
              style: TextStyles.body3.colour(UiConstants.kTextColor2),
            )
          ]),
        ),
      ),
    );
  }
}

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    Key key,
    @required this.model,
    @required this.camera,
  });

  final CameraDescription camera;
  final KYCDetailsViewModel model;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // If the Future is complete, display the preview.
              return Expanded(
                  child: Container(
                      width: SizeConfig.screenWidth,
                      child: CameraPreview(_controller)));
            } else {
              // Otherwise, display a loading indicator.
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        AppPositiveBtn(
          btnText: 'Capture',
          onPressed: () async {
            // Take the Picture in a try / catch block. If anything goes wrong,
            // catch the error.
            try {
              // Ensure that the camera is initialized.
              await _initializeControllerFuture;

              // Attempt to take a picture and get the file `image`
              // where it was saved.
              widget.model.capturedImage = await _controller.takePicture();

              if (!mounted) return;
              AppState.backButtonDispatcher.didPopRoute();
            } catch (e) {
              // If an error occurs, log the error to the console.
              print(e);
            }
          },
        )
      ]),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, @required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}
