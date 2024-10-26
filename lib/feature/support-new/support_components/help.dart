import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class HelpWidget extends StatelessWidget {
  const HelpWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: SizeConfig.padding34),
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.padding14,
        horizontal: SizeConfig.padding18,
      ),
      decoration: BoxDecoration(
        color: UiConstants.greyVarient,
        borderRadius: BorderRadius.circular(SizeConfig.roundness12),
      ),
      child: Row(
        children: [
          // Left side text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Need help?',
                  style: TextStyles.sourceSans.body6
                      .colour(UiConstants.primaryColor),
                ),
                SizedBox(height: SizeConfig.padding4),
                Text(
                  'For more help contact us at: 1800-123-123455',
                  style: TextStyles.sourceSans.body2,
                ),
                SizedBox(height: SizeConfig.padding12),
                ElevatedButton(
                  onPressed: () {
                    Haptic.vibrate();
                    AppState.delegate!.appState.currentAction = PageAction(
                      state: PageState.addPage,
                      page: FreshDeskHelpPageConfig,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.only(
                      left: SizeConfig.padding12,
                      right: SizeConfig.padding12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(
                    'Call Us Now',
                    style: TextStyles.sourceSansSB.body4
                        .colour(UiConstants.textColor),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: SizeConfig.padding64,
            height: SizeConfig.padding64,
            child: const AppImage(
              Assets.help,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
