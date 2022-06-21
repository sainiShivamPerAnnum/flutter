import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class NewProfileImage extends StatelessWidget {
  const NewProfileImage({
    Key key,
    @required this.image,
    this.onShowImagePicker,
  }) : super(key: key);

  final onShowImagePicker;
  final image;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: SizeConfig.screenWidth * 0.4667,
          height: SizeConfig.screenWidth * 0.4667,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: UiConstants.kProfileBorderOutterColor,
              width: SizeConfig.border0,
            ),
          ),
        ),
        Positioned(
          bottom: (SizeConfig.screenWidth * 0.4667) * 0.25, // 168 * 0.25
          left: 0,
          child: Container(
            height: SizeConfig.padding6,
            width: SizeConfig.padding6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: UiConstants.kTextColor,
            ),
          ),
        ),
        Container(
          width: SizeConfig.screenWidth * 0.3944, // 142
          height: SizeConfig.screenWidth * 0.3944,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: UiConstants.kTextColor.withOpacity(0.2),
              width: SizeConfig.border2,
            ),
          ),
        ),
        Positioned(
          bottom: SizeConfig.screenWidth * 0.3333, //120
          right: (SizeConfig.screenWidth * 0.0639), // 23
          child: Container(
            height: SizeConfig.padding6,
            width: SizeConfig.padding6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: UiConstants.kTextColor,
            ),
          ),
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: SizeConfig.screenWidth * 0.3111, // 112
              height: SizeConfig.screenWidth * 0.3111,
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
            if (onShowImagePicker != null)
              Positioned(
                bottom: SizeConfig.padding6, // 5
                right: SizeConfig.padding12, // 10
                child: InkWell(
                  onTap: onShowImagePicker == null ? () {} : onShowImagePicker,
                  child: Container(
                    height: SizeConfig.screenWidth * 0.0556, // 20
                    width: SizeConfig.screenWidth * 0.0556, // 20
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: UiConstants.kTextColor,
                    ),
                    child: Icon(
                      Icons.camera_alt_rounded,
                      size: SizeConfig.iconSize2,
                      color: UiConstants.kTabBorderColor,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
