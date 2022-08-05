import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/others/finance/upi/upi_vm.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class UserUPIDetailsView extends StatelessWidget {
  const UserUPIDetailsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<UserUPIDetailsViewModel>(
      onModelReady: (model) => model.init(),
      onModelDispose: (model) => model.dump(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: UiConstants.primaryColor,
        body: HomeBackground(
          child: Stack(
            children: [
              Column(
                children: [
                  FelloAppBar(
                    leading: FelloAppBarBackButton(),
                    title: "UPI Details",
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(SizeConfig.padding40),
                            topRight: Radius.circular(SizeConfig.padding40),
                          ),
                          color: Colors.white),
                      child: model.state == ViewState.Busy
                          ? Container(
                              child: Center(
                                child: SpinKitWave(
                                  color: UiConstants.primaryColor,
                                  size: 30,
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                              child: Padding(
                                padding: EdgeInsets.all(
                                    SizeConfig.pageHorizontalMargins),
                                child: Form(
                                  key: model.formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "UPI Address",
                                        style: TextStyles.body3,
                                      ),
                                      SizedBox(height: 6),
                                      TextFormField(
                                        autofocus: true,
                                        enabled: model.inEditMode,
                                        keyboardType: TextInputType.name,
                                        inputFormatters: [],
                                        textCapitalization:
                                            TextCapitalization.none,
                                        controller: model.upiController,
                                        validator: (value) {
                                          return (value == null ||
                                                  value.isEmpty ||
                                                  value.trim().length < 4)
                                              ? 'Please enter a valid UPI Id'
                                              : null;
                                        },
                                        focusNode: model.focusNode,
                                        onFieldSubmitted: (v) {
                                          FocusScope.of(context).nextFocus();
                                        },
                                      ),
                                      if (model.inEditMode)
                                        Container(
                                          width: SizeConfig.screenWidth,
                                          margin: EdgeInsets.symmetric(
                                              vertical: SizeConfig.padding12),
                                          child: Wrap(
                                            runSpacing: SizeConfig.padding8,
                                            spacing: SizeConfig.padding12,
                                            children: [
                                              upichips('@upi', model),
                                              upichips('@apl', model),
                                              upichips('@fbl', model),
                                              upichips('@ybl', model),
                                              upichips('@paytm', model),
                                              upichips('@okhdfcbank', model),
                                              upichips('@okaxis', model),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
              if (model.state == ViewState.Idle)
                Positioned(
                  bottom: 20,
                  child: SafeArea(
                    child: Container(
                      width: SizeConfig.screenWidth,
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.pageHorizontalMargins),
                      child: Container(
                        width: SizeConfig.navBarWidth,
                        child: FelloButtonLg(
                          child: (!model.isUpiVerificationInProgress)
                              ? Text(
                                  model.inEditMode ? 'UPDATE' : 'EDIT',
                                  style: Theme.of(context)
                                      .textTheme
                                      .button
                                      .copyWith(color: Colors.white),
                                )
                              : SpinKitThreeBounce(
                                  color: UiConstants.spinnerColor2,
                                  size: 18.0,
                                ),
                          onPressed: () {
                            if (model.inEditMode) {
                              FocusScope.of(context).unfocus();
                              if (BaseUtil.showNoInternetAlert()) return;
                              if (model.formKey.currentState.validate()) {
                                model.verifyUpiId();
                              }
                            } else {
                              model.inEditMode = true;
                              Future.delayed(
                                Duration(milliseconds: 500),
                                () {
                                  FocusScope.of(context)
                                      .requestFocus(model.focusNode);
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  upichips(String suffix, UserUPIDetailsViewModel model) {
    return InkWell(
      onTap: () {
        Haptic.vibrate();
        model.upiController.text =
            model.upiController.text.trim().split('@').first + suffix;
      },
      child: Container(
        decoration: BoxDecoration(
          color: UiConstants.primaryLight.withOpacity(0.5),
          borderRadius: BorderRadius.circular(SizeConfig.roundness12),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.padding12,
          vertical: SizeConfig.padding8,
        ),
        margin: EdgeInsets.only(bottom: SizeConfig.padding4),
        child: Text(
          suffix,
          style: TextStyles.body3,
        ),
      ),
    );
  }
}
