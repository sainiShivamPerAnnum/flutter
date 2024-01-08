import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/userProfile/kyc_details/kyc_details_view.dart';
import 'package:felloapp/ui/pages/userProfile/kyc_details/kyc_details_vm.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class KycEmailHelpView extends StatelessWidget {
  const KycEmailHelpView({required this.model, super.key});
  final KYCDetailsViewModel model;

  @override
  Widget build(BuildContext context) {
    final locale = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.isEmailVerified
                    ? locale.KyclinkedAccount
                    : locale.verifyEmailKyc,
                style: TextStyles.sourceSansSB.body1
                    .colour(UiConstants.kTextColor.withOpacity(0.8)),
              ),
              EmailVerificationTile(model: model),
              SizedBox(
                height: SizeConfig.padding18,
              ),
              Divider(
                color: model.isEmailVerified
                    ? UiConstants.kTextColor
                    : UiConstants.kTextColor.withOpacity(0.2),
                height: SizeConfig.padding10,
              ),
              if (model.isEmailVerified) ...[
                SizedBox(height: SizeConfig.padding24),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        locale.kycComplete,
                        style: TextStyles.sourceSansSB.title5
                            .colour(UiConstants.kTextColor.withOpacity(0.8)),
                      ),
                      Text(
                        locale.kycCompleteSub,
                        style: TextStyles.sourceSansSB.body1
                            .colour(UiConstants.kTextColor.withOpacity(0.8)),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.padding46),
                        child: Container(
                          height: SizeConfig.padding200,
                          width: SizeConfig.padding200,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: UiConstants.kArrowButtonBackgroundColor),
                          child: Center(
                              child: Text('🙌',
                                  style: TextStyles.rajdhaniB.title98)),
                        ),
                      ),
                      Text(
                        locale.startInvesting,
                        style: TextStyles.sourceSansSB.body1
                            .colour(UiConstants.kTextColor.withOpacity(0.8)),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Container(
                  margin: EdgeInsets.only(top: SizeConfig.padding16),
                  padding: EdgeInsets.symmetric(vertical: SizeConfig.padding14),
                  decoration: BoxDecoration(
                    color: UiConstants.kInfoBackgroundColor,
                    borderRadius: BorderRadius.circular(SizeConfig.roundness8),
                  ),
                  child: Row(children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.padding12),
                      child: Image.asset(
                        Assets.kycSecurity,
                        width: SizeConfig.padding26,
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.only(right: SizeConfig.padding18),
                        child: Text(
                          locale.preKYC,
                          style: TextStyles.sourceSans.body3.colour(
                              UiConstants.kTextFieldTextColor.withOpacity(0.8)),
                        ),
                      ),
                    )
                  ]),
                )
              ]
            ],
          ),
        ),
        if (!model.isEmailVerified)
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
                style:
                    TextStyles.rajdhaniB.body1.colour(UiConstants.kTextColor),
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
            minWidth:
                SizeConfig.screenWidth! - SizeConfig.pageHorizontalMargins * 2,
            color: UiConstants.kTextColor,
            onPressed: model.isEmailVerified
                ? () => AppState.backButtonDispatcher!.didPopRoute()
                : model.veryGmail,
            child: Text(
              model.isEmailVerified ? locale.donePAN : locale.kycEmailProceed,
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

class EmailVerificationTile extends StatelessWidget {
  final KYCDetailsViewModel model;
  const EmailVerificationTile({required this.model, super.key});

  @override
  Widget build(BuildContext context) {
    final locale = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: SizeConfig.padding16),
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
                              color: UiConstants.kTextColor,
                              size: SizeConfig.iconSize0,
                            ),
                          ),
              ),
              subtitle: model.isEmailVerified ? null : locale.toverifyEmail,
              title: model.isEmailVerified ? model.email! : locale.selectGmail),
        ),
      ],
    );
  }
}
