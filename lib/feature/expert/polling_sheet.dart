import 'package:felloapp/feature/expert/bloc/polling_bloc.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PollingSheet extends StatelessWidget {
  final String paymentID;
  const PollingSheet({
    required this.paymentID,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PollingBloc(
        locator(),
      )..add(StartPolling(paymentID)),
      child: const _BookingStatusSheet(),
    );
  }
}

class _BookingStatusSheet extends StatelessWidget {
  const _BookingStatusSheet();

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
                const CircularProgressIndicator(),
              ],
            ),
          CompletedPollingWithFailure() => Column(
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
                        'Booking Failed',
                        style: TextStyles.sourceSansSB.body1,
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: UiConstants.greyVarient,
                ),
              ],
            ),
          CompletedPollingWithSuccessOrPending() => Column(
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
                        'Call Confirmed',
                        style: TextStyles.sourceSansSB.body1,
                      ),
                    ],
                  ),
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
        };
      },
    );
  }
}
