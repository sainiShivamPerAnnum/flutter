import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/bank_account_details_model.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/appbar/appbar.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/ui/pages/static/web_view.dart';
import 'package:felloapp/ui/pages/userProfile/bank_details/bank_details_vm.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'bank_details_help.dart';

class BankDetailsView extends StatelessWidget {
  final bool _withNetBankingValidation;

  const BankDetailsView({
    super.key,
    bool? validation,
  }) : _withNetBankingValidation = validation ?? false;

  void _showSupportedBanks() {
    AppState.delegate!.appState.currentAction = PageAction(
      page: WebViewPageConfig,
      state: PageState.addWidget,
      widget: const WebViewScreen(
        url: 'https://fello.in/policy/netbanking',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return BaseView<BankDetailsViewModel>(
      onModelReady: (model) => model.init(
        withNetbankingValidation: _withNetBankingValidation,
      ),
      builder: (ctx, model, chlid) => model.inEditMode &&
              model.showBankDetailsHelpView
          ? BankDetailsHelpView(
              changeView: model.changeView,
            )
          : Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: UiConstants.kBackgroundColor,
              appBar: FAppBar(
                type: FaqsType.yourAccount,
                title: locale.bankAccDetails,
                backgroundColor: UiConstants.kSecondaryBackgroundColor,
                showAvatar: false,
                showCoinBar: false,
                showHelpButton: false,
              ),
              body: model.state == ViewState.Busy
                  ? const Center(child: FullScreenLoader())
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                          Expanded(
                            child: Form(
                              key: model.formKey,
                              child: ListView(
                                padding: EdgeInsets.all(
                                    SizeConfig.pageHorizontalMargins),
                                shrinkWrap: true,
                                children: <Widget>[
                                  AppTextFieldLabel(locale.bankHolderName),
                                  AppTextField(
                                    autoFocus: true,
                                    focusNode: model.nameFocusNode,
                                    isEnabled: model.inEditMode,
                                    keyboardType: TextInputType.name,
                                    inputFormatters: [
                                      // UpperCaseTextFormatter(),
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[a-zA-Z ]'))
                                    ],
                                    // textCapitalization: TextCapitalization.characters,
                                    textEditingController:
                                        model.bankHolderNameController,
                                    validator: (value) {
                                      return (value == null ||
                                              value.isEmpty ||
                                              value.trim().length < 4)
                                          ? locale.enterNameAsPerBank
                                          : null;
                                    },
                                  ),
                                  SizedBox(height: SizeConfig.padding16),
                                  AppTextFieldLabel(
                                    locale.bankAccNoTitle,
                                  ),
                                  AppTextField(
                                    isEnabled: model.inEditMode,
                                    textEditingController:
                                        model.bankAccNoController,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            signed: true),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(18),
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    validator: (value) {
                                      print(value);

                                      if (value == null &&
                                          value!.trim().isEmpty) {
                                        return locale.enterValidAcc;
                                      } else if (value.trim().length < 9 ||
                                          value.trim().length > 18) {
                                        return locale.invalidBankAcc;
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: SizeConfig.padding16),
                                  AppTextFieldLabel(locale.confirmAccNo),
                                  AppTextField(
                                    isEnabled: model.inEditMode,
                                    textEditingController:
                                        model.bankAccNoConfirmController,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                      signed: true,
                                    ),
                                    obscure: true,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(18),
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    validator: (value) {
                                      print(value);
                                      if (value == null &&
                                          value!.trim().isEmpty) {
                                        return locale.enterValidAcc;
                                      } else if (value.trim() !=
                                          model.bankAccNoController!.text
                                              .trim()) {
                                        return locale.bankAccDidNotMatch;
                                      } else if (value.trim().length < 9 ||
                                          value.trim().length > 18) {
                                        return locale.invalidBankAcc;
                                      }

                                      return null;
                                    },
                                  ),
                                  SizedBox(height: SizeConfig.padding16),
                                  AppTextFieldLabel(
                                    locale.bankIFSC,
                                  ),
                                  AppTextField(
                                    isEnabled: model.inEditMode,
                                    textEditingController:
                                        model.bankIfscController,
                                    keyboardType: TextInputType.streetAddress,
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[A-Za-z0-9]'))
                                    ],
                                    validator: (value) {
                                      print(value);
                                      if (value == null &&
                                          value!.trim().isEmpty) {
                                        return locale.validIFSC;
                                      } else if (value.trim().length < 6 ||
                                          value.trim().length > 25) {
                                        return locale.validIFSC;
                                      }
                                      return null;
                                    },
                                  ),
                                  if (_withNetBankingValidation)
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: SizeConfig.padding12,
                                      ),
                                      child: InkWell(
                                        onTap: _showSupportedBanks,
                                        child: Text(
                                          'List of supported Banks for Net Banking',
                                          style: TextStyles.sourceSans.body4
                                              .copyWith(
                                            color: UiConstants.grey1,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ),
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
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(locale.txnWithdrawAccountText,
                                        style: TextStyles.sourceSans.body3
                                            .colour(UiConstants.kTextColor2))
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SafeArea(
                            child: Container(
                              width: SizeConfig.screenWidth,
                              padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.pageHorizontalMargins),
                              child: SizedBox(
                                width: SizeConfig.navBarWidth,
                                child: model.inEditMode
                                    ? ReactivePositiveAppButton(
                                        btnText: model.activeBankDetails!
                                                .isDetailsAreValid
                                            ? locale.btnUpdate
                                            : locale.btnAdd,
                                        onPressed: () async {
                                          if (model.isDetailsUpdating) return;
                                          if (BaseUtil.showNoInternetAlert()) {
                                            return;
                                          }
                                          FocusScope.of(context).unfocus();
                                          if (model.formKey.currentState!
                                              .validate()) {
                                            await model.updateBankDetails();
                                          }
                                        },
                                      )
                                    : AppPositiveBtn(
                                        btnText: 'Edit',
                                        onPressed: () {
                                          model.inEditMode = true;
                                          Future.delayed(
                                              const Duration(milliseconds: 200),
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
