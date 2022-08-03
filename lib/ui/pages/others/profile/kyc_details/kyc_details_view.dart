import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_home/tambola_home_view.dart';
import 'package:felloapp/ui/pages/others/profile/kyc_details/kyc_details_vm.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
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
              FelloAppBarV2(
                leading: FelloAppBarBackButtonV2(),
                title: 'KYC & PAN',
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  locale.kycNameLabel,
                                  style: TextStyles.sourceSansM.copyWith(
                                    color: UiConstants.kTextColor2,
                                  ),
                                ),
                                SizedBox(height: 6),
                                TextFormField(
                                  autofocus: true,
                                  //initialValue: model.myname,
                                  inputFormatters: [
                                    UpperCaseTextFormatter(),
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[A-Z ]'))
                                  ],
                                  enabled: model.inEditMode,
                                  decoration: InputDecoration(
                                    fillColor: UiConstants.kTextFieldColor,
                                    // focusedBorder: OutlineInputBorder(
                                    //   borderRadius: BorderRadius.all(
                                    //     Radius.circular(5.0),
                                    //   ),
                                    // ),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5.0),
                                        ),
                                        borderSide: BorderSide.none),
                                    filled: true,
                                  ),
                                  controller: model.nameController,
                                  keyboardType: TextInputType.name,
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  locale.pkPanLabel,
                                  style: TextStyles.sourceSansM.copyWith(
                                    color: UiConstants.kTextColor2,
                                  ),
                                ),
                                SizedBox(height: 6),
                                TextFormField(
                                  //initialValue: model.myname,
                                  enabled: model.inEditMode,
                                  controller: model.panController,
                                  focusNode: model.panFocusNode,
                                  inputFormatters: [
                                    UpperCaseTextFormatter(),
                                    FilteringTextInputFormatter.deny(
                                        RegExp(r'^0+(?!$)')),
                                    LengthLimitingTextInputFormatter(10)
                                  ],
                                  decoration: InputDecoration(
                                    fillColor: UiConstants.kTextFieldColor,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide.none),
                                    // focusedBorder: InputBorder.none,
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5.0),
                                        ),
                                        borderSide: BorderSide.none),
                                    filled: true,
                                  ),
                                  textCapitalization:
                                      TextCapitalization.characters,
                                  keyboardType: model.panTextInputType,
                                  onChanged: (val) {
                                    // if (model.onPanEntered()) {
                                    //   Future.delayed(Duration(milliseconds: 5),
                                    //       () {
                                    //     FocusScope.of(context)
                                    //         .requestFocus(model.panFocusNode);
                                    //   });
                                    // }
                                    print("val changed");
                                    model.checkForKeyboardChange(val.trim());
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
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
                                                : Text(
                                                    locale.btnSumbit,
                                                    style: TextStyles.body2
                                                        .colour(Colors.white)
                                                        .bold,
                                                  ),
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
