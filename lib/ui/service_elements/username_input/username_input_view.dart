import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/modals_sheets/coupon_modal_sheet.dart';
import 'package:felloapp/ui/pages/others/profile/userProfile/userProfile_viewModel.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UsernameInputView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<UserProfileVM>(
      onModelReady: (model) => model.usernameInit(),
      onModelDispose: (model) => model.usernameDispose(),
      builder: ((context, model, child) => Container(
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            width: SizeConfig.screenWidth,
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.pageHorizontalMargins),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: SizeConfig.padding32),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Create your username',
                              style: TextStyles.rajdhaniB.title3,
                            ),
                            SizedBox(height: SizeConfig.padding6),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "This will be your unique name across our games and challenges leaderboard",
                                style: TextStyles.sourceSans.body3
                                    .colour(UiConstants.kTextColor2),
                              ),
                            )
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            AppState.backButtonDispatcher!.didPopRoute();
                          },
                          child: Icon(
                            Icons.close,
                            color: UiConstants.kTextColor,
                            size: SizeConfig.padding24,
                          ),
                        )
                      ],
                    ),
                  ),
                  AppTextField(
                    hintText: 'Your username',
                    onTap: () {},
                    prefixText: '@',
                    autoFocus: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textEditingController: model.usernameController,
                    isEnabled: model.inEditMode,
                    inputFormatters: [
                      LowerCaseTextFormatter(),
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[A-Za-z0-9.]'),
                      )
                    ],
                    validator: (val) {
                      if (val == null || val.isEmpty)
                        return "";
                      else
                        return null;
                    },
                    onChanged: (String value) {
                      model.validateUsername();
                    },
                  ),
                  Container(
                    height: model.errorPadding,
                  ),
                  if (model.showResult().runtimeType != SizedBox)
                    Container(
                      height: SizeConfig.padding20,
                      child: model.showResult(),
                    ),
                  Container(
                    width: SizeConfig.screenWidth,
                    margin: EdgeInsets.symmetric(
                      vertical: SizeConfig.pageHorizontalMargins,
                    ),
                    child: model.isUpdaingUserDetails
                        ? LinearProgressIndicator(
                            backgroundColor: Colors.black,
                          )
                        : AppPositiveBtn(
                            btnText: "ADD",
                            onPressed: () => model.updateUsername()),
                  )
                ]),
          )),
    );
  }
}

class ModalSheetAppBar extends StatelessWidget {
  final Widget? leading;
  final String? title;
  final String? subtitle;
  final Widget? trailing;

  const ModalSheetAppBar(
      {Key? key, this.leading, this.title, this.subtitle, this.trailing})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title ?? 'Digital Gold', style: TextStyles.rajdhaniSB.body2),
      subtitle: Text(
        subtitle ?? "Safest Digital Investment",
        style: TextStyles.sourceSans.body4.colour(UiConstants.kTextColor3),
      ),
      trailing: trailing ??
          IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: () {
              AppState.backButtonDispatcher!.didPopRoute();
            },
          ),
    );
  }
}
