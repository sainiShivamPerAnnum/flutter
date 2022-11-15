import 'package:camera/camera.dart';
import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/profile/kyc_details/kyc_details_vm.dart';
import 'package:felloapp/ui/pages/others/profile/kyc_details/kyc_verification_views.dart/kyc_error.dart';
import 'package:felloapp/ui/pages/others/profile/kyc_details/kyc_verification_views.dart/kyc_pending.dart';
import 'package:felloapp/ui/pages/others/profile/kyc_details/kyc_verification_views.dart/kyc_success.dart';
import 'package:felloapp/ui/pages/others/profile/kyc_details/kyc_verification_views.dart/kyc_unverifed.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/ui/widgets/appbar/appbar.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

    case KycVerificationStatus.FAILED:
      return KycUnVerifiedView(model: model);
    case KycVerificationStatus.NONE:
      return NoKycView(model: model);
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
                    getKycView(model),
                    Spacer(),
                    model.kycVerificationStatus ==
                                KycVerificationStatus.UNVERIFIED ||
                            model.kycVerificationStatus ==
                                KycVerificationStatus.FAILED
                        ? Column(
                            children: [
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
                              model.isUpdatingKycDetails
                                  ? LinearProgressIndicator(
                                      backgroundColor: Colors.black,
                                    )
                                  : AppPositiveBtn(
                                      onPressed: () async {
                                        // model.panFocusNode.unfocus();
                                        await model.onSubmit(context);
                                      },
                                      btnText: locale.btnSumbit,
                                      width: SizeConfig.screenWidth,
                                    ),
                            ],
                          )
                        : SizedBox(),
                    SizedBox(height: SizeConfig.padding10),
                  ],
                ),
              ),
      ),
    );
  }
}

class KycBriefTile extends StatelessWidget {
  const KycBriefTile(
      {Key key,
      @required this.model,
      @required this.trailing,
      @required this.label,
      this.subtitle,
      @required this.title})
      : super(key: key);

  final KYCDetailsViewModel model;
  final Widget trailing;
  final String title;
  final String label;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextFieldLabel(label),
        Container(
          width: SizeConfig.screenWidth,
          padding: EdgeInsets.symmetric(
            vertical: SizeConfig.padding24,
          ),
          decoration: BoxDecoration(
            color: UiConstants.kBackgroundColor3,
            borderRadius: BorderRadius.circular(SizeConfig.roundness8),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(SizeConfig.padding12),
                width: SizeConfig.avatarRadius * 4,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  shape: BoxShape.circle,
                  color: Colors.black,
                ),
                child: SvgPicture.asset(
                  Assets.ic_upload_success,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title ?? "",
                      style: TextStyles.sourceSansSB.body2.colour(Colors.white),
                    ),
                    if (subtitle != null)
                      Padding(
                        padding: EdgeInsets.only(top: SizeConfig.padding6),
                        child: Text(
                          subtitle,
                          style:
                              TextStyles.body3.colour(UiConstants.kTextColor2),
                        ),
                      )
                  ],
                ),
              ),
              trailing
            ],
          ),
        )
        // Container(
        //   padding: EdgeInsets.symmetric(
        //     vertical: SizeConfig.padding20,
        //   ),
        //   decoration: BoxDecoration(
        //     color: UiConstants.kBackgroundColor3,
        //     borderRadius: BorderRadius.circular(SizeConfig.roundness8),
        //   ),
        //   child: ListTile(
        //       leading: Icon(
        //         Icons.check_circle_outline_rounded,
        //         color: UiConstants.primaryColor,
        //         size: SizeConfig.avatarRadius * 1.6,
        //       ),
        //       title: Text(
        //         title ?? model.capturedImage.name,
        //         maxLines: 2,
        //         style: TextStyles.sourceSansSB.body2.colour(Colors.white),
        //       ),
        //       subtitle: model.fileSize != null
        //           ? Text('Size: ${model.fileSize}',
        //               style: TextStyles.body3.colour(UiConstants.kTextColor3))
        //           : SizedBox(),
        //       trailing: trailing),
        // ),
      ],
    );
  }
}

