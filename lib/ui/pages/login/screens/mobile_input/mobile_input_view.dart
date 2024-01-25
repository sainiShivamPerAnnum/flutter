import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/login/login_components/login_image.dart';
import 'package:felloapp/ui/pages/login/login_controller_vm.dart';
import 'package:felloapp/ui/pages/login/screens/mobile_input/mobile_input_vm.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const LoginImage(),
            SizedBox(height: SizeConfig.padding8),
            Text(
              locale.obLoginHeading,
              style: TextStyles.rajdhaniB.title2,
            ),
            SizedBox(height: SizeConfig.padding20),
            Form(
              key: model.formKey,
              child: AppTextField(
                hintText: locale.obEnterMobile,
                isEnabled: widget.loginModel.state == ViewState.Idle &&
                    !widget.loginModel.loginUsingTrueCaller,
                focusNode: model.mobileFocusNode,
                key: model.phoneFieldKey,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 10,
                prefixText: "+91 ",
                prefixTextStyle: TextStyles.sourceSans.body3,
                scrollPadding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom >
                            SizeConfig.screenHeight! / 3
                        ? SizeConfig.screenHeight! * 0.1
                        : 0),
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
                },
                validator: (value) => model.validateMobile(),
                margin: EdgeInsets.symmetric(
                    horizontal: SizeConfig.pageHorizontalMargins * 2),
              ),
            ),
          ],
        );
      },
    );
  }
}
