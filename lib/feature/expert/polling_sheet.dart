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
                    vertical: SizeConfig.padding14,
                    horizontal: SizeConfig.padding20,
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
                    horizontal: SizeConfig.padding20,
                  ).copyWith(
                    top: SizeConfig.padding14,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Booking Failed',
                        style: TextStyles.sourceSansSB.body1,
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: UiConstants.greyVarient,
                ),
                AppImage(Assets.failed_payment, height: SizeConfig.padding112),
                Text(
                  'Something went wrong',
                  style: TextStyles.sourceSansSB.title4,
                ),
                SizedBox(
                  height: SizeConfig.padding12,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: SizeConfig.padding18),
                  child: Text(
                    'Please try again or choose a different time slot. If your money was deducted, contact support.',
                    style: TextStyles.sourceSans.body3
                        .colour(UiConstants.kTextColor5),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: SizeConfig.padding18,
                ),
                const Divider(
                  color: UiConstants.greyVarient,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: SizeConfig.padding18)
                          .copyWith(top: SizeConfig.padding18),
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
                              vertical: SizeConfig.padding16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(SizeConfig.roundness8),
                            ),
                          ),
                          child: Text(
                            'Contact Support',
                            style: TextStyles.sourceSans.body3,
                          ),
                        ),
                      ),
                      SizedBox(width: SizeConfig.padding12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            AppState.backButtonDispatcher!.didPopRoute();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: UiConstants.kTextColor,
                            padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.padding16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(SizeConfig.roundness8),
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
                SizedBox(height: SizeConfig.padding40),
              ],
            ),
          CompletedPollingWithSuccess() => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.padding20,
                  ).copyWith(
                    top: SizeConfig.padding14,
                  ),
                  child: Text(
                    'Call Confirmed',
                    style: TextStyles.sourceSansSB.body1,
                  ),
                ),
                const Divider(
                  color: UiConstants.greyVarient,
                ),
                AppImage(Assets.confirm_payment, height: SizeConfig.padding112),
                Text(
                  BaseUtil.formatDateTime(DateTime.parse(fromTime)),
                  style: TextStyles.sourceSansSB.title4,
                ),
                SizedBox(
                  height: SizeConfig.padding12,
                ),
                Text(
                  'Your slot has been booked with $advisorName',
                  style: TextStyles.sourceSans.body3
                      .colour(UiConstants.kTextColor5),
                ),
                SizedBox(
                  height: SizeConfig.padding18,
                ),
                const Divider(
                  color: UiConstants.greyVarient,
                ),
                Padding(
                  padding: EdgeInsets.all(SizeConfig.padding18),
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
                          vertical: SizeConfig.padding16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(SizeConfig.roundness8),
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
                    horizontal: SizeConfig.padding20,
                  ).copyWith(
                    top: SizeConfig.padding14,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Booking Pending',
                        style: TextStyles.sourceSansSB.body1,
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: UiConstants.greyVarient,
                ),
                AppImage(Assets.pending_payment, height: SizeConfig.padding112),
                Text(
                  'Processing Your Booking',
                  style: TextStyles.sourceSansSB.title4,
                ),
                SizedBox(
                  height: SizeConfig.padding12,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: SizeConfig.padding18),
                  child: Text(
                    'Processing your booking. This may take some time. If this takes longer, please contact support.',
                    style: TextStyles.sourceSans.body3
                        .colour(UiConstants.kTextColor5),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: SizeConfig.padding18,
                ),
                const Divider(
                  color: UiConstants.greyVarient,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: SizeConfig.padding18)
                          .copyWith(top: SizeConfig.padding18),
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
                              vertical: SizeConfig.padding16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(SizeConfig.roundness8),
                            ),
                          ),
                          child: Text(
                            'Contact Support',
                            style: TextStyles.sourceSans.body3,
                          ),
                        ),
                      ),
                      SizedBox(width: SizeConfig.padding12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            AppState.backButtonDispatcher!.didPopRoute();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: UiConstants.kTextColor,
                            padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.padding16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(SizeConfig.roundness8),
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
                SizedBox(height: SizeConfig.padding40),
              ],
            ),
        };
      },
    );
  }
}
