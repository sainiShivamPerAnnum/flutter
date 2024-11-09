import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/advisor/advisor_events.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/feature/advisor/advisor_components/schedule.dart';
import 'package:felloapp/feature/advisor/bloc/advisor_bloc.dart';
import 'package:felloapp/feature/advisor/advisor_components/upcoming_live_card.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
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
        LiveFello(),
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
  LiveFello({Key? key}) : super(key: key);
  final String userName = (locator<UserService>().baseUser!.kycName != null &&
              locator<UserService>().baseUser!.kycName!.isNotEmpty
          ? locator<UserService>().baseUser!.kycName
          : locator<UserService>().baseUser!.name) ??
      "N/A";

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdvisorBloc, AdvisorState>(
      builder: (context, state) {
        if (state is AdvisorData) {
          final List<AdvisorEvents> data = state.advisorEvents;
          return Padding(
            padding: EdgeInsets.only(top: SizeConfig.padding20),
            child: data.isEmpty
                ? const Center(
                    child: Text(
                      "No live scheduled",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (int i = 0; i < data.length; i++)
                          Padding(
                            padding: EdgeInsets.only(right: SizeConfig.padding8)
                                .copyWith(bottom: 8),
                            child: UpcomingLiveCardWidget(
                              id: data[i].id,
                              status: data[i].status,
                              title: data[i].topic ?? '',
                              subTitle: data[i].description ?? '',
                              author: userName,
                              category: data[i].categories.isEmpty
                                  ? ''
                                  : data[i].categories[0],
                              bgImage: data[i].coverImage ?? '',
                              liveCount: data[i].totalLiveCount,
                              duration: data[i].duration,
                              timeSlot: data[i].eventTimeSlot,
                              broadcasterCode: data[i].broadcasterCode,
                            ),
                          ),
                      ],
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
