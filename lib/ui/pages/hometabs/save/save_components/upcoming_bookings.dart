import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/bookings/upcoming_booking.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/feature/expertDetails/expert_profile.dart';
import 'package:felloapp/feature/hms_room_kit/lib/hms_room_kit.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpcomingBookingsComponent extends StatelessWidget {
  const UpcomingBookingsComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<SaveViewModel, List<Booking>>(
      selector: (_, model) => model.upcomingBookings,
      builder: (_, upcomingBookings, __) {
        return upcomingBookings.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TitleSubtitleContainer(
                    title: "Your upcoming calls",
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: SizeConfig.padding20),
                    child: Container(
                      height: SizeConfig.padding275,
                      margin: EdgeInsets.only(
                        top: SizeConfig.padding10,
                      ),
                      child: ListView.builder(
                        itemCount: upcomingBookings.length,
                        scrollDirection: Axis.horizontal,
                        physics: upcomingBookings.length > 1
                            ? const AlwaysScrollableScrollPhysics()
                            : const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => Padding(
                          padding: EdgeInsets.only(
                            bottom: SizeConfig.padding16,
                            right: SizeConfig.padding18,
                          ),
                          child: ScheduleCard(
                            booking: upcomingBookings[index],
                            width: upcomingBookings.length > 1
                                ? SizeConfig.padding325
                                : SizeConfig.padding350,
                            fromHome: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : const SizedBox.shrink();
      },
    );
  }
}

class ScheduleCard extends StatelessWidget {
  final Booking booking;
  final double width;
  final bool fromHome;

  const ScheduleCard({
    required this.booking,
    required this.width,
    required this.fromHome,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: UiConstants.greyVarient,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(SizeConfig.roundness8),
                topRight: Radius.circular(SizeConfig.roundness8),
              ),
            ),
            padding: EdgeInsets.only(
              left: SizeConfig.padding16,
              top: SizeConfig.padding16,
              right: SizeConfig.padding16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    AppState.delegate!.appState.currentAction = PageAction(
                      page: ExpertDetailsPageConfig,
                      state: PageState.addWidget,
                      widget: ExpertsDetailsView(advisorID: booking.advisorId),
                    );
                  },
                  child: Row(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: SizeConfig.padding16,
                            backgroundImage: NetworkImage(
                              booking.image,
                            ),
                          ),
                          SizedBox(width: SizeConfig.padding10),
                          Text(
                            booking.advisorName,
                            style: TextStyles.sourceSansSB.body1,
                          ),
                        ],
                      ),
                      SizedBox(width: SizeConfig.padding10),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: UiConstants.kTextColor,
                        size: SizeConfig.body4,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: SizeConfig.padding16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Scheduled on',
                          style: TextStyles.sourceSans.body4.colour(
                            UiConstants.kTextColor5,
                          ),
                        ),
                        SizedBox(height: SizeConfig.padding4),
                        Text(
                          _formatDate(booking.scheduledOn),
                          style: TextStyles.sourceSansSB.body2.colour(
                            UiConstants.kTextColor,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Duration',
                          style: TextStyles.sourceSans.body4.colour(
                            UiConstants.kTextColor5,
                          ),
                        ),
                        SizedBox(height: SizeConfig.padding4),
                        Text(
                          booking.duration, // Display the duration
                          style: TextStyles.sourceSansSB.body2.colour(
                            UiConstants.kTextColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.padding16),
                const Divider(
                  color: UiConstants.grey6,
                ),
                SizedBox(height: SizeConfig.padding16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        locator<AnalyticsService>().track(
                          eventName: fromHome
                              ? AnalyticsEvents.homeEditCall
                              : AnalyticsEvents.expertsEditCall,
                          properties: {
                            "call ID": booking.bookingId,
                          },
                        );
                        if (_isEditButtonClickable()) {
                          BaseUtil.openBookAdvisorSheet(
                            advisorId: booking.advisorId,
                            isEdit: true,
                            bookingId: booking.bookingId,
                            advisorName: booking.advisorName,
                            scheduledOn: booking.scheduledOn,
                            duration: booking.duration.trim().split(' ').first,
                          );
                        } else {
                          BaseUtil.showNegativeAlert(
                            'Editing Closed',
                            'Editing the schedule is only possible up to 24 hours before the scheduled time.',
                          );
                        }
                      },
                      child: Text(
                        'Edit',
                        style: _isEditButtonClickable()
                            ? TextStyles.sourceSansSB.body3
                            : TextStyles.sourceSansSB.body3.colour(
                                UiConstants.kTextColor.withOpacity(0.5),
                              ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        locator<AnalyticsService>().track(
                          eventName: fromHome
                              ? AnalyticsEvents.homeJoinCall
                              : AnalyticsEvents.expertsJoinCall,
                          properties: {
                            "call ID": booking.bookingId,
                          },
                        );
                        if (_isButtonClickable()) {
                          final String? name = locator<UserService>()
                                  .baseUser!
                                  .kycName!
                                  .isNotEmpty
                              ? locator<UserService>().baseUser!.kycName!
                              : locator<UserService>()
                                      .baseUser!
                                      .name!
                                      .isNotEmpty
                                  ? locator<UserService>().baseUser!.name
                                  : locator<UserService>().baseUser!.username;
                          final userId = locator<UserService>().baseUser!.uid;
                          AppState.delegate!.appState.currentAction =
                              PageAction(
                            page: LivePreviewPageConfig,
                            state: PageState.addWidget,
                            widget: HMSPrebuilt(
                              isLiked: false,
                              eventId: '',
                              title: '',
                              description: '',
                              advisorId: booking.advisorId,
                              advisorName: booking.advisorName,
                              roomCode: booking.guestCode,
                              options: HMSPrebuiltOptions(
                                userName: name,
                                userId: userId,
                              ),
                              onLeave: () async {
                                await AppState.backButtonDispatcher!
                                    .didPopRoute();
                              },
                            ),
                          );
                        } else {
                          BaseUtil.showNegativeAlert(
                            'Unable to Join Meeting',
                            'You can join the meeting 15 minutes prior to your scheduled time!',
                          );
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.padding8,
                          vertical: SizeConfig.padding6,
                        ),
                        decoration: BoxDecoration(
                          color: _isButtonClickable()
                              ? UiConstants.kTextColor
                              : UiConstants.kTextColor.withOpacity(.5),
                          borderRadius: BorderRadius.circular(
                            SizeConfig.roundness5,
                          ),
                        ),
                        child: Text(
                          'Join Call',
                          style: TextStyles.sourceSansSB.body4
                              .colour(UiConstants.kTextColor4),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.padding16),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.padding14,
              vertical: SizeConfig.padding12,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(SizeConfig.roundness8),
                bottomRight: Radius.circular(SizeConfig.roundness8),
              ),
              color: UiConstants.greyVarient.withOpacity(.6),
            ),
            child: Row(
              children: [
                Transform.translate(
                  offset: Offset(0, -SizeConfig.padding6),
                  child: Icon(
                    Icons.info,
                    size: SizeConfig.body4,
                    color: UiConstants.kTextColor,
                  ),
                ),
                SizedBox(width: SizeConfig.padding8),
                Expanded(
                  child: Text(
                    'You can edit your schedule up to 24 hours before your scheduled time.',
                    maxLines: 2,
                    style: TextStyles.sourceSans.body4
                        .colour(UiConstants.kTextColor.withOpacity(.75)),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _isButtonClickable() {
    final DateTime now = getAdjustedUtcTime();
    final DateTime scheduledOn = booking.scheduledOn;
    final DateTime startWindow =
        scheduledOn.subtract(const Duration(minutes: 15));

    // Parse duration minutes from string
    final int durationMinutes =
        int.tryParse(booking.duration.split(' ').first) ?? 0;
    final DateTime endWindow =
        scheduledOn.add(Duration(minutes: durationMinutes.toInt()));
    final clickable = now.isAfter(startWindow) && now.isBefore(endWindow);
    return clickable;
  }

  DateTime getAdjustedUtcTime() {
    // Get the current UTC time
    final DateTime nowUtc = DateTime.now().toUtc();

    // Get the current local time
    final DateTime nowLocal = DateTime.now();

    // Calculate the difference between local and UTC
    final Duration offset = nowLocal.timeZoneOffset;

    // Adjust the UTC time by adding or subtracting the offset
    final DateTime adjustedUtcTime = nowUtc.add(offset);

    return adjustedUtcTime;
  }

  bool _isEditButtonClickable() {
    final DateTime now = getAdjustedUtcTime();
    final DateTime scheduledOn = booking.scheduledOn;
    final DateTime endWindow = scheduledOn.subtract(const Duration(hours: 24));
    return now.isBefore(endWindow);
  }

  // Helper function to format the scheduledOn DateTime
  String _formatDate(DateTime dateTime) {
    return "${dateTime.day} ${_getMonthName(dateTime.month)} ${dateTime.year}, ${_formatTime(dateTime)}";
  }

  // Helper function to format time in the desired format
  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  // Helper function to get the month name
  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}
