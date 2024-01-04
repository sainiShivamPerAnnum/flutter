import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/userProfile/kyc_details/kyc_details_vm.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UploadPanModal extends StatelessWidget {
  const UploadPanModal({required this.model, super.key});
  final KYCDetailsViewModel model;

  @override
  Widget build(BuildContext context) {
    final S locale = S.of(context);
    return WillPopScope(
      onWillPop: () {
        AppState.backButtonDispatcher!.didPopRoute();
        return Future.value(true);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.pageHorizontalMargins,
            vertical: SizeConfig.padding20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              locale.uploadModal,
              style: TextStyles.sourceSansSB.title5
                  .colour(Colors.white.withOpacity(0.8)),
            ),
            SizedBox(
              height: SizeConfig.padding16,
            ),
            FileCaptureOption(
                icon: Assets.ic_camera,
                trailingIcon: Assets.ic_upload_procced,
                desc: locale.kycUseCamera,
                onTap: () => model.imageCapture(context)),
            SizedBox(
              height: SizeConfig.padding16,
            ),
            FileCaptureOption(
              icon: Assets.ic_upload_file,
              desc: locale.uploadFromDevice,
              trailingIcon: Assets.ic_upload_procced,
              onTap: () => model.selectImage(context),
            ),
            SizedBox(height: SizeConfig.padding16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  locale.maxSize,
                  style: TextStyles.sourceSans.body3
                      .colour(const Color.fromRGBO(167, 167, 168, 0.8)),
                ),
                Text(
                  locale.formats,
                  style: TextStyles.sourceSans.body3
                      .colour(const Color.fromRGBO(167, 167, 168, 0.8)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class FileCaptureOption extends StatelessWidget {
  final String icon;
  final String trailingIcon;
  final String? desc;
  final Function onTap;
  const FileCaptureOption(
      {required this.icon,
      required this.onTap,
      required this.trailingIcon,
      Key? key,
      this.desc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Haptic.vibrate();
        onTap();
      },
      highlightColor: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          color: UiConstants.kBackgroundColor3,
          borderRadius: BorderRadius.circular(SizeConfig.roundness8),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            margin: EdgeInsets.fromLTRB(
                SizeConfig.padding24,
                SizeConfig.padding20,
                SizeConfig.padding36,
                SizeConfig.padding20),
            height: SizeConfig.padding32,
            child: SvgPicture.asset(
              icon,
            ),
          ),
          if (desc != null)
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: SizeConfig.padding8),
                child: Text(
                  desc!,
                  style: TextStyles.sourceSansSB.body2
                      .colour(Colors.white.withOpacity(0.8)),
                ),
              ),
            ),
          Container(
            margin: EdgeInsets.all(SizeConfig.padding12),
            height: SizeConfig.padding10,
            child: SvgPicture.asset(
              trailingIcon,
            ),
          ),
        ]),
      ),
    );
  }
}
