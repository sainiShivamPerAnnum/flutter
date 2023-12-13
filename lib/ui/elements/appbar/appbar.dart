import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/ui/elements/coin_bar/coin_bar_view.dart';
import 'package:felloapp/ui/keys/keys.dart';
import 'package:felloapp/ui/pages/login/login_components/login_support.dart';
import 'package:felloapp/ui/service_elements/user_service/profile_image.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';

class FAppBar extends StatelessWidget implements PreferredSizeWidget {
  final FaqsType? type;
  final String? title;
  final bool showCoinBar;
  final bool showAvatar;
  final bool showHelpButton;
  final Color? backgroundColor;
  final Widget? action;
  final double? leftPad;
  final bool showLeading;
  final Widget? leading;
  final Widget? subtitle;
  final Widget? titleWidget;
  final bool? centerTitle;
  final bool leadingPadding;

  // final bool hasBackButton;
  final TextStyle? style;

  const FAppBar(
      {Key? key,
      this.type,
      this.title,
      this.showCoinBar = true,
      this.leading,
      this.showLeading = true,
      this.showAvatar = true,
      this.showHelpButton = true,
      this.backgroundColor,
      this.style,
      this.action,
      this.leftPad,
      this.subtitle,
      this.centerTitle,
      this.titleWidget,
      this.leadingPadding = true
      // this.hasBackButton = true
      })
      : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leadingPadding) SizedBox(width: SizeConfig.padding8),
          if (showAvatar)
            Transform.translate(
              offset: Offset(0, SizeConfig.padding2),
              child: ProfileImageSE(
                key: K.userAvatarKey,
                radius: SizeConfig.avatarRadius * 0.9,
                showBadge: true,
              ),
            ),
          titleWidget ??
              Text(
                title ?? '',
                style: TextStyles.rajdhaniSB.title5.merge(style),
              ),
        ],
      ),
      centerTitle: centerTitle ?? false,
      elevation: 0,
      backgroundColor: backgroundColor ?? Colors.transparent,
      actions: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (showCoinBar)
              FelloCoinBar(
                svgAsset: Assets.token,
                key: const ValueKey(Constants.FELLO_COIN_BAR),
              ),
            if (action != null) action!,
            if (type != null) FaqPill(type: type),
            SizedBox(width: SizeConfig.padding14)
          ],
        )
      ],
    );
  }
}
