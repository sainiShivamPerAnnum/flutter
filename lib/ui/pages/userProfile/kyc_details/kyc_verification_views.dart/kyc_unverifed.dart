import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/service/notifier_services/internal_ops_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/dialogs/more_info_dialog.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/userProfile/kyc_details/kyc_details_view.dart';
import 'package:felloapp/ui/pages/userProfile/kyc_details/kyc_details_vm.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class KycUnVerifiedView extends StatelessWidget {
  final KYCDetailsViewModel model;
  const KycUnVerifiedView({required this.model, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        model.capturedImage != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    locale.kycPanUpload,
                    style: TextStyles.sourceSansM.body2,
                  ),
                  SizedBox(height: SizeConfig.padding8),
                  KycBriefTile(
                    title: model.capturedImage!.name,
                    model: model,
                    subtitle:
                        "${model.fileSize.toString()} ${locale.mb.toUpperCase()}",
                    trailing: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.padding12),
                      child: IconButton(
                        icon: const Icon(Icons.delete_rounded),
                        color: Colors.red,
                        onPressed: () {
                          if (model.isUpdatingKycDetails) return;
                          Haptic.vibrate();
                          model.kycErrorMessage = null;
                          model.capturedImage = null;
                        },
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    locale.kycPanUpload,
                    style: TextStyles.sourceSansM.body2,
                  ),
                  SizedBox(height: SizeConfig.padding12),
                  Container(
                    width: SizeConfig.screenWidth,
                    height: SizeConfig.screenWidth! / 2.5,
                    margin: EdgeInsets.only(top: SizeConfig.padding4),
                    child: Row(children: [
                      FileCaptureOption(
                        icon: Assets.ic_camera,
                        desc: locale.kycUseCamera,
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
                            final _internalOpsService =
                                locator<InternalOpsService>();
                            final _userService = locator<UserService>();
                            _internalOpsService.logFailure(
                              _userService.baseUser?.uid ?? '',
                              FailType.KycImageCaptureFailed,
                              {
                                'message': "Kyc image caputre failed",
                                'reason': e.toString()
                              },
                            );

                            model.permissionFailureCount += 1;
                            print(e.runtimeType);
                            const Permission cameraPermission =
                                Permission.camera;
                            final PermissionStatus cameraPermissionStatus =
                                await cameraPermission.status;
                            if (model.permissionFailureCount > 2) {
                              return BaseUtil.openDialog(
                                isBarrierDismissible: true,
                                addToScreenStack: true,
                                hapticVibrate: true,
                                content: MoreInfoDialog(
                                  title: locale.btnAlert,
                                  text: locale.kycGrantPermissionText,
                                  btnText: locale.btnGrantPermission,
                                  onPressed: () async {
                                    await openAppSettings();
                                    AppState.backButtonDispatcher!
                                        .didPopRoute();
                                  },
                                ),
                              );
                            } else if (cameraPermissionStatus ==
                                PermissionStatus.denied) {
                              return BaseUtil.openDialog(
                                isBarrierDismissible: true,
                                addToScreenStack: true,
                                hapticVibrate: true,
                                content: MoreInfoDialog(
                                  title: locale.btnAlert,
                                  text: locale.kycGrantPermissionText,
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
                        desc: locale.uploadFromDevice,
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
            AppTextFieldLabel(locale.maxSizeText, leftPadding: 0),
            SizedBox(
              width: SizeConfig.padding16,
            )
          ],
        ),
        AppTextFieldLabel(locale.formatsText, leftPadding: 0),
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
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                  ),
                  SizedBox(width: SizeConfig.padding16),
                  Expanded(
                    child: Text(
                      model.kycErrorMessage ?? locale.someThingWentWrongError,
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
