import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/feature/expert/bloc/booking_bloc.dart';
import 'package:felloapp/feature/expert/polling_sheet.dart';
import 'package:felloapp/feature/sip/mandate_page/view/mandate_view.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/error_page.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentSheet extends StatelessWidget {
  final String advisorID;
  final String advisorName;
  final num amount;
  final String fromTime;
  final num duration;
  final bool isCoinBalance;
  final bool isFree;
  const PaymentSheet({
    required this.advisorID,
    required this.advisorName,
    required this.amount,
    required this.fromTime,
    required this.duration,
    required this.isCoinBalance,
    required this.isFree,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaymentBloc(
        locator(),
        locator(),
        locator(),
      )..add(
          amount == 0
              ? SubmitPaymentRequest(
                  reddem: isCoinBalance,
                  advisorId: advisorID,
                  amount: amount,
                  fromTime: fromTime,
                  duration: duration,
                  appuse: null,
                  isFree: isFree,
                )
              : const LoadPSPApps(),
        ),
      child: _BookingMandatePage(
        advisorID: advisorID,
        amount: amount,
        fromTime: fromTime,
        duration: duration,
        advisorName: advisorName,
        isCoinBalance: isCoinBalance,
        isFree: isFree,
      ),
    );
  }
}

class _BookingMandatePage extends StatelessWidget {
  const _BookingMandatePage({
    required this.advisorID,
    required this.advisorName,
    required this.amount,
    required this.fromTime,
    required this.duration,
    required this.isCoinBalance,
    required this.isFree,
  });
  final String advisorID;
  final String advisorName;
  final num amount;
  final String fromTime;
  final num duration;
  final bool isCoinBalance;
  final bool isFree;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.padding10,
          ).copyWith(
            top: SizeConfig.padding14,
          ),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    amount == 0 || isFree
                        ? 'Confirming Booking'
                        : 'Select Payment Application',
                    style: TextStyles.sourceSansSB.body1,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      BaseUtil.openDialog(
                        isBarrierDismissible: true,
                        addToScreenStack: true,
                        content: const DismissDailog(),
                      );
                    },
                    child: Icon(
                      Icons.close,
                      size: SizeConfig.body1,
                      color: UiConstants.kTextColor,
                    ),
                  ),
                ],
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
                enableDrag: false,
                isBarrierDismissible: false,
                addToScreenStack: false,
                content: PollingSheet(
                  paymentID: state.data.data.paymentId,
                  fromTime: fromTime,
                  advisorName: advisorName,
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
                          reddem: isCoinBalance,
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
              SubmittingPaymentFailed() => const NewErrorPage(),
              SubmittedPayment() => Container()
            };
          },
        ),
      ],
    );
  }
}

class DismissDailog extends StatelessWidget {
  const DismissDailog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding30,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          SizeConfig.roundness12,
        ),
      ),
      backgroundColor: UiConstants.bg,
      child: Column(
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
                  'Cancel Your Payment',
                  style: TextStyles.sourceSansSB.body1,
                ),
              ],
            ),
          ),
          const Divider(
            color: UiConstants.greyVarient,
          ),
          SizedBox(
            height: SizeConfig.padding22,
          ),
          AppImage(Assets.exit_logo, height: SizeConfig.padding88),
          SizedBox(
            height: SizeConfig.padding22,
          ),
          Text(
            'Confirm Payment Cancellation',
            style: TextStyles.sourceSansSB.body1,
          ),
          SizedBox(
            height: SizeConfig.padding12,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding18),
            child: Text(
              'You\'re one step away from securing your booking. Canceling may result in losing your slot.',
              style:
                  TextStyles.sourceSans.body3.colour(UiConstants.kTextColor5),
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
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding18)
                .copyWith(top: SizeConfig.padding18),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      AppState.backButtonDispatcher!.didPopRoute();
                      AppState.backButtonDispatcher!.didPopRoute();
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
                      'Cancel',
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
                      'Continue',
                      style: TextStyles.sourceSans.body3
                          .colour(UiConstants.kTextColor4),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: SizeConfig.padding18),
        ],
      ),
    );
  }
}
