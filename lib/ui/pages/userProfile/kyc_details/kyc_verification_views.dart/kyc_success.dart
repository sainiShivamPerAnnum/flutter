import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/userProfile/kyc_details/kyc_details_vm.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class KycSuccessView extends StatelessWidget {
  final KYCDetailsViewModel model;

  const KycSuccessView({required this.model, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextFieldLabel(
          locale.pkPanLabel,
        ),
        AppTextField(
          focusNode: model.panFocusNode,
          inputFormatters: [
            // UpperCaseTextFormatter(),
            FilteringTextInputFormatter.deny(RegExp(r'^0+(?!$)')),
            LengthLimitingTextInputFormatter(10)
          ],
          textCapitalization: TextCapitalization.characters,
          keyboardType: model.panTextInputType,
          onChanged: (val) {
            print("val changed");
            // model.checkForKeyboardChange(val.trim());
          },
          isEnabled: model.inEditMode,
          textEditingController: model.panController,
          validator: (String? value) {
            return '';
          },
        ),
        SizedBox(height: SizeConfig.padding24),
        AppTextFieldLabel(locale.kycNameLabel),
        AppTextField(
          focusNode: model.kycNameFocusNode,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]'))
          ],
          // textCapitalization: TextCapitalization.characters,
          isEnabled: model.inEditMode,
          textEditingController: model.nameController,
          validator: (String? value) {
            return '';
          },
          keyboardType: TextInputType.name,
        ),
        SizedBox(height: SizeConfig.padding24),
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
        )
      ],
    );
  }
}
