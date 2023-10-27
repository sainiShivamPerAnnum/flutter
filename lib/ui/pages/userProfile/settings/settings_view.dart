import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/login/screens/name_input/name_input_view.dart';
import 'package:felloapp/ui/pages/userProfile/settings/settings_vm.dart';
import 'package:felloapp/ui/service_elements/user_service/profile_image.dart';
import 'package:felloapp/ui/service_elements/user_service/user_name_text.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return BaseView<SettingsViewModel>(
      onModelReady: (model) => model.init(),
      onModelDispose: (model) {},
      builder: ((context, model, child) => Scaffold(
            backgroundColor: UiConstants.kBackgroundColor,
            appBar: AppBar(
              title: Text(
                locale.settings,
                style: TextStyles.rajdhaniSB.title4,
              ),
              elevation: 0,
              backgroundColor: UiConstants.kSecondaryBackgroundColor,
            ),
            body: ListView(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: SizeConfig.padding16),
                  padding: EdgeInsets.only(bottom: SizeConfig.padding32),
                  width: SizeConfig.screenWidth,
                  color: UiConstants.kSecondaryBackgroundColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FelloUserAvatar(
                        child: ProfileImageSE(
                          radius: SizeConfig.screenWidth! * 0.16,
                        ),
                      ),
                      UserNameTextSE(),
                      Text(
                        '@${model.username}',
                        style: TextStyles.sourceSans.body3
                            .colour(UiConstants.kTextColor2),
                      ),
                    ],
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: model.items!.length,
                  separatorBuilder: (ctx, i) {
                    if (i != model.items!.length - 1) {
                      return Divider(
                        color: UiConstants.kTextColor3.withOpacity(0.2),
                        endIndent: SizeConfig.pageHorizontalMargins,
                        indent: SizeConfig.pageHorizontalMargins,
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                  itemBuilder: (context, i) => ListTile(
                    onTap: () {
                      Haptic.vibrate();
                      AppState.delegate!
                          .parseRoute(Uri.parse(model.items![i].actionUri));
                    },
                    contentPadding: EdgeInsets.symmetric(
                        vertical: SizeConfig.padding4,
                        horizontal: SizeConfig.pageHorizontalMargins),
                    leading: SvgPicture.asset(model.items![i].asset,
                        width: SizeConfig.padding28,
                        height: SizeConfig.padding28,
                        fit: BoxFit.contain),
                    title: Text(model.items![i].title,
                        style: TextStyles.body1.colour(Colors.white)),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
