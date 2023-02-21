import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/login/login_components/login_support.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/ui/pages/userProfile/kyc_details/key_help.dart';
import 'package:felloapp/ui/pages/userProfile/kyc_details/kyc_details_vm.dart';
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

class KYCDetailsView extends StatefulWidget {
  @override
  State<KYCDetailsView> createState() => _KYCDetailsViewState();
}

class _KYCDetailsViewState extends State<KYCDetailsView> {
  bool _showKycDetails = false;

  getKycView(KYCDetailsViewModel model) {
    switch (model.kycVerificationStatus) {
      case KycVerificationStatus.VERIFIED:
        return KycSuccessView(model: model);
      case KycVerificationStatus.UNVERIFIED:
        _showKycDetails = true;

        return KycUnVerifiedView(model: model);

      case KycVerificationStatus.FAILED:
        return KycUnVerifiedView(model: model);
      case KycVerificationStatus.NONE:
        return NoKycView(model: model);
    }
  }

  void changeView() {
    _showKycDetails = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return BaseView<KYCDetailsViewModel>(
      onModelReady: (model) {
        model.init();
      },
      builder: (ctx, model, child) => _showKycDetails
          ? KycHelpView(callBack: changeView)
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
                    Row(
                      children: [
                        FaqPill(type: FaqsType.yourAccount),
                      ],
                    ),
                  SizedBox(width: SizeConfig.padding16)
                ],
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
                                          vertical:
                                              SizeConfig.pageHorizontalMargins),
                                      padding: EdgeInsets.symmetric(
                                          vertical: SizeConfig.padding16,
                                          horizontal: SizeConfig.padding20),
                                      decoration: BoxDecoration(
                                        color: UiConstants.kBackgroundColor3,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                SizeConfig.roundness12)),
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
                                                locale.kycVerifyText,
                                                style: TextStyles
                                                    .sourceSans.body3
                                                    .colour(UiConstants
                                                        .kTextColor2),
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
      {Key? key,
      required this.model,
      required this.trailing,
      required this.label,
      this.subtitle,
      required this.title})
      : super(key: key);

  final KYCDetailsViewModel model;
  final Widget trailing;
  final String title;
  final String label;
  final String? subtitle;

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
    Key? key,
    required this.icon,
    this.desc,
    this.padding,
    required this.func,
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
