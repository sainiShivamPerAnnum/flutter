import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/repository/user_repo.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class SecurityModalSheet extends StatelessWidget {
  SecurityModalSheet();
  final UserRepository userRepo = locator<UserRepository>();
  final UserService userService = locator<UserService>();
  @override
  Widget build(BuildContext context) {
    final baseProvider = Provider.of<BaseUtil>(context, listen: false);
    return Padding(
      padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: SvgPicture.asset(
              Assets.sprout,
              fit: BoxFit.contain,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Secure Fello', style: TextStyles.rajdhaniB.title3),
            ],
          ),
          SizedBox(
            height: SizeConfig.padding8,
          ),
          Text(
              'Protect your Fello account by using your phone\'s default security.',
              textAlign: TextAlign.center,
              style: TextStyles.sourceSans.body2),
          Container(
            margin: EdgeInsets.only(
                top: SizeConfig.padding16, bottom: SizeConfig.padding24),
            width: SizeConfig.screenWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppPositiveBtn(
                  btnText: 'Enable',
                  onPressed: () {
                    // baseProvider.flipSecurityValue(true);
                    userRepo.updateUser(dMap: {
                      BaseUser.fldUserPrefs: {"tn": 1, "al": 1},
                    }).then((value) => userService.setBaseUser());

                    AppState.backButtonDispatcher.didPopRoute();
                  },
                ),
                SizedBox(height: SizeConfig.padding16),
                AppNegativeBtn(
                  width: SizeConfig.screenWidth,
                  btnText: "Not Now",
                  onPressed: () {
                    AppState.backButtonDispatcher.didPopRoute();
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
