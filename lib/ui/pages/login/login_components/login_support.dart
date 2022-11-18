import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/help_and_support/faq/faq_page.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class FaqPill extends StatelessWidget {
  final FaqsType? type;
  const FaqPill({Key? key, this.type}) : super(key: key);
  @override
  Widget build(BuildContext context) {
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
            // height: SizeConfig.navBarHeight * 0.5,
            padding: EdgeInsets.symmetric(
                vertical: SizeConfig.padding12,
                horizontal: SizeConfig.padding16),
            decoration: BoxDecoration(
              color: UiConstants.kDarkBackgroundColor,
              borderRadius:
                  BorderRadius.all(Radius.circular(SizeConfig.roundness112)),
            ),
            child: Wrap(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Help",
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
