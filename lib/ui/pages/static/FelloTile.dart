import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FelloTile extends StatelessWidget {
  final String? leadingAsset;
  final IconData? leadingIcon;
  final String? title;
  final String? subtitle;
  final IconData? trailingIcon;
  final Function? onTap;
  final bool showTrailingIcon;

  const FelloTile(
      {this.leadingIcon,
      this.leadingAsset,
      this.subtitle,
      this.title,
      this.trailingIcon,
      this.onTap,
      this.showTrailingIcon = true});
  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return InkWell(
      onTap: () => onTap!(),
      child: Container(
        height: SizeConfig.screenWidth! * 0.25,
        decoration: BoxDecoration(
          color: const Color(0xff464649),
          borderRadius: BorderRadius.circular(SizeConfig.roundness16),
        ),
        padding: EdgeInsets.all(SizeConfig.padding24),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xff464649),
              radius: SizeConfig.screenWidth! * 0.067,
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
                      color: UiConstants.tertiarySolid,
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
                      title ?? locale.title.toLowerCase(),
                      style: TextStyles.sourceSansSB.body2,
                    ),
                  ),
                  SizedBox(height: SizeConfig.padding4),
                  FittedBox(
                    child: Text(
                      subtitle ?? locale.subTitle.toLowerCase(),
                      style: TextStyles.sourceSans.body3.colour(Colors.grey),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FelloBriefTile extends StatelessWidget {
  final String? leadingAsset;
  final IconData? leadingIcon;
  final String? title;
  final String? subtitle;
  final IconData? trailingIcon;
  final Function? onTap;
  final bool coloredIcon;

  const FelloBriefTile(
      {this.leadingIcon,
      this.leadingAsset,
      this.title,
      this.trailingIcon,
      this.subtitle,
      this.onTap,
      this.coloredIcon = false});
  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return InkWell(
      onTap: onTap as void Function()?,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        height: SizeConfig.screenWidth! * 0.193,
        decoration: BoxDecoration(
          color: const Color(0xffF6F9FF),
          borderRadius: BorderRadius.circular(SizeConfig.roundness16),
        ),
        padding: EdgeInsets.all(SizeConfig.padding16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xffE3F4F7),
              radius: SizeConfig.padding24,
              child: leadingIcon != null
                  ? Icon(
                      leadingIcon,
                      size: SizeConfig.padding24,
                      color: UiConstants.primaryColor,
                    )
                  : (coloredIcon
                      ? SvgPicture.asset(
                          leadingAsset ?? "assets/vectors/icons/tickets.svg",
                          height: SizeConfig.padding24,
                          width: SizeConfig.padding24,
                          color: UiConstants.primaryColor,
                        )
                      : SvgPicture.asset(
                          leadingAsset ?? "assets/vectors/icons/tickets.svg",
                          height: SizeConfig.padding24,
                          width: SizeConfig.padding24,
                        )),
            ),
            SizedBox(
              width: SizeConfig.padding12,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title ?? locale.title.toLowerCase(),
                  overflow: TextOverflow.clip,
                  maxLines: 2,
                  style: TextStyles.body2.bold,
                ),
                if (subtitle != null && subtitle!.isNotEmpty)
                  Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Column(
                      children: [
                        Text(
                          subtitle!,
                          style: TextStyles.body4.bold.italic
                              .colour(UiConstants.primaryColor),
                        ),
                        const SizedBox(height: 2),
                      ],
                    ),
                  ])
              ],
            )),
            SizedBox(width: SizeConfig.padding12),
            Icon(
              trailingIcon ?? Icons.arrow_right_rounded,
              size: SizeConfig.padding20,
              color: UiConstants.primaryColor,
            )
          ],
        ),
      ),
    );
  }
}
