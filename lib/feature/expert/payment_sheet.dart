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
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
            horizontal: 10.w,
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
                  IconButton(
                    iconSize: 18.r,
                    splashRadius: 18.r,
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      BaseUtil.openDialog(
                        isBarrierDismissible: true,
                        addToScreenStack: true,
                        content: const DismissDailog(),
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
                  padding: EdgeInsets.all(16.w),
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
        horizontal: 30.w,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          12.r,
        ),
      ),
      backgroundColor: UiConstants.bg,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
            ).copyWith(
              top: 14.h,
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
            height: 22.h,
          ),
          AppImage(Assets.exit_logo, height: 88.h),
          SizedBox(
            height: 22.h,
          ),
          Text(
            'Confirm Payment Cancellation',
            style: TextStyles.sourceSansSB.body1,
          ),
          SizedBox(
            height: 12.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: Text(
              'You\'re one step away from securing your booking. Canceling may result in losing your slot.',
              style:
                  TextStyles.sourceSans.body3.colour(UiConstants.kTextColor5),
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
            padding: EdgeInsets.symmetric(horizontal: 18.w).copyWith(top: 18.h),
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
                        vertical: 16.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Cancel',
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
                      'Continue',
                      style: TextStyles.sourceSans.body3
                          .colour(UiConstants.kTextColor4),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 18.h),
        ],
      ),
    );
  }
}
