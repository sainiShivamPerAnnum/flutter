import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/support/faq/faq_page.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class FaqPill extends StatelessWidget {
  final FaqsType? type;
  final Function? addEvent;

  const FaqPill({Key? key, this.type, this.addEvent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Haptic.vibrate();
        if (type == null) {
          AppState.delegate!.appState.currentAction = PageAction(
            state: PageState.addPage,
            page: FreshDeskHelpPageConfig,
          );
        } else {
          AppState.delegate!.appState.currentAction = PageAction(
            state: PageState.addWidget,
            page: FaqPageConfig,
            widget: FAQPage(
              type: type ?? FaqsType.journey,
            ),
          );
        }
        if (addEvent != null) addEvent!();
      },
      icon: Container(
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          shape: BoxShape.circle,
        ),
        key: const ValueKey(Constants.HELP_FAB),
        child: Text(
          '?',
          style: TextStyles.rajdhaniSB.copyWith(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
