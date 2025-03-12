import 'package:carousel_slider/carousel_slider.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/bookings/upcoming_booking.dart';
import 'package:felloapp/core/model/experts/experts_home.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/feature/expert/widgets/expert_card_v2.dart';
import 'package:felloapp/feature/expert/widgets/experts_card_shimmer_v2.dart';
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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tuple/tuple.dart';

class UpcomingBookingsComponent extends StatefulWidget {
  const UpcomingBookingsComponent({Key? key}) : super(key: key);

  @override
  UpcomingBookingsComponentState createState() =>
      UpcomingBookingsComponentState();
}

class UpcomingBookingsComponentState extends State<UpcomingBookingsComponent> {
  int _currentPage = 0;
  final CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    final analytics = locator<AnalyticsService>();
    return Padding(
      padding: EdgeInsets.only(top: 20.h, bottom: 24.h),
      child: Selector<SaveViewModel,
          Tuple3<List<Booking>, List<UserInterestedAdvisor>, bool>>(
        selector: (_, model) => Tuple3(
          model.upcomingBookings,
          model.userInterestedAdvisors,
          model.isTopAdvisorLoading,
        ),
        builder: (_, model, __) {
          return model.item1.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20.w),
                      child: Text(
                        "Your upcoming calls",
                        style: TextStyles.sourceSansSB.body2,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20.w, top: 24.h),
                      child: Container(
                        height: SizeConfig.padding275,
                        margin: EdgeInsets.only(
                          top: SizeConfig.padding10,
                        ),
                        child: ListView.builder(
                          itemCount: model.item1.length,
                          scrollDirection: Axis.horizontal,
                          physics: model.item1.length > 1
                              ? const AlwaysScrollableScrollPhysics()
                              : const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => Padding(
                            padding: EdgeInsets.only(
                              bottom: SizeConfig.padding16,
                              right: SizeConfig.padding18,
                            ),
                            child: ScheduleCard(
                              booking: model.item1[index],
                              width: model.item1.length > 1
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
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20.w),
                      child: Text(
                        "You might be interested in",
                        style: TextStyles.sourceSansSB.body2,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20.w, top: 24.h),
                      child: SizedBox(
                        height: 320.h,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: model.item3
                              ? const ExpertCardV2Shimmer()
                              : CarouselSlider.builder(
                                  itemCount: model.item2.length,
                                  itemBuilder: (context, index, realIndex) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        bottom: SizeConfig.padding16,
                                        right: SizeConfig.padding18,
                                      ),
                                      child: ExpertCardV2(
                                        isFree: false,
                                        expert: model.item2[index],
                                        onBookCall: () {
                                          BaseUtil.openBookAdvisorSheet(
                                            advisorId:
                                                model.item2[index].advisorId,
                                            advisorName:
                                                model.item2[index].name,
                                            isEdit: false,
                                          );
                                          analytics.track(
                                            eventName:
                                                AnalyticsEvents.bookACall,
                                            properties: {
                                              "Expert ID":
                                                  model.item2[index].advisorId,
                                              "Expert name":
                                                  model.item2[index].name,
                                            },
                                          );
                                        },
                                        onTap: () {
                                          AppState.delegate!.appState
                                              .currentAction = PageAction(
                                            page: ExpertDetailsPageConfig,
                                            state: PageState.addWidget,
                                            widget: ExpertsDetailsView(
                                              advisorID:
                                                  model.item2[index].advisorId,
                                            ),
                                          );
                                          analytics.track(
                                            eventName: "Suggested - Experts",
                                            properties: {
                                              "Expert sequence":
                                                  model.item2[index].advisorId,
                                              "Expert name":
                                                  model.item2[index].name,
                                            },
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  options: CarouselOptions(
                                    height: double.infinity,
                                    enlargeCenterPage: false,
                                    enableInfiniteScroll: false,
                                    viewportFraction: 1,
                                    initialPage: 0,
                                    onPageChanged: (index, reason) {
                                      setState(() {
                                        _currentPage = index;
                                      });
                                    },
                                  ),
                                ),
                        ),
                      ),
                    ),
                    if (model.item2.length > 1)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: SizeConfig.padding14),
                          child: SmoothPageIndicator(
                            controller:
                                PageController(initialPage: _currentPage),
                            count: model.item2.length,
                            effect: ExpandingDotsEffect(
                              activeDotColor: Colors.white,
                              dotColor: Colors.grey,
                              dotHeight: 6.h,
                              dotWidth: 6.w,
                            ),
                            onDotClicked: _carouselController.animateToPage,
                          ),
                        ),
                      ),
                  ],
                );
        },
      ),
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
                topLeft: Radius.circular(8.r),
                topRight: Radius.circular(8.r),
              ),
            ),
            padding: EdgeInsets.only(
              left: 16.r,
              top: 16.r,
              right: 16.r,
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
                SizedBox(height: 16.h),
                const Divider(
                  color: UiConstants.grey6,
                ),
                SizedBox(height: 16.h),
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
                SizedBox(height: 16.h),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 12.h,
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
