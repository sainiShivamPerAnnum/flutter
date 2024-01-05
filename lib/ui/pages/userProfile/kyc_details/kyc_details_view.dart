import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/login/login_components/login_support.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/ui/pages/userProfile/kyc_details/kyc_details_vm.dart';
import 'package:felloapp/ui/pages/userProfile/kyc_details/kyc_verification_views.dart/kyc_error.dart';
import 'package:felloapp/ui/pages/userProfile/kyc_details/kyc_verification_views.dart/kyc_help_email.dart';
import 'package:felloapp/ui/pages/userProfile/kyc_details/kyc_verification_views.dart/kyc_help_pan.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class KYCDetailsView extends StatelessWidget {
  const KYCDetailsView({super.key});

  StatelessWidget getKycView(KYCDetailsViewModel model) {
    switch (model.currentStep) {
      case CurrentStep.email:
        return KycEmailHelpView(model: model);
      case CurrentStep.pan:
        return KycPanHelpView(model: model);
      default:
        return NoKycView(model: model);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = S.of(context);
    return BaseView<KYCDetailsViewModel>(
      onModelReady: (model) {
        model.init();
      },
      builder: (ctx, model, child) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => AppState.backButtonDispatcher!.didPopRoute(),
          ),
          backgroundColor: UiConstants.kTambolaMidTextColor,
          title: Text(
            locale.kycTitle.toUpperCase(),
            style: TextStyles.sourceSansSB.title5,
          ),
          actions: [
            const Row(
              children: [
                FaqPill(type: FaqsType.yourAccount),
              ],
            ),
            SizedBox(width: SizeConfig.padding16)
          ],
        ),
        backgroundColor: UiConstants.kBackgroundColor,
        body: switch (model.state) {
          ViewState.Busy => const Center(
              child: FullScreenLoader(),
            ),
          ViewState.Idle || ViewState.Offline => SizedBox(
              width: SizeConfig.screenWidth,
              height: SizeConfig.screenHeight! - SizeConfig.fToolBarHeight,
              child: Padding(
                padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.pageHorizontalMargins)
                    .copyWith(right: SizeConfig.padding32),
                child: Column(
                  children: [
                    SizedBox(
                      height: SizeConfig.padding22,
                    ),
                    _Stepper(
                      currentStep: model.currentStep,
                    ),
                    SizedBox(
                      height: SizeConfig.padding10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          locale.kycStep1,
                          style: TextStyles.sourceSans.body3
                              .colour(UiConstants.kTextColor.withOpacity(0.8)),
                        ),
                        Text(
                          locale.kycStep2,
                          style: TextStyles.sourceSans.body3
                              .colour(UiConstants.kTextColor.withOpacity(0.8)),
                        )
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.padding32,
                    ),
                    Expanded(child: getKycView(model)),
                  ],
                ),
              ),
            ),
        },
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
                  border: Border.all(color: UiConstants.kTextColor),
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
                      style: TextStyles.sourceSansSB.body2
                          .colour(UiConstants.kTextColor),
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

class CirclePainter extends CustomPainter {
  final Color color;
  CirclePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;
    canvas.drawOval(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CirclePainter oldDelegate) {
    return color != oldDelegate.color;
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({required this.currentStep});
  final CurrentStep currentStep;

  Color _getColor(CurrentStep currentStep) {
    return switch (currentStep) {
      CurrentStep.email => UiConstants.kTabBorderColor,
      CurrentStep.pan => UiConstants.kLastUpdatedTextColor
    };
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomPaint(
          size: Size(SizeConfig.padding10, SizeConfig.padding10),
          painter: CirclePainter(UiConstants.kTabBorderColor),
        ),
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: SizeConfig.padding4,
          ),
          color: _getColor(currentStep),
          height: SizeConfig.padding4,
          width: SizeConfig.padding252,
        ),
        CustomPaint(
          size: Size(SizeConfig.padding10, SizeConfig.padding10),
          painter: CirclePainter(
            _getColor(currentStep),
          ),
        ),
      ],
    );
  }
}
