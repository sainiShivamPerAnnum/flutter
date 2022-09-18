import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/others/profile/userProfile/userProfile_viewModel.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProfileAppBar extends StatelessWidget with PreferredSizeWidget {
  const ProfileAppBar({
    Key key,
    @required this.isNewUser,
    @required this.model,
  }) : super(key: key);
  final UserProfileVM model;
  final bool isNewUser;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: isNewUser
          ? Colors.transparent
          : UiConstants.kSecondaryBackgroundColor,
      elevation: 0.0,
      title: Text(
        'My Profile',
        style: TextStyles.rajdhaniSB.title4,
      ),
      centerTitle: false,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_rounded,
          color: UiConstants.kTextColor,
        ),
        onPressed: () => AppState.backButtonDispatcher.didPopRoute(),
      ),
      actions: [
        if (!isNewUser)
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
                          'EDIT',
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
                          'DONE',
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
