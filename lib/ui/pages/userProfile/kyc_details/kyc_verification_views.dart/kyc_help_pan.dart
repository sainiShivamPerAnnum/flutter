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
    final S locale = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              model.kycVerificationStatus != KycVerificationStatus.VERIFIED
                  ? const UploadPanCard()
                  : const PanUploaded(),
              Text(
                locale.panNote,
                style: TextStyles.sourceSansSB.body3
                    .colour(const Color.fromRGBO(189, 189, 190, 0.8)),
              ),
              SizedBox(
                height: SizeConfig.padding18,
              ),
              const Divider(
                color: Color.fromRGBO(255, 255, 255, 0.2),
                height: 10,
              ),
              Container(
                margin: EdgeInsets.only(top: SizeConfig.padding22),
                padding: EdgeInsets.symmetric(vertical: SizeConfig.padding14),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(18, 18, 18, 1),
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
                        style: TextStyles.sourceSans.body3
                            .colour(const Color.fromRGBO(189, 189, 190, 0.8)),
                      ),
                    ),
                  )
                ]),
              )
            ],
          ),
        ),
        if (!model.isUpdatingKycDetails)
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
                style: TextStyles.rajdhaniB.body1.colour(Colors.white),
              ),
            ),
          ),
        if (!model.isUpdatingKycDetails)
          SizedBox(
            height: SizeConfig.padding20,
          ),
        model.isUpdatingKycDetails
            ? const LinearProgressIndicator(
                backgroundColor: Colors.black,
              )
            : Center(
                child: MaterialButton(
                  height: SizeConfig.padding44,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness5)),
                  minWidth: SizeConfig.screenWidth! -
                      SizeConfig.pageHorizontalMargins * 2,
                  color: Colors.white,
                  onPressed: () => model.panUploadProceed(model),
                  child: Text(
                    model.kycVerificationStatus ==
                            KycVerificationStatus.VERIFIED
                        ? locale.proceed
                        : locale.uploadPan,
                    style: TextStyles.rajdhaniB.body1.colour(Colors.black),
                  ),
                ),
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
    final S locale = S.of(context);
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
              .colour(const Color.fromRGBO(167, 167, 168, 0.8)),
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
    final S locale = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: SizeConfig.padding16,
        ),
        Text(
          locale.panUploaded,
          style: TextStyles.sourceSansSB.body1
              .colour(Colors.white.withOpacity(0.8)),
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
                  border: Border.all(color: Colors.white),
                  shape: BoxShape.circle,
                  color: Colors.black,
                ),
                child: SvgPicture.asset(
                  Assets.ic_upload_success,
                ),
              ),
              Expanded(
                child: Text(
                  "PAN3948.png",
                  style: TextStyles.sourceSansSB.body2.colour(Colors.white),
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
