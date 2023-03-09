import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/support/faq/faq_page.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class FaqPill extends StatelessWidget {
  final FaqsType? type;
  const FaqPill({Key? key, this.type}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return SafeArea(
      child: InkWell(
        onTap: () {
          Haptic.vibrate();
          AppState.delegate!.appState.currentAction = PageAction(
            state: PageState.addWidget,
            page: FaqPageConfig,
            widget: FAQPage(
              type: type ?? FaqsType.journey,
            ),
          );
        },
        child: Container(
            key: ValueKey(Constants.HELP_FAB),
            // height: SizeConfig.navBarHeight * 0.5,
            margin: EdgeInsets.symmetric(
              horizontal: SizeConfig.padding8,
            ),
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.padding12,
                vertical: SizeConfig.padding6),
            height: SizeConfig.avatarRadius * 2,
            decoration: BoxDecoration(
              color: UiConstants.kTextFieldColor.withOpacity(0.4),
              border: Border.all(color: Colors.white10),
              borderRadius: BorderRadius.circular(SizeConfig.roundness12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  locale.obHelp,
                  style: TextStyles.body4.colour(UiConstants.kTextColor),
                ),
                Padding(
                  padding: EdgeInsets.only(left: SizeConfig.padding8),
                  child: Image.asset(
                    Assets.support,
                    color: UiConstants.kTextColor,
                    height: SizeConfig.iconSize2,
                    width: SizeConfig.iconSize2,
                  ),
                )
              ],
            )),
      ),
    );
  }
}
