import 'package:camera/camera.dart';
import 'package:felloapp/base_util.dart';
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

class KycUnVerifiedView extends StatelessWidget {
  final KYCDetailsViewModel model;
  const KycUnVerifiedView({Key key, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        model.capturedImage != null
            ? KycBriefTile(
                title: "Upload your PAN Card",
                model: model,
                trailing: IconButton(
                  icon: Icon(Icons.delete_rounded),
                  color: Colors.red,
                  onPressed: () {
                    Haptic.vibrate();
                    model.capturedImage = null;
                  },
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextFieldLabel("Upload your PAN Card"),
                  Container(
                    width: SizeConfig.screenWidth,
                    height: SizeConfig.screenWidth / 2.5,
                    margin: EdgeInsets.only(top: SizeConfig.padding4),
                    child: Row(children: [
                      FileCaptureOption(
                        icon: Assets.ic_camera,
                        desc: "Use Camera",
                        func: () async {
                          final cameras = await availableCameras();
                          final firstCamera = cameras.first;
                          BaseUtil.openModalBottomSheet(
                            addToScreenStack: true,
                            isScrollControlled: true,
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
                        icon: Assets.ic_upload_file,
                        desc: "Upload from device",
                        func: () async {
                          model.capturedImage = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          model.verifyImage();
                          if (model.capturedImage != null) {
                            Log(model.capturedImage.path);
                          }
                        },
                      ),
                    ]),
                  ),
                ],
              ),
        SizedBox(height: SizeConfig.padding10),
        AppTextFieldLabel("Max size: 5 MB"),
        AppTextFieldLabel("Formats: PNG, JPEG, JPG"),
        if (model.kycVerificationStatus == KycVerificationStatus.FAILED &&
            model.capturedImage == null)
          Padding(
            padding: EdgeInsets.only(top: SizeConfig.padding8),
            child: Text(model.userKycData.trackResult.reason ?? '',
                style: TextStyles.body3.colour(Colors.red)),
          ),
      ],
    );
  }
}
