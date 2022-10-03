import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/profile/kyc_details/kyc_details_vm.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/ui/widgets/appbar/appbar.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/gestures.dart';
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

class KYCDetailsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return BaseView<KYCDetailsViewModel>(
      onModelReady: (model) {
        model.init();
      },
      builder: (ctx, model, child) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: FAppBar(
          title: 'Add KYC Details',
          backgroundColor: UiConstants.kSecondaryBackgroundColor,
          showAvatar: false,
          showCoinBar: false,
          showHelpButton: false,
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
                    AppTextFieldLabel(locale.kycNameLabel),
                    AppTextField(
                      focusNode: model.kycNameFocusNode,
                      inputFormatters: [
                        UpperCaseTextFormatter(),
                        FilteringTextInputFormatter.allow(RegExp(r'[A-Z ]'))
                      ],
                      isEnabled: model.inEditMode,
                      textEditingController: model.nameController,
                      validator: (String value) {
                        return '';
                      },
                      keyboardType: TextInputType.name,
                    ),
                    SizedBox(height: SizeConfig.padding24),
                    AppTextFieldLabel(
                      locale.pkPanLabel,
                    ),
                    AppTextField(
                      focusNode: model.panFocusNode,
                      inputFormatters: [
                        UpperCaseTextFormatter(),
                        FilteringTextInputFormatter.deny(RegExp(r'^0+(?!$)')),
                        LengthLimitingTextInputFormatter(10)
                      ],
                      textCapitalization: TextCapitalization.characters,
                      keyboardType: model.panTextInputType,
                      onChanged: (val) {
                        print("val changed");
                        model.checkForKeyboardChange(val.trim());
                      },
                      isEnabled: model.inEditMode,
                      textEditingController: model.panController,
                      validator: (String value) {
                        return '';
                      },
                    ),
                    Spacer(),
                    Container(
                      margin: EdgeInsets.symmetric(
                          vertical: SizeConfig.pageHorizontalMargins),
                      padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.padding16,
                          horizontal: SizeConfig.padding20),
                      decoration: BoxDecoration(
                        color: UiConstants.kBackgroundColor3,
                        borderRadius: BorderRadius.all(
                            Radius.circular(SizeConfig.roundness12)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            "assets/svg/dual_star.svg",
                            width: SizeConfig.padding20,
                          ),
                          SizedBox(
                            width: SizeConfig.padding14,
                          ),
                          RichText(
                            overflow: TextOverflow.ellipsis,
                            text: new TextSpan(
                              children: [
                                new TextSpan(
                                  text: 'Join over  ',
                                  style: TextStyles.sourceSans.body3
                                      .colour(UiConstants.kTextColor2),
                                ),
                                new TextSpan(
                                  text: '5 lakh',
                                  style: TextStyles.sourceSans.body3
                                      .colour(UiConstants.kTextColor),
                                ),
                                new TextSpan(
                                  text: '  users in making finance fun!',
                                  style: TextStyles.sourceSans.body3
                                      .colour(UiConstants.kTextColor2),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    model.inEditMode
                        ? ReactivePositiveAppButton(
                            onPressed: () async {
                              model.panFocusNode.unfocus();
                              await model.onSubmit(context);
                            },
                            btnText: locale.btnSumbit,
                            width: SizeConfig.screenWidth,
                          )
                        : AppPositiveBtn(
                            btnText: 'Update',
                            onPressed: () => model.inEditMode = true,
                          ),
                    SizedBox(height: SizeConfig.padding10),
                  ],
                ),
              ),
      ),
    );
  }
}
