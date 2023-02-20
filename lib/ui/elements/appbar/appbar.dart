import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/ui/elements/coin_bar/coin_bar_view.dart';
import 'package:felloapp/ui/pages/login/login_components/login_support.dart';
import 'package:felloapp/ui/service_elements/user_service/profile_image.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';

class FAppBar extends StatelessWidget with PreferredSizeWidget {
  final FaqsType? type;
  final String? title;
  final bool showCoinBar;
  final bool showAvatar;
  final bool showHelpButton;
  final Color? backgroundColor;
  final Widget? action;
  final double? leftPad;
  // final bool hasBackButton;
  final TextStyle? style;
  const FAppBar({
    Key? key,
    this.type,
    this.title,
    this.showCoinBar = true,
    this.showAvatar = true,
    this.showHelpButton = true,
    this.backgroundColor,
    this.style,
    this.action,
    this.leftPad,
    // this.hasBackButton = true
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      // leading: hasBackButton
      //     ? IconButton(
      //         icon: Icon(Icons.adaptive.arrow_back_rounded),
      //         onPressed: () => AppState.backButtonDispatcher!.didPopRoute())
      //     : SizedBox(),

      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: SizeConfig.padding8),
          showAvatar ? ProfileImageSE() : SizedBox(),
          Text(
            '${title ?? ''}',
            style: TextStyles.rajdhaniSB.title5.merge(style),
          ),
        ],
      ),
      centerTitle: false,
      elevation: 0,
      backgroundColor: backgroundColor ?? Colors.transparent,
      actions: [
        Row(
          children: [
            if (showCoinBar)
              FelloCoinBar(
                  svgAsset: Assets.token,
                  key: ValueKey(Constants.FELLO_COIN_BAR)),
            if (type != null) FaqPill(type: type),
            if (action != null) action!,
            SizedBox(width: SizeConfig.padding14)
          ],
        )
      ],
    );
  }
}
