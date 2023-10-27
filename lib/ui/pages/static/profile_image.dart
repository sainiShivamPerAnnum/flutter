import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class NewProfileImage extends StatelessWidget {
  const NewProfileImage({
    required this.image,
    Key? key,
    this.showAction = true,
    this.updateProfilePicture,
    // this.model,
  }) : super(key: key);

  final bool showAction;
  final Widget image;
  final Function? updateProfilePicture;

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
        // Positioned(
        //   bottom: (SizeConfig.screenWidth * 0.4667) * 0.25, // 168 * 0.25
        //   left: 0,
        //   child: Container(
        //     height: SizeConfig.padding6,
        //     width: SizeConfig.padding6,
        //     decoration: BoxDecoration(
        //       shape: BoxShape.circle,
        //       color: UiConstants.kTextColor,
        //     ),
        //   ),
        // ),
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
        // Positioned(
        //   bottom: SizeConfig.screenWidth * 0.3333, //120
        //   right: (SizeConfig.screenWidth * 0.0639), // 23
        //   child: Container(
        //     height: SizeConfig.padding6,
        //     width: SizeConfig.padding6,
        //     decoration: BoxDecoration(
        //       shape: BoxShape.circle,
        //       color: UiConstants.kTextColor,
        //     ),
        //   ),
        // ),
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
          // isNewUser
          //     ? Align(
          //         alignment: Alignment.center,
          //         child: Container(
          //           width: SizeConfig.screenWidth! * 0.3111, // 112
          //           height: SizeConfig.screenWidth! * 0.3111,
          //           decoration: BoxDecoration(
          //             color: Colors.black.withOpacity(0.6),
          //             shape: BoxShape.circle,
          //           ),
          //           padding: EdgeInsets.all(
          //             SizeConfig.padding4,
          //           ),
          //           child: IconButton(
          //             icon: Icon(
          //               Icons.add_rounded,
          //               color: Colors.white.withOpacity(0.9),
          //               size: SizeConfig.padding80,
          //             ),
          //             onPressed:
          //                 updateProfilePicture as void Function()? ?? () {},
          //           ),
          //         ),
          //       )
          //     :
          Align(
            alignment: Alignment.center,
            child: Container(
              width: SizeConfig.screenWidth! * 0.3111, // 112
              height: SizeConfig.screenWidth! * 0.3111,
              alignment: Alignment.bottomRight,
              child: InkWell(
                onTap: updateProfilePicture as void Function()?,
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
