import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/userProfile/userProfile/userProfile_viewModel.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({
    // required this.isNewUser,
    required this.model,
    Key? key,
  }) : super(key: key);
  final UserProfileVM model;
  // final bool isNewUser;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return AppBar(
      backgroundColor:
          //  isNewUser
          //     ? Colors.transparent
          //     :
          UiConstants.kSecondaryBackgroundColor,
      elevation: 0.0,
      title: Text(
        locale.abMyProfile,
        style: TextStyles.rajdhaniSB.title4,
      ),
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_rounded,
          color: UiConstants.kTextColor,
        ),
        onPressed: () => AppState.backButtonDispatcher!.didPopRoute(),
      ),
      actions: [
        // if (!isNewUser)
        Padding(
          padding: EdgeInsets.only(right: SizeConfig.padding16),
          child: model.isUpdaingUserDetails
              ? Padding(
                  padding: EdgeInsets.only(right: SizeConfig.padding12),
                  child: SpinKitThreeBounce(
                    color: Colors.white,
                    size: SizeConfig.padding16,
                  ),
                )
              : (!model.inEditMode
                  ? TextButton.icon(
                      icon: Icon(Icons.edit_outlined,
                          size: SizeConfig.iconSize2,
                          color: UiConstants.kTextColor),
                      // SizedBox(width: SizeConfig.padding8),
                      label: Text(
                        locale.obEdit,
                        style: TextStyles.sourceSansSB.body2,
                      ),
                      onPressed: () => model.enableEdit(),
                    )
                  : TextButton(
                      onPressed: () {
                        if (!model.isUpdaingUserDetails) {
                          FocusScope.of(context).unfocus();
                          model.updateDetails();
                        }
                      },
                      child: Text(
                        locale.obDone,
                        style: TextStyles.sourceSansSB.body2.colour(
                          UiConstants.kTabBorderColor,
                        ),
                      ),
                    )),
        ),
      ],
    );
  }
}
