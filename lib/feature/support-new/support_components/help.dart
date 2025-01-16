import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/feature/support-new/bloc/support_bloc.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HelpWidget extends StatelessWidget {
  const HelpWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: SizeConfig.padding16),
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.padding14,
        horizontal: SizeConfig.padding18,
      ),
      decoration: BoxDecoration(
        color: UiConstants.greyVarient,
        borderRadius: BorderRadius.circular(SizeConfig.roundness12),
      ),
      child: BlocBuilder<SupportBloc, SupportState>(
        builder: (context, state) {
          if (state is SupportData) {
            return Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'NEED HELP?',
                        style: TextStyles.sourceSans.body6
                            .colour(UiConstants.primaryColor),
                      ),
                      SizedBox(height: SizeConfig.padding6),
                      Text(
                        'For more help contact us at: ${state.contactDetails}',
                        style: TextStyles.sourceSans.body2,
                      ),
                      SizedBox(height: SizeConfig.padding12),
                      ElevatedButton(
                        onPressed: () {
                          Haptic.vibrate();
                          AppState.delegate!.appState.currentAction =
                              PageAction(
                            state: PageState.addPage,
                            page: FreshDeskHelpPageConfig,
                          );
                          locator<AnalyticsService>().track(
                            eventName: AnalyticsEvents.callUsNow,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(0, 0),
                          padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.padding6,
                            horizontal: SizeConfig.padding12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              SizeConfig.roundness5,
                            ),
                          ),
                        ),
                        child: Text(
                          state.btnTxt,
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
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
