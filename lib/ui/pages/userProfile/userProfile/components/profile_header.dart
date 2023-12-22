import 'package:felloapp/ui/pages/static/profile_image.dart';
import 'package:felloapp/ui/pages/userProfile/userProfile/components/user_brief.dart';
import 'package:felloapp/ui/pages/userProfile/userProfile/userProfile_viewModel.dart';
import 'package:felloapp/ui/service_elements/user_service/profile_image.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    required this.model,
    Key? key,
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
        color: UiConstants.kSecondaryBackgroundColor,
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
            updateProfilePicture: model.showCustomAvatarsDialog,
            image: ProfileImageSE(
              radius: SizeConfig.screenWidth! * 0.25,
              reactive: false,
            ),
          ),
          SizedBox(height: SizeConfig.padding6),
          UserBrief(model: model),
          SizedBox(height: SizeConfig.padding12),
          Container(
            width: SizeConfig.screenWidth,
            margin: EdgeInsets.symmetric(
                horizontal: SizeConfig.pageHorizontalMargins),
            alignment: Alignment.center,
            child: Text(
              "Joined Fello on ${model.joinedData}",
              style: TextStyles.body4.colour(Colors.white38),
            ),
          ),
          SizedBox(height: SizeConfig.padding12),
        ],
      ),
    );
  }
}
