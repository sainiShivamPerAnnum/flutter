import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/feature/expert/bloc/polling_bloc.dart';
import 'package:felloapp/feature/expert/tell_us_about_yourself.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PollingSheet extends StatelessWidget {
  final String paymentID;
  final String fromTime;
  final String advisorName;
  const PollingSheet({
    required this.paymentID,
    required this.fromTime,
    required this.advisorName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PollingBloc(
        locator(),
        locator(),
        locator(),
        locator(),
      )..add(StartPolling(paymentID, fromTime, advisorName)),
      child: _BookingStatusSheet(
        paymentID: paymentID,
        fromTime: fromTime,
        advisorName: advisorName,
      ),
    );
  }
}

class _BookingStatusSheet extends StatelessWidget {
  final String paymentID;
  final String fromTime;
  final String advisorName;
  const _BookingStatusSheet({
    required this.paymentID,
    required this.fromTime,
    required this.advisorName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PollingBloc, PollingState>(
      builder: (context, state) {
        return switch (state) {
          InitialPollingState() || Polling() => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 14.h,
                    horizontal: 20.w,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Confirming Payment',
                        style: TextStyles.sourceSansSB.body1,
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: UiConstants.greyVarient,
                ),
                const FullScreenLoader(),
              ],
            ),
          CompletedPollingWithFailure() => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                  ).copyWith(
                    top: 6.h,
                  ),
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Booking Failed',
                            style: TextStyles.sourceSansSB.body1,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            iconSize: 18.r,
                            splashRadius: 18.r,
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              AppState.backButtonDispatcher!.didPopRoute();
                            },
                            icon: Icon(
                              Icons.close,
                              size: 18.r,
                              color: UiConstants.kTextColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.zero,
                  child: const Divider(
                    color: UiConstants.greyVarient,
                    thickness: 1,
                    height: 1,
                  ),
                ),
                AppImage(Assets.failed_payment, height: 112.h),
                Text(
                  'Something went wrong',
                  style: TextStyles.sourceSansSB.title4,
                ),
                SizedBox(
                  height: 12.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: Text(
                    'Please try again or choose a different time slot. If your money was deducted, contact support.',
                    style: TextStyles.sourceSans.body3
                        .colour(UiConstants.kTextColor5),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 18.h,
                ),
                const Divider(
                  color: UiConstants.greyVarient,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w)
                      .copyWith(top: 18.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            AppState.delegate!.appState.currentAction =
                                PageAction(
                              state: PageState.addPage,
                              page: FreshDeskHelpPageConfig,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: UiConstants.greyVarient,
                            padding: EdgeInsets.symmetric(
                              vertical: 16.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Text(
                            'Contact Support',
                            style: TextStyles.sourceSans.body3,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            AppState.backButtonDispatcher!.didPopRoute();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: UiConstants.kTextColor,
                            padding: EdgeInsets.symmetric(
                              vertical: 16.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Text(
                            'Try Again',
                            style: TextStyles.sourceSans.body3
                                .colour(UiConstants.kTextColor4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40.h),
              ],
            ),
          CompletedPollingWithSuccess() => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                  ).copyWith(
                    top: 14.h,
                  ),
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Call Confirmed',
                            style: TextStyles.sourceSansSB.body1,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            iconSize: 18.r,
                            splashRadius: 18.r,
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              AppState.backButtonDispatcher!.didPopRoute();
                              AppState.delegate!.appState.currentAction =
                                  PageAction(
                                page: TellUsAboutYourselfPageConfig,
                                state: PageState.addWidget,
                                widget: TellUsAboutYourselfView(
                                  bookingId:
                                      state.response.data.bookingId ?? '',
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.close,
                              size: 18.r,
                              color: UiConstants.kTextColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.zero,
                  child: const Divider(
                    color: UiConstants.greyVarient,
                    thickness: 1,
                    height: 1,
                  ),
                ),
                AppImage(Assets.confirm_payment, height: 112.h),
                Text(
                  BaseUtil.formatDateTime(DateTime.parse(fromTime)),
                  style: TextStyles.sourceSansSB.title4,
                ),
                SizedBox(
                  height: 12.h,
                ),
                Text(
                  'Your slot has been booked with $advisorName',
                  style: TextStyles.sourceSans.body3
                      .colour(UiConstants.kTextColor5),
                ),
                SizedBox(
                  height: 18.h,
                ),
                const Divider(
                  color: UiConstants.greyVarient,
                ),
                Padding(
                  padding: EdgeInsets.all(18.w),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        AppState.backButtonDispatcher!.didPopRoute();
                        AppState.delegate!.appState.currentAction = PageAction(
                          page: TellUsAboutYourselfPageConfig,
                          state: PageState.addWidget,
                          widget: TellUsAboutYourselfView(
                            bookingId: state.response.data.bookingId ?? '',
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: UiConstants.kTextColor,
                        padding: EdgeInsets.symmetric(
                          vertical: 16.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        'Done',
                        style: TextStyles.sourceSans.body3
                            .colour(UiConstants.kTextColor4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          CompletedPollingWithPending() => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                  ).copyWith(
                    top: 6.h,
                  ),
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Booking Pending',
                            style: TextStyles.sourceSansSB.body1,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            iconSize: 18.r,
                            splashRadius: 18.r,
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              AppState.backButtonDispatcher!.didPopRoute();
                            },
                            icon: Icon(
                              Icons.close,
                              size: 18.r,
                              color: UiConstants.kTextColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.zero,
                  child: const Divider(
                    color: UiConstants.greyVarient,
                    thickness: 1,
                    height: 1,
                  ),
                ),
                AppImage(Assets.pending_payment, height: 112.h),
                Text(
                  'Processing Your Booking',
                  style: TextStyles.sourceSansSB.title4,
                ),
                SizedBox(
                  height: 12.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: Text(
                    'Processing your booking. This may take some time. If this takes longer, please contact support.',
                    style: TextStyles.sourceSans.body3
                        .colour(UiConstants.kTextColor5),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 18.h,
                ),
                const Divider(
                  color: UiConstants.greyVarient,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w)
                      .copyWith(top: 18.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            AppState.delegate!.appState.currentAction =
                                PageAction(
                              state: PageState.addPage,
                              page: FreshDeskHelpPageConfig,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: UiConstants.greyVarient,
                            padding: EdgeInsets.symmetric(
                              vertical: 16.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Text(
                            'Contact Support',
                            style: TextStyles.sourceSans.body3,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            AppState.backButtonDispatcher!.didPopRoute();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: UiConstants.kTextColor,
                            padding: EdgeInsets.symmetric(
                              vertical: 16.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Text(
                            'Got it',
                            style: TextStyles.sourceSans.body3
                                .colour(UiConstants.kTextColor4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40.h),
              ],
            ),
        };
      },
    );
  }
}
