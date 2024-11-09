import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/model/advisor/advisor_upcoming_call.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/feature/advisor/advisor_components/call_details_sheet.dart';
import 'package:felloapp/feature/advisor/bloc/advisor_bloc.dart';
import 'package:felloapp/feature/hms_room_kit/lib/hms_room_kit.dart';
import 'package:felloapp/feature/live/view_all_live.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../navigator/app_state.dart';

class Call extends StatefulWidget {
  final String callType;
  const Call({required this.callType, Key? key}) : super(key: key);

  @override
  State<Call> createState() => _CallState();
}

class _CallState extends State<Call> {
  bool showAll = false;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdvisorBloc, AdvisorState>(
      builder: (context, state) {
        if (state is AdvisorData) {
          final List<AdvisorCall> data = widget.callType == 'upcoming'
              ? state.advisorUpcomingCalls
              : state.advisorPastCalls;
          final displayedData = showAll ? data : data.take(3).toList();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: SizeConfig.padding24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TitleSubtitleContainer(
                    title: widget.callType == 'upcoming'
                        ? 'Upcoming Calls'
                        : 'Past Scheduled Calls',
                    zeroPadding: true,
                  ),
                  if (data.length > 3)
                    TextButton(
                      onPressed: () {
                        AppState.delegate!.appState.currentAction = PageAction(
                          page: AllEventsPageConfig,
                          state: PageState.addWidget,
                          widget: ViewAllLive(
                            type: 'upcoming-advisor',
                            appBarTitle: widget.callType == 'upcoming'
                                ? 'Upcoming Calls'
                                : 'Past Scheduled Calls',
                            advisorUpcoming:
                                widget.callType == 'upcoming' ? data : [],
                            advisorPast: widget.callType == 'past' ? data : [],
                            liveList: null,
                            upcomingList: null,
                            recentList: null,
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Text(
                            'VIEW ALL',
                            style: TextStyles.sourceSansSB.body3,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: SizeConfig.body3,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              SizedBox(
                height: SizeConfig.padding14,
              ),
              data.isEmpty
                  ? const Center(
                      child: Text(
                        "No calls available",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    )
                  : Column(
                      children: displayedData
                          .map(
                            (call) => callContainer(
                              call.userName ?? 'Unknown Title',
                              call.userName ?? 'Unknown Description',
                              call.scheduledOn.toString(),
                              call.duration,
                              widget.callType,
                              call.hostCode,
                              call.detailsQA,
                            ),
                          )
                          .toList(),
                    ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

Widget callContainer(
  String title,
  String description,
  String scheduledOn,
  String duration,
  String callType,
  String? hostCode,
  List<Map<String, String>> details,
) {
  return Container(
    margin: EdgeInsets.only(bottom: SizeConfig.padding24),
    padding: EdgeInsets.symmetric(
      vertical: SizeConfig.padding14,
      horizontal: SizeConfig.padding18,
    ),
    decoration: BoxDecoration(
      color: UiConstants.greyVarient,
      borderRadius: BorderRadius.circular(
        SizeConfig.roundness12,
      ),
    ),
    child: Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: SizeConfig.padding28,
              height: SizeConfig.padding28,
              child: Image.asset(
                Assets.user,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              width: SizeConfig.padding10,
            ),
            Text(
              title,
              style: TextStyles.sourceSansSB.body1,
            ),
          ],
        ),
        SizedBox(
          height: SizeConfig.padding16,
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Call Time',
                    style: TextStyles.sourceSans.body4
                        .colour(UiConstants.kTextColor5),
                  ),
                  Text(
                    BaseUtil.formatDateTime(DateTime.parse(scheduledOn)),
                    style: TextStyles.sourceSansSB.body3,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Duration',
                  style: TextStyles.sourceSans.body4
                      .colour(UiConstants.kTextColor5),
                ),
                Text(
                  duration,
                  style: TextStyles.sourceSansSB.body3,
                ),
              ],
            ),
          ],
        ),
        if (callType == 'upcoming')
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: SizeConfig.padding16,
            ),
            child: const Divider(
              color: UiConstants.grey6,
              height: 0,
              thickness: 1,
            ),
          ),
        if (callType == 'upcoming')
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (details.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    AppState.screenStack.add(ScreenItem.modalsheet);
                    BaseUtil.openModalBottomSheet(
                      isBarrierDismissible: true,
                      content: CallDetailsSheet(
                        details: details,
                      ),
                    );
                  },
                  child: Text(
                    'View Details',
                    style: TextStyles.sourceSansSB.body3,
                  ),
                ),
              SizedBox(
                width: SizeConfig.padding28,
              ),
              if (hostCode != null)
                ElevatedButton(
                  onPressed: () {
                    final userService = locator<UserService>();
                    final userId = userService.baseUser!.uid;
                    final String userName =
                        (userService.baseUser!.kycName != null &&
                                    userService.baseUser!.kycName!.isNotEmpty
                                ? userService.baseUser!.kycName
                                : userService.baseUser!.name) ??
                            "N/A";
                    AppState.delegate!.appState.currentAction = PageAction(
                      page: LivePreviewPageConfig,
                      state: PageState.addWidget,
                      widget: HMSPrebuilt(
                        advisorId: userId!,
                        title: title,
                        description: description,
                        roomCode: hostCode,
                        options: HMSPrebuiltOptions(
                          userName: userName,
                          userId: userId,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.padding6,
                      horizontal: SizeConfig.padding8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness5),
                    ),
                  ),
                  child: Text(
                    'Join Call',
                    style: TextStyles.sourceSansSB.body3.colour(
                      UiConstants.kTextColor4,
                    ),
                  ),
                ),
            ],
          ),
      ],
    ),
  );
}
