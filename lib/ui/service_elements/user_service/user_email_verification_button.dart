import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class UserEmailVerificationButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return PropertyChangeConsumer<UserService, UserServiceProperties>(
      properties: const [
        UserServiceProperties.myEmailVerification,
        UserServiceProperties.myEmail
      ],
      builder: (context, model, property) => model!.isEmailVerified
          ? Icon(
              Icons.verified,
              color: UiConstants.primaryColor,
              size: SizeConfig.iconSize1,
            )
          : model.email == null || model.email!.isEmpty
              ? const SizedBox()
              : InkWell(
                  child: // SizedBox(),
                      FittedBox(
                    child: Text(
                      locale.obVerify,
                      style: TextStyles.body3.bold
                          .colour(UiConstants.primaryColor),
                    ),
                  ),
                  onTap: () {
                    AppState.delegate!.appState.currentAction = PageAction(
                      state: PageState.addPage,
                      page: VerifyEmailPageConfig,
                    );
                  },
                ),
    );
  }
}

class UserEmailVerificationMark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<UserService, UserServiceProperties>(
      properties: const [UserServiceProperties.myEmailVerification],
      builder: (context, model, property) => model!.isEmailVerified ?? false
          ? const Icon(
              Icons.verified,
              color: UiConstants.primaryColor,
            )
          : const SizedBox(),
    );
  }
}
