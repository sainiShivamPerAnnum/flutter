import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_home/tambola_home_view.dart';
import 'package:felloapp/ui/pages/others/profile/kyc_details/kyc_details_vm.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/widgets/button4.0/appBar_button.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

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
        backgroundColor: UiConstants.backgroundColor,
        body: HomeBackground(
          child: Column(
            children: [
              FelloAppBar(
                leading: FelloAppBarBackButton(),
                title: locale.dPanNkyc,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                  decoration: BoxDecoration(
                    color: UiConstants.kBackgroundColor,
                  ),
                  child: model.state == ViewState.Busy
                      ? ListLoader()
                      : ListView(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          children: [
                            SizedBox(height: SizeConfig.scaffoldMargin),
                            AppTextFieldLabel(locale.kycNameLabel,
                                leftPadding: 0),
                            AppTextField(
                              inputFormatters: [
                                UpperCaseTextFormatter(),
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[A-Z ]'))
                              ],
                              isEnabled: model.inEditMode,
                              textEditingController: model.nameController,
                              validator: (String value) {
                                return '';
                              },
                              keyboardType: TextInputType.name,
                            ),
                            SizedBox(height: 16),
                            AppTextFieldLabel(
                              locale.pkPanLabel,
                              leftPadding: 0,
                            ),
                            AppTextField(
                              focusNode: model.panFocusNode,
                              inputFormatters: [
                                UpperCaseTextFormatter(),
                                FilteringTextInputFormatter.deny(
                                    RegExp(r'^0+(?!$)')),
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
                            SizedBox(
                              height: SizeConfig.screenHeight * 0.46,
                            ),
                            if (model.inEditMode)
                              Container(
                                width: SizeConfig.screenWidth,
                                child: PropertyChangeConsumer<UserService,
                                        UserServiceProperties>(
                                    properties: [
                                      UserServiceProperties
                                          .myConfirmDialogViewStatus
                                    ],
                                    builder: (context, m, property) =>
                                        FelloButtonLg(
                                            child: model.isKycInProgress ||
                                                    m.isConfirmationDialogOpen
                                                ? SpinKitThreeBounce(
                                                    color: Colors.white,
                                                    size: 20,
                                                  )
                                                : Text(locale.btnSumbit,
                                                    style: TextStyles.rajdhaniB
                                                        .colour(Colors.white)
                                                        .title5),
                                            onPressed: () {
                                              model.panFocusNode.unfocus();
                                              model.onSubmit(context);
                                            })),
                              ),
                            SizedBox(height: 24),
                          ],
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
