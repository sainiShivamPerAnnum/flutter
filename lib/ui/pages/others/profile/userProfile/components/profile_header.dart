import 'package:felloapp/ui/pages/others/profile/userProfile/components/user_brief.dart';
import 'package:felloapp/ui/pages/others/profile/userProfile/userProfile_viewModel.dart';
import 'package:felloapp/ui/pages/static/profile_image.dart';
import 'package:felloapp/ui/service_elements/user_service/profile_image.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    Key key,
    @required this.model,
  }) : super(key: key);

  final UserProfileVM model;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: SizeConfig.padding40,
      ),
      width: SizeConfig.screenWidth,
      decoration: BoxDecoration(
        color: model.isNewUser
            ? Colors.transparent
            : UiConstants.kSecondaryBackgroundColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(SizeConfig.roundness24),
          bottomRight: Radius.circular(SizeConfig.roundness24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          NewProfileImage(
            isNewUser: model.isNewUser,
            updateProfilePicture: model.showCustomAvatarsDialog,
            image: ProfileImageSE(
              radius: SizeConfig.screenWidth * 0.25,
            ),
          ),
          SizedBox(height: SizeConfig.padding6),
          if (!model.isNewUser)
            UserBrief(
              model: model,
            ),
          if (model.isNewUser)
            Text(
              "Change your avatar",
              style:
                  TextStyles.sourceSans.body2.colour(UiConstants.kTextColor2),
            ),
          if (!model.isNewUser) SizedBox(height: SizeConfig.padding24)
        ],
      ),
    );
  }
}
