import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/userProfile/kyc_details/kyc_details_vm.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class KycPanHelpView extends StatelessWidget {
  const KycPanHelpView({required this.model, super.key});
  final KYCDetailsViewModel model;
  @override
  Widget build(BuildContext context) {
    final locale = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              switch (model.kycVerificationStatus) {
                KycVerificationStatus.VERIFIED => const PanUploaded(),
                _ => const UploadPanCard(),
              },
              Text(
                locale.panNote,
                style: TextStyles.sourceSansSB.body3
                    .colour(UiConstants.kTextFieldTextColor.withOpacity(0.8)),
              ),
              SizedBox(
                height: SizeConfig.padding16,
              ),
              Divider(
                color: UiConstants.kTextColor.withOpacity(0.2),
                height: SizeConfig.padding10,
              ),
              if (model.kycVerificationStatus == KycVerificationStatus.FAILED)
                Text(
                  model.kycErrorMessage ??
                      'PAN image not verified. Attach valid PAN image',
                  style: TextStyles.sourceSans.body4
                      .colour(UiConstants.kBlogCardRandomColor1),
                ),
              Container(
                margin: EdgeInsets.only(top: SizeConfig.padding20),
                padding: EdgeInsets.symmetric(vertical: SizeConfig.padding14),
                decoration: BoxDecoration(
                  color: UiConstants.kInfoBackgroundColor,
                  borderRadius: BorderRadius.circular(SizeConfig.roundness8),
                ),
                child: Row(children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: SizeConfig.padding12),
                    child: AppImage(
                      Assets.kycSecurity,
                      width: SizeConfig.padding26,
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(right: SizeConfig.padding18),
                      child: Text(
                        locale.panSecurity,
                        style: TextStyles.sourceSans.body3.colour(
                            UiConstants.kTextFieldTextColor.withOpacity(0.8)),
                      ),
                    ),
                  )
                ]),
              )
            ],
          ),
        ),
        if (!model.isUpdatingKycDetails) ...[
          Center(
            child: TextButton(
              style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(50, 30),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  alignment: Alignment.centerLeft),
              onPressed: () => AppState.backButtonDispatcher!.didPopRoute(),
              child: Text(
                locale.skipKYC,
                style: TextStyles.rajdhaniB.body1
                    .colour(UiConstants.kTextFieldTextColor),
              ),
            ),
          ),
          SizedBox(
            height: SizeConfig.padding20,
          ),
          Center(
            child: MaterialButton(
              height: SizeConfig.padding44,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SizeConfig.roundness5)),
              minWidth: SizeConfig.screenWidth! -
                  SizeConfig.pageHorizontalMargins * 2,
              color: UiConstants.kTextColor,
              onPressed: () => model.panUploadProceed(model),
              child: Text(
                model.kycVerificationStatus == KycVerificationStatus.VERIFIED
                    ? locale.proceed
                    : locale.uploadPan,
                style:
                    TextStyles.rajdhaniB.body1.colour(UiConstants.kTextColor4),
              ),
            ),
          ),
        ] else
          const LinearProgressIndicator(
            backgroundColor: UiConstants.kTextColor4,
          ),
        SizedBox(
          height: SizeConfig.padding16,
        ),
      ],
    );
  }
}

class UploadPanCard extends StatelessWidget {
  const UploadPanCard({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = S.of(context);
    return Column(
      children: [
        Text(
          locale.kycForInvesting,
          style: TextStyles.sourceSansSB.body1,
        ),
        SizedBox(
          height: SizeConfig.padding4,
        ),
        Text(
          locale.uploadImagePan,
          style: TextStyles.sourceSans.body3
              .colour(UiConstants.kTextColor3.withOpacity(0.8)),
        ),
        SizedBox(
          height: SizeConfig.padding22,
        ),
        Center(
          child: AppImage(
            Assets.dummyPan,
            height: SizeConfig.screenWidth! * 0.4,
          ),
        ),
        SizedBox(
          height: SizeConfig.padding30,
        ),
      ],
    );
  }
}

class PanUploaded extends StatelessWidget {
  const PanUploaded({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale.panUploaded,
          style: TextStyles.sourceSansSB.body1
              .colour(UiConstants.kTextFieldTextColor.withOpacity(0.8)),
        ),
        Container(
          width: SizeConfig.screenWidth,
          padding: EdgeInsets.symmetric(
            vertical: SizeConfig.padding20,
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
                  border: Border.all(color: UiConstants.kTextFieldTextColor),
                  shape: BoxShape.circle,
                  color: UiConstants.kTextColor4,
                ),
                child: SvgPicture.asset(
                  Assets.ic_upload_success,
                ),
              ),
              Expanded(
                child: Text(
                  "PAN1234.png",
                  style: TextStyles.sourceSansSB.body2
                      .colour(UiConstants.kTextFieldTextColor),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(SizeConfig.roundness5),
                    border:
                        Border.all(width: 2, color: UiConstants.primaryColor)),
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.padding12,
                  vertical: SizeConfig.padding4,
                ),
                margin: EdgeInsets.only(right: SizeConfig.padding12),
                child: Text(
                  locale.btnVerified.toUpperCase(),
                  style: TextStyles.rajdhaniSB.body2
                      .colour(UiConstants.primaryColor),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: SizeConfig.padding24,
        ),
      ],
    );
  }
}
