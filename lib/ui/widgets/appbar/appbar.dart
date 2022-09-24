import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/ui/service_elements/user_service/profile_image.dart';
import 'package:felloapp/ui/widgets/appbar/faq_button_rounded.dart';
import 'package:felloapp/ui/widgets/coin_bar/coin_bar_view.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class FAppBar extends StatelessWidget with PreferredSizeWidget {
  final FaqsType type;
  final String title;
  final bool showCoinBar;
  final bool showAvatar;
  final bool showHelpButton;
  final Color backgroundColor;

  const FAppBar({
    Key key,
    this.type,
    this.title,
    this.showCoinBar = true,
    this.showAvatar = true,
    this.showHelpButton = true,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          showAvatar ? ProfileImageSE() : SizedBox(),
          Text(
            '${title ?? ''}',
            style: TextStyles.rajdhaniSB.title3,
          ),
        ],
      ),
      centerTitle: !showAvatar,
      elevation: 0,
      backgroundColor: backgroundColor ?? Colors.transparent,
      actions: [
        Row(
          children: [
            if (showCoinBar) FelloCoinBar(svgAsset: Assets.token),
            if (type != null) FaqButtonRounded(type: type),
            SizedBox(width: SizeConfig.padding20)
          ],
        )
      ],
    );
  }
}
