import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/login/login_components/login_image.dart';
import 'package:felloapp/ui/pages/login/login_controller_vm.dart';
import 'package:felloapp/ui/pages/login/screens/mobile_input/mobile_input_vm.dart';
import 'package:felloapp/ui/pages/login/screens/name_input/name_input_view.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class LoginMobileView extends StatefulWidget {
  static const int index = 0;
  const LoginMobileView({
    required this.loginModel,
    super.key,
  });
  final LoginControllerViewModel loginModel;

  @override
  State<LoginMobileView> createState() => LoginMobileViewState();
}

class LoginMobileViewState extends State<LoginMobileView> {
  late LoginMobileViewModel model;
  S locale = locator<S>();

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginMobileViewModel>(
      onModelReady: (model) => this.model = model,
      builder: (ctx, model, child) {
        return ListView(
          controller: widget.loginModel.phoneScrollController,
          shrinkWrap: true,
          key: const ValueKey('mobileInputScreenText'),
          children: [
            const LoginImage(),
            SizedBox(height: SizeConfig.padding68),
            Container(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter your phone number',
                    style: TextStyles.sourceSansSB.body1,
                  ),
                  SizedBox(height: SizeConfig.padding10),
                  Form(
                    key: model.formKey,
                    child: AppTextField(
                      fillColor: UiConstants.greyVarient,
                      hintText: locale.obEnterMobile,
                      isEnabled: widget.loginModel.state == ViewState.Idle &&
                          !widget.loginModel.loginUsingTrueCaller,
                      focusNode: model.mobileFocusNode,
                      key: model.phoneFieldKey,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      maxLength: 10,
                      // prefixText: "+91 ",
                      // prefixTextStyle: TextStyles.sourceSans.body3,
                      scrollPadding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom >
                                SizeConfig.screenHeight! / 3
                            ? SizeConfig.screenHeight! * 0.1
                            : 0,
                      ),
                      textStyle: TextStyles.sourceSans.body3,
                      suffixIcon: model.showTickCheck
                          ? Icon(
                              Icons.done,
                              color: UiConstants.primaryColor,
                              size: SizeConfig.iconSize0,
                            )
                          : const SizedBox.shrink(),
                      textEditingController: model.mobileController,
                      onChanged: (value) => model.upDateCheckTick(),
                      onTap: () {
                        if (widget.loginModel.loginUsingTrueCaller) return;
                        model.showAvailablePhoneNumbers();
                        Future.delayed(const Duration(milliseconds: 500), () {
                          widget.loginModel.phoneScrollController.animateTo(
                            widget.loginModel.phoneScrollController.position
                                .maxScrollExtent,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn,
                          );
                        });
                      },
                      validator: (value) => model.validateMobile(),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.padding30,
                  ),
                  Consumer<LoginControllerViewModel>(
                    builder: (context, model, child) {
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () =>
                              model.processScreenInput(model.currentPage),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(
                                SizeConfig.padding325, SizeConfig.padding48),
                            backgroundColor: UiConstants.kTextColor,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(SizeConfig.roundness8),
                            ),
                          ),
                          child: model.state == ViewState.Busy
                              ? SizedBox(
                                  width: SizeConfig.padding32,
                                  child: SpinKitThreeBounce(
                                    color: UiConstants.kTextColor4,
                                    size: SizeConfig.padding20,
                                  ),
                                )
                              : Text(
                                  model.currentPage == LoginNameInputView.index
                                      ? locale.obFinish
                                      : locale.obNext,
                                  style: TextStyles.sourceSansSB.body3
                                      .colour(UiConstants.kTextColor4),
                                ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 100),
          ],
        );
      },
    );
  }
}
