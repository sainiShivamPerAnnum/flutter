import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/advisor/advisor_events.dart';
import 'package:felloapp/feature/advisor/advisor_components/schedule.dart';
import 'package:felloapp/feature/advisor/bloc/advisor_bloc.dart';
import 'package:felloapp/feature/live/widgets/upcoming_live_card.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Live extends StatelessWidget {
  const Live({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: SizeConfig.padding14),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.padding18,
            vertical: SizeConfig.padding12,
          ),
          decoration: BoxDecoration(
            color: UiConstants.greyVarient,
            borderRadius: BorderRadius.circular(SizeConfig.roundness8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SCHEDULE LIVE',
                    style: TextStyles.sourceSansSB.body6.colour(
                      UiConstants.kTabBorderColor,
                    ),
                  ),
                  SizedBox(height: SizeConfig.padding4),
                  Text(
                    'Plan your next live stream.',
                    style: TextStyles.sourceSansSB.body4,
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: navigateToCreateLive,
                style: ElevatedButton.styleFrom(
                  backgroundColor: UiConstants.kTextColor,
                  foregroundColor: UiConstants.kTextColor4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(SizeConfig.roundness8),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.padding8,
                    vertical: SizeConfig.padding4,
                  ),
                ),
                child: Text(
                  'Create New',
                  style: TextStyles.sourceSansSB.body4
                      .colour(UiConstants.kTextColor4),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: SizeConfig.padding24,
        ),
        const TitleSubtitleContainer(
          title: "Upcoming Live",
          zeroPadding: true,
        ),
        const LiveFello(),
      ],
    );
  }

  void navigateToCreateLive() {
    Haptic.vibrate();
    AppState.delegate!.appState.currentAction = PageAction(
      state: PageState.addWidget,
      page: ScheduleCallViewConfig,
      widget: const ScheduleCallWrapper(),
    );
  }
}

class LiveFello extends StatelessWidget {
  const LiveFello({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdvisorBloc, AdvisorState>(
      builder: (context, state) {
        if (state is AdvisorData) {
          final List<AdvisorEvents> data = state.advisorEvents;
          return Padding(
            padding: EdgeInsets.only(top: SizeConfig.padding20),
            child: SizedBox(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (int i = 0; i < data.length; i++)
                      Padding(
                        padding: EdgeInsets.only(right: SizeConfig.padding8)
                            .copyWith(bottom: 8),
                        child: SizedBox(
                          child: UpcomingLiveCardWidget(
                            id: data[i].id,
                            status: data[i].status,
                            title: data[i].topic ?? '',
                            subTitle: data[i].description ?? '',
                            author: 'Not coming from backend',
                            category: data[i].categories.isEmpty
                                ? ''
                                : data[i].categories[0],
                            bgImage: 'backend do',
                            liveCount: data[i].totalLiveCount,
                            duration: data[i].duration,
                            timeSlot: data[i].eventTimeSlot,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
