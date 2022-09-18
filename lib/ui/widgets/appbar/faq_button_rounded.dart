import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/help_and_support/faq/faq_page.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';

class FaqButtonRounded extends StatelessWidget {
  final FaqsType type;
  const FaqButtonRounded({Key key, @required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.black,
      radius: SizeConfig.avatarRadius,
      child: IconButton(
        icon: Icon(
          Icons.question_mark_rounded,
          color: Colors.white,
          size: SizeConfig.avatarRadius * 0.8,
        ),
        onPressed: () {
          Haptic.vibrate();
          AppState.delegate.appState.currentAction = PageAction(
            state: PageState.addWidget,
            page: FaqPageConfig,
            widget: FAQPage(
              type: type,
            ),
          );
        },
      ),
    );
  }
}