class FileCaptureOption extends StatelessWidget {
  final String icon;
  final String desc;
  final Function func;
  const FileCaptureOption({
    Key key,
    @required this.icon,
    this.desc,
    @required this.func,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          Haptic.vibrate();
          func();
        },
        highlightColor: Colors.white,
        child: Container(
          decoration: BoxDecoration(
            color: UiConstants.kBackgroundColor3,
            borderRadius: BorderRadius.circular(SizeConfig.roundness8),
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              padding: EdgeInsets.all(SizeConfig.padding12),
              width: SizeConfig.avatarRadius * 4,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                shape: BoxShape.circle,
                color: Colors.black,
              ),
              child: SvgPicture.asset(
                icon,
              ),
            ),
            if (desc != null)
              Padding(
                padding: EdgeInsets.only(top: SizeConfig.padding8),
                child: Text(
                  desc,
                  style: TextStyles.body3.colour(UiConstants.kTextColor2),
                ),
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
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(SizeConfig.roundness24),
        topRight: Radius.circular(SizeConfig.roundness24),
      ),
      child: Container(
        height: SizeConfig.screenHeight * 0.8,
        child: Column(children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // If the Future is complete, display the preview.
                return Expanded(
                  child: Stack(
                    children: [
                      Container(
                          height: SizeConfig.screenHeight * 0.8,
                          child: CameraPreview(_controller)),
                      Align(
                        alignment: Alignment.center,
                        child: CustomPaint(
                          size: Size(
                              SizeConfig.screenWidth * 0.8,
                              (SizeConfig.screenWidth * 0.8 * 0.588)
                                  .toDouble()),
                          painter: RPSCustomPainter(),
                        ),
                      ),
                      Align(
                          alignment: Alignment.topLeft,
                          child: SafeArea(
                            minimum: EdgeInsets.all(
                                SizeConfig.pageHorizontalMargins),
                            child: CircleAvatar(
                              backgroundColor: Colors.black,
                              child: IconButton(
                                icon: Icon(Icons.arrow_back),
                                color: Colors.white,
                                onPressed: () {
                                  Haptic.vibrate();
                                  AppState.backButtonDispatcher.didPopRoute();
                                },
                              ),
                            ),
                          ))
                    ],
                  ),
                );
              } else {
                // Otherwise, display a loading indicator.
                return Expanded(
                  child: Container(
                    color: Colors.black,
                    child: SpinKitThreeBounce(
                      color: UiConstants.primaryColor,
                      size: SizeConfig.padding32,
                    ),
                  ),
                );
              }
            },
          ),
          AppPositiveBtn(
            btnText: 'Capture',
            onPressed: () async {
              // Take the Picture in a try / catch block. If anything goes wrong,
              // catch the error.
              try {
                Haptic.vibrate();
                // Ensure that the camera is initialized.
                await _initializeControllerFuture;

                // Attempt to take a picture and get the file `image`
                // where it was saved.
                widget.model.capturedImage = await _controller.takePicture();
                widget.model.verifyImage();
                if (!mounted) return;
                AppState.backButtonDispatcher.didPopRoute();
              } catch (e) {
                // If an error occurs, log the error to the console.
                print(e);
              }
            },
          )
        ]),
      ),
    );
  }
}

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.01372541, size.height * 0.2443188);
    path_0.cubicTo(
        size.width * 0.01372545,
        size.height * 0.01704545,
        size.width * -0.007843216,
        size.height * 0.01704580,
        size.width * 0.2039216,
        size.height * 0.01704580);

    Paint paint_0_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.01960784;
    paint_0_stroke.color = Color(0xff60BF8B).withOpacity(1.0);
    paint_0_stroke.strokeJoin = StrokeJoin.round;
    canvas.drawPath(path_0, paint_0_stroke);

    Paint paint_0_fill = Paint()..style = PaintingStyle.stroke;
    paint_0_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.01372541, size.height * 0.7556818);
    path_1.cubicTo(
        size.width * 0.01372545,
        size.height * 0.9829545,
        size.width * -0.007843216,
        size.height * 0.9829545,
        size.width * 0.2039216,
        size.height * 0.9829545);

    Paint paint_1_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.01960784;
    paint_1_stroke.color = Color(0xff60BF8B).withOpacity(1.0);
    paint_1_stroke.strokeJoin = StrokeJoin.round;
    canvas.drawPath(path_1, paint_1_stroke);

    Paint paint_1_fill = Paint()..style = PaintingStyle.stroke;
    paint_1_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_1, paint_1_fill);

    Path path_2 = Path();
    path_2.moveTo(size.width * 0.9876157, size.height * 0.2443188);
    path_2.cubicTo(
        size.width * 0.9876157,
        size.height * 0.01704545,
        size.width * 1.009184,
        size.height * 0.01704580,
        size.width * 0.7974196,
        size.height * 0.01704580);

    Paint paint_2_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.01960784;
    paint_2_stroke.color = Color(0xff60BF8B).withOpacity(1.0);
    paint_2_stroke.strokeJoin = StrokeJoin.round;
    canvas.drawPath(path_2, paint_2_stroke);

    Paint paint_2_fill = Paint()..style = PaintingStyle.stroke;
    paint_2_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_fill);

    Path path_3 = Path();
    path_3.moveTo(size.width * 0.9876157, size.height * 0.7556818);
    path_3.cubicTo(
        size.width * 0.9876157,
        size.height * 0.9829545,
        size.width * 1.009184,
        size.height * 0.9829545,
        size.width * 0.7974196,
        size.height * 0.9829545);

    Paint paint_3_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.01960784;
    paint_3_stroke.color = Color(0xff60BF8B).withOpacity(1.0);
    paint_3_stroke.strokeJoin = StrokeJoin.round;
    canvas.drawPath(path_3, paint_3_stroke);

    Paint paint_3_fill = Paint()..style = PaintingStyle.stroke;
    paint_3_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_3, paint_3_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
