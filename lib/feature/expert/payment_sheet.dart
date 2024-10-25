import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/feature/expert/bloc/booking_bloc.dart';
import 'package:felloapp/feature/expert/polling_sheet.dart';
import 'package:felloapp/feature/sip/mandate_page/view/mandate_view.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentSheet extends StatelessWidget {
  final String advisorID;
  final num amount;
  final String fromTime;
  final num duration;
  const PaymentSheet({
    required this.advisorID,
    required this.amount,
    required this.fromTime,
    required this.duration,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaymentBloc(
        locator(),
        locator(),
        locator(),
      )..add(const LoadPSPApps()),
      child: _BookingMandatePage(
        advisorID: advisorID,
        amount: amount,
        fromTime: fromTime,
        duration: duration,
      ),
    );
  }
}

class _BookingMandatePage extends StatelessWidget {
  const _BookingMandatePage({
    required this.advisorID,
    required this.amount,
    required this.fromTime,
    required this.duration,
  });
  final String advisorID;
  final num amount;
  final String fromTime;
  final num duration;

  @override
  Widget build(BuildContext context) {
    return Column(
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
                'Select Payment Application',
                style: TextStyles.sourceSansSB.body1,
              ),
            ],
          ),
        ),
        const Divider(
          color: UiConstants.greyVarient,
        ),
        BlocConsumer<PaymentBloc, PaymentState>(
          listener: (context, state) {
            if (state is SubmittedPayment) {
              AppState.backButtonDispatcher!.didPopRoute();
              AppState.screenStack.add(ScreenItem.modalsheet);
              BaseUtil.openModalBottomSheet(
                isScrollControlled: true,
                enableDrag: true,
                isBarrierDismissible: false,
                content: PollingSheet(
                  paymentID: state.data.data.paymentId,
                ),
                backgroundColor: UiConstants.kBackgroundColor,
                hapticVibrate: true,
              );
            }
          },
          builder: (context, state) {
            return switch (state) {
              MandateInitialState() ||
              ListingPSPApps() =>
                const FullScreenLoader(),
              ListedPSPApps(:final pspApps) => Padding(
                  padding: EdgeInsets.all(SizeConfig.padding16),
                  child: SelectUPIApplicationSection(
                    showHeading: false,
                    upiApps: pspApps,
                    onSelectApplication: (meta) {
                      if (state case ListedPSPApps()) {
                        final event = SubmitPaymentRequest(
                          advisorId: advisorID,
                          amount: amount,
                          fromTime: fromTime,
                          duration: duration,
                          appuse: meta,
                          isFree: false,
                        );
                        context.read<PaymentBloc>().add(event);
                      }
                    },
                  ),
                ),
              SubmittingPayment() => const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [FullScreenLoader()],
                ),
              SubmittingPaymentFailed() => Container(),
              SubmittedPayment() => Container()
            };
          },
        ),
      ],
    );
  }
}
