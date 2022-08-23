import 'dart:developer';
import 'dart:io';

import 'package:felloapp/ui/pages/login/level_2/complete_profile_vm.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChooseAvatar4 extends StatefulWidget {
  const ChooseAvatar4({Key key, @required this.model}) : super(key: key);
  final CompleteProfileViewModel model;

  @override
  State<ChooseAvatar4> createState() => _ChooseAvatar4State();
}

class _ChooseAvatar4State extends State<ChooseAvatar4> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Spacer(),
        Text(
          'What avatar suits you the best?',
          style: TextStyles.rajdhaniSB.title5,
        ),
        SizedBox(height: SizeConfig.padding8),
        Text(
          'Swipe to choose your avatar',
          style: TextStyles.sourceSans.body3.colour(
            UiConstants.kTextColor.withOpacity(0.5),
          ),
        ),
        SizedBox(height: SizeConfig.screenWidth * 0.15),
        Stack(
          children: [
            AvatarBgRings(),
            Container(
              height: SizeConfig.screenWidth * 0.685,
              child: PageView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: 6,
                controller: widget.model.avatarsPageController,
                onPageChanged: (val) {
                  if (val >= 1) {
                    widget.model.selectedAvaterId = val;
                  } else if (val == 0) {
                    widget.model.selectedAvaterId = null;
                  }
                  widget.model.avatarsPage = val;
                },
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, idx) {
                  return Center(
                    child: AnimatedContainer(
                      width: widget.model.avatarsPage == idx
                          ? SizeConfig.screenWidth * 0.48
                          : SizeConfig.screenWidth * 0.2633,
                      height: widget.model.avatarsPage == idx
                          ? SizeConfig.screenWidth * 0.42
                          : SizeConfig.screenWidth * 0.2633,
                      duration: const Duration(milliseconds: 200),
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: widget.model.avatarsPage == idx ? 1.0 : 0.4,
                        child: idx == 0
                            ? GestureDetector(
                                onTap: () {
                                  if (widget.model.selectedProfilePicture ==
                                      null) {
                                    widget.model.chooseProfileImage();
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFF232326),
                                    shape: BoxShape.circle,
                                  ),
                                  margin: EdgeInsets.only(
                                    bottom: SizeConfig.padding10,
                                    right: SizeConfig.padding8,
                                    left: SizeConfig.padding8,
                                  ),
                                  child: widget.model.selectedProfilePicture ==
                                          null
                                      ? Center(
                                          child: Icon(
                                            Icons.add_rounded,
                                            color: UiConstants.kPrimaryColor,
                                            size: SizeConfig.iconSize7,
                                          ),
                                        )
                                      : ClipOval(
                                          child: Image.file(
                                            File(widget.model
                                                .selectedProfilePicture.path),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.only(
                                  bottom: SizeConfig.padding10,
                                  right: SizeConfig.padding8,
                                  left: SizeConfig.padding8,
                                ),
                                child: SvgPicture.asset(
                                    'assets/svg/userAvatars/AV$idx.svg',
                                    fit: BoxFit.cover),
                              ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        Spacer(),
      ],
    );
  }
}

class AvatarBgRings extends StatelessWidget {
  const AvatarBgRings({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: SizeConfig.screenWidth * 0.66,
        height: SizeConfig.screenWidth * 0.66,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Color(0xFF737373).withOpacity(0.5),
            width: 0.8,
          ),
        ),
        child: Center(
          child: Container(
            width: SizeConfig.screenWidth * 0.54,
            height: SizeConfig.screenWidth * 0.54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: SizeConfig.padding4,
              ),
            ),
            child: Center(
              child: Container(
                width: SizeConfig.screenWidth * 0.4267,
                height: SizeConfig.screenWidth * 0.4267,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xff135756).withOpacity(0.6),
                      blurRadius: SizeConfig.screenWidth * 0.143,
                      spreadRadius: SizeConfig.screenWidth * 0.096,
                    ),
                  ],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color(0xffD9D9D9),
                    width: SizeConfig.padding2,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
