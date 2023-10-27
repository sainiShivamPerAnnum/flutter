import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/login/login_components/login_support.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/ui/pages/userProfile/kyc_details/kyc_details_vm.dart';
import 'package:felloapp/ui/pages/userProfile/kyc_details/kyc_help.dart';
import 'package:felloapp/ui/pages/userProfile/kyc_details/kyc_verification_views.dart/kyc_error.dart';
import 'package:felloapp/ui/pages/userProfile/kyc_details/kyc_verification_views.dart/kyc_success.dart';
import 'package:felloapp/ui/pages/userProfile/kyc_details/kyc_verification_views.dart/kyc_unverifed.dart';
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

class KYCDetailsView extends StatelessWidget {
  // bool _showKycDetails = false;

  const KYCDetailsView({super.key});

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

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return BaseView<KYCDetailsViewModel>(
      onModelReady: (model) {
        model.init();
      },
      builder: (ctx, model, child) => model.showKycHelpView
          ? KycHelpView(callBack: model.changeView)
          : Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                leading: BackButton(
                  onPressed: () => AppState.backButtonDispatcher!.didPopRoute(),
                ),
                backgroundColor: UiConstants.kSecondaryBackgroundColor,
                title: Text(
                  locale.kycTitle.toUpperCase(),
                  style: TextStyles.rajdhaniSB.title3,
                ),
                actions: [
                  if (!model.isUpdatingKycDetails)
                    const Row(
                      children: [
                        FaqPill(type: FaqsType.yourAccount),
                      ],
                    ),
                  SizedBox(width: SizeConfig.padding16)
                ],
              ),
              backgroundColor: UiConstants.kBackgroundColor,
              body: model.state == ViewState.Busy
                  ? const Center(
                      child: FullScreenLoader(),
                    )
                  : SizedBox(
                      width: SizeConfig.screenWidth,
                      height:
                          SizeConfig.screenHeight! - SizeConfig.fToolBarHeight,
                      child: Stack(
                        children: [
                          ListView(
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(
                                vertical: SizeConfig.pageHorizontalMargins),
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal:
                                        SizeConfig.pageHorizontalMargins),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (model.kycVerificationStatus ==
                                        KycVerificationStatus.UNVERIFIED)
                                      Text(
                                          "Please provide your PAN and registered email ID",
                                          style: TextStyles.sourceSansSB.body2),
                                    SizedBox(height: SizeConfig.padding16),
                                    getKycView(model),
                                    Divider(
                                      height: SizeConfig.pageHorizontalMargins,
                                      color: Colors.white30,
                                      thickness: 1,
                                    ),
                                    EmailVerificationTile(model: model),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          model.kycVerificationStatus ==
                                      KycVerificationStatus.UNVERIFIED ||
                                  model.kycVerificationStatus ==
                                      KycVerificationStatus.FAILED
                              ? Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                        SizeConfig.pageHorizontalMargins),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(height: SizeConfig.padding90),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: SizeConfig
                                                  .pageHorizontalMargins),
                                          padding: EdgeInsets.symmetric(
                                              vertical: SizeConfig.padding16,
                                              horizontal: SizeConfig.padding20),
                                          decoration: BoxDecoration(
                                            color:
                                                UiConstants.kBackgroundColor3,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    SizeConfig.roundness12)),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SvgPicture.asset(
                                                "assets/svg/safety_asset.svg",
                                                width: SizeConfig.padding24,
                                              ),
                                              SizedBox(
                                                width: SizeConfig.padding14,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  'Name on your PAN Card should be the same as Name on your Bank Account',
                                                  style: TextStyles
                                                      .sourceSans.body3
                                                      .colour(UiConstants
                                                          .kTextColor2),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        model.isUpdatingKycDetails
                                            ? const LinearProgressIndicator(
                                                backgroundColor: Colors.black,
                                              )
                                            : AppPositiveBtn(
                                                onPressed: () async {
                                                  await model.onSubmit(context);
                                                },
                                                btnText: locale.btnSubmit,
                                                width: SizeConfig.screenWidth,
                                              ),
                                      ],
                                    ),
                                  ),
                                )
                              : const SizedBox(),
//////////////////////////////
                        ],
                      ),
                    ),
            ),
    );
  }
}

class EmailVerificationTile extends StatelessWidget {
  final KYCDetailsViewModel model;
  const EmailVerificationTile({required this.model, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            model.isEmailVerified
                ? "Registered Email"
                : "Step 2: Choose a google account",
            style: TextStyles.sourceSansM.body2,
          ),
          SizedBox(height: SizeConfig.padding12),
          GestureDetector(
            onTap: model.veryGmail,
            child: KycBriefTile(
                model: model,
                leading: Assets.google,
                trailing: Padding(
                  padding: EdgeInsets.only(right: SizeConfig.padding10),
                  child: model.isEmailVerified
                      ? Padding(
                          padding: EdgeInsets.only(
                              right: SizeConfig.pageHorizontalMargins),
                          child: const Icon(
                            Icons.verified,
                            color: UiConstants.primaryColor,
                          ),
                        )
                      : model.isEmailUpdating
                          ? Padding(
                              padding: EdgeInsets.only(
                                  right: SizeConfig.pageHorizontalMargins),
                              child: SpinKitThreeBounce(
                                size: SizeConfig.iconSize0,
                                color: UiConstants.primaryColor,
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.only(
                                  right: SizeConfig.pageHorizontalMargins),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: SizeConfig.iconSize0,
                              ),
                            ),
                ),
                subtitle: model.isEmailVerified ? null : "to verify email",
                title:
                    model.isEmailVerified ? model.email! : "Select an account"),
          ),
        ],
      ),
    );
  }
}

class KycBriefTile extends StatelessWidget {
  const KycBriefTile(
      {required this.model,
      required this.trailing,
      required this.title,
      Key? key,
      this.label,
      this.subtitle,
      this.leading})
      : super(key: key);

  final KYCDetailsViewModel model;
  final Widget trailing;
  final String title;
  final String? label;
  final String? subtitle;
  final String? leading;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) AppTextFieldLabel(label!, leftPadding: 0),
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
                  leading ?? Assets.ic_upload_success,
                  width: SizeConfig.padding20,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyles.sourceSansSB.body2.colour(Colors.white),
                    ),
                    if (subtitle != null)
                      Padding(
                        padding: EdgeInsets.only(top: SizeConfig.padding6),
                        child: Text(
                          subtitle!,
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
      ],
    );
  }
}

class FileCaptureOption extends StatelessWidget {
  final String icon;
  final String? desc;
  final Function func;
  final EdgeInsets? padding;
  const FileCaptureOption({
    required this.icon,
    required this.func,
    Key? key,
    this.desc,
    this.padding,
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
              padding: padding ?? EdgeInsets.all(SizeConfig.padding12),
              width: SizeConfig.avatarRadius * 3,
              height: SizeConfig.avatarRadius * 3,
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
                  desc!,
                  style: TextStyles.body3.colour(UiConstants.kTextColor2),
                ),
              )
          ]),
        ),
      ),
    );
  }
}
