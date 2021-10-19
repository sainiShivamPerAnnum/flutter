import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FelloTile extends StatelessWidget {
  final String leadingAsset;
  final IconData leadingIcon;
  final String title;
  final String subtitle;
  final IconData trailingIcon;
  final Function onTap;

  FelloTile(
      {this.leadingIcon,
      this.leadingAsset,
      this.subtitle,
      this.title,
      this.trailingIcon,
      this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: SizeConfig.screenWidth * 0.25,
        decoration: BoxDecoration(
          color: Color(0xffF6F9FF),
          borderRadius: BorderRadius.circular(SizeConfig.roundness16),
        ),
        padding: EdgeInsets.all(SizeConfig.padding24),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Color(0xffE3F4F7),
              radius: SizeConfig.screenWidth * 0.067,
              child: leadingIcon != null
                  ? Icon(
                      leadingIcon,
                      size: SizeConfig.padding32,
                      color: UiConstants.primaryColor,
                    )
                  : SvgPicture.asset(
                      leadingAsset ?? "assets/vectors/icons/tickets.svg",
                      height: SizeConfig.padding32,
                      width: SizeConfig.padding32,
                      color: UiConstants.primaryColor,
                    ),
            ),
            SizedBox(
              width: SizeConfig.padding12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    child: Text(
                      title ?? "title",
                      style: TextStyles.body1.bold,
                    ),
                  ),
                  SizedBox(height: SizeConfig.padding4),
                  FittedBox(
                    child: Text(
                      subtitle ?? "subtitle",
                      style: TextStyles.body3.colour(Colors.grey),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(width: SizeConfig.padding12),
            Icon(
              trailingIcon ?? Icons.arrow_right_rounded,
              size: SizeConfig.padding24,
              color: UiConstants.primaryColor,
            )
          ],
        ),
      ),
    );
  }
}

class FelloBriefTile extends StatelessWidget {
  final String leadingAsset;
  final IconData leadingIcon;
  final String title;
  final IconData trailingIcon;
  final Function onTap;

  FelloBriefTile({
    this.leadingIcon,
    this.leadingAsset,
    this.title,
    this.trailingIcon,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        height: SizeConfig.screenWidth * 0.193,
        decoration: BoxDecoration(
          color: Color(0xffF6F9FF),
          borderRadius: BorderRadius.circular(SizeConfig.roundness16),
        ),
        padding: EdgeInsets.all(SizeConfig.padding16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Color(0xffE3F4F7),
              radius: SizeConfig.padding24,
              child: leadingIcon != null
                  ? Icon(
                      leadingIcon,
                      size: SizeConfig.padding24,
                      color: UiConstants.primaryColor,
                    )
                  : SvgPicture.asset(
                      leadingAsset ?? "assets/vectors/icons/tickets.svg",
                      height: SizeConfig.padding24,
                      width: SizeConfig.padding24,
                      color: UiConstants.primaryColor,
                    ),
            ),
            SizedBox(
              width: SizeConfig.padding12,
            ),
            Expanded(
              child: Text(
                title ?? "title",
                overflow: TextOverflow.clip,
                maxLines: 2,
                style: TextStyles.body2.bold,
              ),
            ),
            SizedBox(width: SizeConfig.padding12),
            Icon(
              trailingIcon ?? Icons.arrow_right_rounded,
              size: SizeConfig.padding24,
              color: UiConstants.primaryColor,
            )
          ],
        ),
      ),
    );
  }
}
