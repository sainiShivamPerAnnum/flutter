import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/repository/user_repo.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SecurityModalSheet extends StatelessWidget {
  SecurityModalSheet({super.key});
  final UserRepository? userRepo = locator<UserRepository>();
  S locale = locator<S>();
  final UserService? userService = locator<UserService>();
  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return WillPopScope(
      onWillPop: () async {
        await AppState.backButtonDispatcher!.didPopRoute();
        return Future.value(true);
      },
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                width: SizeConfig.screenWidth,
                padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                child: SvgPicture.asset(
                  "assets/svg/safety_asset.svg",
                  width: SizeConfig.screenWidth! * 0.15,
                ),
              ),
            ),
            Text(locale.secureFelloTitle, style: TextStyles.rajdhaniB.title3),
            SizedBox(
              height: SizeConfig.padding8,
            ),
            Text(locale.protectFelloAcc,
                textAlign: TextAlign.center,
                style: TextStyles.sourceSans.body2),
            Container(
              margin: EdgeInsets.only(
                  top: SizeConfig.padding16, bottom: SizeConfig.padding24),
              width: SizeConfig.screenWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReactivePositiveAppButton(
                    btnText: locale.btnEnable,
                    onPressed: () async {
                      // baseProvider.flipSecurityValue(true);
                      await userRepo!.updateUser(dMap: {
                        BaseUser.fldUserPrefsTn: true,
                        BaseUser.fldUserPrefsAl: true,
                      }).then((value) => userService!.setBaseUser());

                      await AppState.backButtonDispatcher!.didPopRoute();
                    },
                  ),
                  SizedBox(height: SizeConfig.padding16),
                  AppNegativeBtn(
                    width: SizeConfig.screenWidth,
                    btnText: locale.btnNotNow,
                    onPressed: () {
                      AppState.backButtonDispatcher!.didPopRoute();
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
