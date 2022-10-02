import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/modals_sheets/coupon_modal_sheet.dart';
import 'package:felloapp/ui/pages/others/profile/bank_details/bank_details_vm.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/ui/widgets/appbar/appbar.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BankDetailsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<BankDetailsViewModel>(
      onModelReady: (model) => model.init(),
      onModelDispose: (model) => model.dispose(),
      builder: (ctx, model, chlid) => Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: UiConstants.kBackgroundColor,
        appBar: FAppBar(
          title: 'Bank Account Details',
          backgroundColor: UiConstants.kSecondaryBackgroundColor,
          showAvatar: false,
          showCoinBar: false,
          showHelpButton: false,
        ),
        body: model.state == ViewState.Busy
            ? Center(child: FullScreenLoader())
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    Expanded(
                      child: Form(
                        key: model.formKey,
                        child: ListView(
                          padding:
                              EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                          shrinkWrap: true,
                          children: <Widget>[
                            AppTextFieldLabel("Bank Holder's Name"),
                            AppTextField(
                              autoFocus: true,
                              focusNode: model.nameFocusNode,
                              isEnabled: model.inEditMode,
                              keyboardType: TextInputType.name,
                              inputFormatters: [
                                UpperCaseTextFormatter(),
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[A-Z ]'))
                              ],
                              textCapitalization: TextCapitalization.characters,
                              textEditingController:
                                  model.bankHolderNameController,
                              validator: (value) {
                                return (value == null ||
                                        value.isEmpty ||
                                        value.trim().length < 4)
                                    ? 'Please enter you name as per your bank'
                                    : null;
                              },
                            ),
                            SizedBox(height: SizeConfig.padding16),
                            AppTextFieldLabel(
                              "Bank Account Number",
                            ),
                            AppTextField(
                              isEnabled: model.inEditMode,
                              textEditingController: model.bankAccNoController,
                              keyboardType:
                                  TextInputType.numberWithOptions(signed: true),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(18),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (value) {
                                print(value);

                                if (value == null && value.trim().isEmpty)
                                  return 'Please enter a valid account number';
                                else if (value.trim().length < 9 ||
                                    value.trim().length > 18)
                                  return 'Invalid Bank Account Number';
                                return null;
                              },
                            ),
                            SizedBox(height: SizeConfig.padding16),
                            AppTextFieldLabel(
                              "Confirm Account Number",
                            ),
                            AppTextField(
                              isEnabled: model.inEditMode,
                              textEditingController:
                                  model.bankAccNoConfirmController,
                              keyboardType: TextInputType.visiblePassword,
                              obscure: true,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(18),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (value) {
                                print(value);
                                if (value == null && value.trim().isEmpty)
                                  return 'Please enter a valid account number';
                                else if (value.trim() !=
                                    model.bankAccNoController.text.trim())
                                  return "Bank account numbers did not match";
                                else if (value.trim().length < 9 ||
                                    value.trim().length > 18)
                                  return 'Invalid Bank Account Number';

                                return null;
                              },
                            ),
                            SizedBox(height: SizeConfig.padding16),
                            AppTextFieldLabel(
                              'Bank IFSC Code',
                            ),
                            AppTextField(
                              isEnabled: model.inEditMode,
                              textEditingController: model.bankIfscController,
                              keyboardType: TextInputType.streetAddress,
                              textCapitalization: TextCapitalization.characters,
                              validator: (value) {
                                print(value);
                                if (value == null && value.trim().isEmpty)
                                  return 'Please enter a valid bank IFSC';
                                else if (value.trim().length < 6 ||
                                    value.trim().length > 25)
                                  return 'Please enter a valid bank IFSC';
                                else if (!RegExp(r'[a-zA-Z]{4}[0]\w{6}$')
                                    .hasMatch(value))
                                  return "Please enter a valid bank IFSC";
                                return null;
                              },
                            ),
                            SizedBox(
                              height: SizeConfig.screenHeight / 2,
                            )
                          ],
                        ),
                      ),
                    ),
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
                    SafeArea(
                      child: Container(
                        width: SizeConfig.screenWidth,
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.pageHorizontalMargins),
                        child: Container(
                          width: SizeConfig.navBarWidth,
                          child: model.inEditMode
                              ? ReactivePositiveAppButton(
                                  btnText: model.hasPastBankDetails()
                                      ? 'Update'
                                      : 'Add',
                                  onPressed: () async {
                                    if (model.isDetailsUpdating) return;
                                    if (BaseUtil.showNoInternetAlert()) return;
                                    FocusScope.of(context).unfocus();
                                    if (model.formKey.currentState.validate())
                                      await model.updateBankDetails();
                                  },
                                )
                              : AppPositiveBtn(
                                  btnText: 'Edit',
                                  onPressed: () {
                                    model.inEditMode = true;
                                    Future.delayed(Duration(milliseconds: 200),
                                        () {
                                      model.nameFocusNode.requestFocus();
                                    });
                                  },
                                ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.pageHorizontalMargins,
                    )
                  ]),
      ),
    );
  }
}
