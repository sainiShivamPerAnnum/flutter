import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class NewProfileImage extends StatelessWidget {
  const NewProfileImage({
    required this.image,
    super.key,
    this.showAction = true,
    this.updateProfilePicture,
  });

  final bool showAction;
  final Widget image;
  final VoidCallback? updateProfilePicture;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: SizeConfig.screenWidth! * 0.4667,
          height: SizeConfig.screenWidth! * 0.4667,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: UiConstants.kProfileBorderOutterColor,
              width: SizeConfig.border0,
            ),
          ),
        ),
        Container(
          width: SizeConfig.screenWidth! * 0.3944, // 142
          height: SizeConfig.screenWidth! * 0.3944,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: UiConstants.kTextColor.withOpacity(0.2),
              width: SizeConfig.border2,
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            width: SizeConfig.screenWidth! * 0.335, // 112
            height: SizeConfig.screenWidth! * 0.335,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: UiConstants.kProfileBorderColor,
                width: SizeConfig.border1,
              ),
            ),
            padding: EdgeInsets.all(
              SizeConfig.padding4,
            ),
            child: image,
          ),
        ),
        if (showAction)
          Align(
            alignment: Alignment.center,
            child: Container(
              width: SizeConfig.screenWidth! * 0.3111, // 112
              height: SizeConfig.screenWidth! * 0.3111,
              alignment: Alignment.bottomRight,
              child: InkWell(
                onTap: updateProfilePicture,
                child: Container(
                  height: SizeConfig.padding40, // 20
                  width: SizeConfig.padding40, // 20
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: UiConstants.kTextColor,
                  ),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    size: SizeConfig.padding24,
                    color: UiConstants.kTabBorderColor,
                  ),
                ),
              ),
            ),
          )
      ],
    );
  }
}
