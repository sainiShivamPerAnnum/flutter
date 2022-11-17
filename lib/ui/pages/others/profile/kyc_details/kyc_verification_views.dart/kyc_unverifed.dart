import 'package:felloapp/base_util.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/dialogs/more_info_dialog.dart';
import 'package:felloapp/ui/pages/others/profile/kyc_details/kyc_details_view.dart';
import 'package:felloapp/ui/pages/others/profile/kyc_details/kyc_details_vm.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class KycUnVerifiedView extends StatelessWidget {
  final KYCDetailsViewModel model;
  const KycUnVerifiedView({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        model.capturedImage != null
            ? KycBriefTile(
                label: "Uploaded PAN Card",
                title: model.capturedImage!.name,
                model: model,
                subtitle: "${model.fileSize.toString()} MB",
                trailing: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: SizeConfig.padding12),
                  child: IconButton(
                    icon: Icon(Icons.delete_rounded),
                    color: Colors.red,
                    onPressed: () {
                      if (model.isUpdatingKycDetails) return;
                      Haptic.vibrate();
                      model.kycErrorMessage = null;
                      model.capturedImage = null;
                    },
                  ),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextFieldLabel("Upload your PAN Card"),
                  Container(
                    width: SizeConfig.screenWidth,
                    height: SizeConfig.screenWidth! / 2.5,
                    margin: EdgeInsets.only(top: SizeConfig.padding4),
                    child: Row(children: [
                      FileCaptureOption(
                        icon: Assets.ic_camera,
                        desc: "Use Camera",
                        padding: EdgeInsets.all(SizeConfig.padding12),
                        func: () async {
                          try {
                            model.capturedImage = await ImagePicker()
                                .pickImage(source: ImageSource.camera);
                            model.verifyImage();
                            if (model.capturedImage != null) {
                              Log(model.capturedImage!.path);
                            }
                          } catch (e) {
                            model.permissionFailureCount += 1;
                            print(e.runtimeType);
                            final Permission camera_permission =
                                Permission.camera;
                            final PermissionStatus camera_permission_status =
                                await camera_permission.status;
                            if (model.permissionFailureCount > 2)
                              return BaseUtil.openDialog(
                                isBarrierDismissible: true,
                                addToScreenStack: true,
                                hapticVibrate: true,
                                content: MoreInfoDialog(
                                  title: "Alert!",
                                  text:
                                      "Please grant camera access permission to continue.",
                                  btnText: "Grant Permission",
                                  onPressed: () async {
                                    await openAppSettings();
                                    AppState.backButtonDispatcher!
                                        .didPopRoute();
                                  },
                                ),
                              );
                            else if (camera_permission_status ==
                                PermissionStatus.denied) {
                              return BaseUtil.openDialog(
                                isBarrierDismissible: true,
                                addToScreenStack: true,
                                hapticVibrate: true,
                                content: MoreInfoDialog(
                                  title: "Alert!",
                                  text:
                                      "Please grant camera access permission to continue.",
                                ),
                              );
                            }
                          }
                        },
                        // func: () async {
                        //   final cameras = await availableCameras();
                        //   final firstCamera = cameras.first;
                        //   BaseUtil.openModalBottomSheet(
                        //     addToScreenStack: true,
                        //     isScrollControlled: true,
                        //     backgroundColor: UiConstants.kBackgroundColor,
                        //     content: TakePictureScreen(
                        //       camera: firstCamera,
                        //       model: model,
                        //     ),
                        //     hapticVibrate: true,
                        //     isBarrierDismissable: false,
                        //   );
                        // },
                      ),
                      SizedBox(width: SizeConfig.pageHorizontalMargins / 2),
                      FileCaptureOption(
                        icon: Assets.ic_upload_file,
                        desc: "Upload from device",
                        padding: EdgeInsets.all(SizeConfig.padding16),
                        func: () async {
                          model.capturedImage = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          model.verifyImage();
                          if (model.capturedImage != null) {
                            Log(model.capturedImage!.path);
                          }
                        },
                      ),
                    ]),
                  ),
                ],
              ),
        SizedBox(height: SizeConfig.padding10),
        Row(
          children: [
            AppTextFieldLabel("Max size: 5 MB", leftPadding: 0),
            SizedBox(
              width: SizeConfig.padding16,
            )
          ],
        ),
        AppTextFieldLabel("Formats: PNG, JPEG, JPG", leftPadding: 0),
        if (model.kycVerificationStatus == KycVerificationStatus.FAILED &&
            model.kycErrorMessage != null)
          Padding(
            padding: EdgeInsets.only(top: SizeConfig.padding8),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 0.5, color: Colors.red),
                borderRadius: BorderRadius.circular(SizeConfig.roundness12),
                color: Colors.red.withOpacity(0.05),
              ),
              padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins / 2),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                  ),
                  SizedBox(width: SizeConfig.padding16),
                  Expanded(
                    child: Text(
                      model.kycErrorMessage ??
                          'Something went wrong, please try again.',
                      maxLines: 2,
                      style: TextStyles.body3.colour(Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
