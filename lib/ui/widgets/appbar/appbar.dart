import 'package:felloapp/ui/service_elements/user_service/profile_image.dart';
import 'package:felloapp/ui/widgets/appbar/faq_button_rounded.dart';
import 'package:felloapp/ui/widgets/coin_bar/coin_bar_view.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FAppBar extends StatelessWidget with PreferredSizeWidget {
  final String category;
  final String title;
  final bool showCoinBar;
  final bool showAvatar;
  final bool showHelpButton;
  const FAppBar({
    Key key,
    this.category,
    this.title,
    this.showCoinBar = true,
    this.showAvatar = true,
    this.showHelpButton = true,
  }) : super(key: key);
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          showAvatar ? ProfileImageSE() : SizedBox(),
          Text(
            '${title ?? ''}',
            style: TextStyles.rajdhaniSB.title1,
          ),
        ],
      ),
      elevation: 0,
      backgroundColor: UiConstants.kSecondaryBackgroundColor,
      actions: [
        FelloCoinBar(svgAsset: Assets.aFelloToken),
        if (category != null) FaqButtonRounded(category: category),
        SizedBox(width: SizeConfig.padding20)
      ],
    );
  }
}
