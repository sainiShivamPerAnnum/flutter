import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/model/bookings/new_booking.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/feature/expert/bloc/booking_bloc.dart';
import 'package:felloapp/feature/expert/payment_sheet.dart';
import 'package:felloapp/feature/expert/polling_sheet.dart';
import 'package:felloapp/feature/expert/widgets/custom_switch.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/error_page.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class BookCallSheetView extends StatelessWidget {
  final String advisorID;
  final String advisorName;
  final bool isEdit;
  final String? bookingId;
  final String? duration;
  final DateTime? scheduledOn;
  const BookCallSheetView({
    required this.advisorID,
    required this.advisorName,
    required this.isEdit,
    this.bookingId,
    this.duration,
    this.scheduledOn,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => BookingBloc(
            locator(),
            locator(),
            locator(),
            locator(),
          )..add(
              LoadBookingDates(
                advisorID,
                int.tryParse(duration ?? "30") ?? 30,
                scheduledOn,
              ),
            ),
        ),
        BlocProvider(
          create: (context) => PaymentBloc(
            locator(),
            locator(),
            locator(),
          ),
        ),
      ],
      child: _BookCallBottomSheet(
        advisorId: advisorID,
        advisorName: advisorName,
        isEdit: isEdit,
        bookingId: bookingId,
        duration: duration,
        scheduledOn: scheduledOn,
      ),
    );
  }
}

class _BookCallBottomSheet extends StatefulWidget {
  const _BookCallBottomSheet({
    required this.advisorId,
    required this.advisorName,
    required this.isEdit,
    this.duration,
    this.scheduledOn,
    this.bookingId,
  });
  final String advisorId;
  final String advisorName;
  final bool isEdit;
  final String? bookingId;
  final String? duration;
  final DateTime? scheduledOn;

  @override
  State<_BookCallBottomSheet> createState() => _BookCallBottomSheetState();
}

class _BookCallBottomSheetState extends State<_BookCallBottomSheet> {
  String? selectedDate;
  String? selectedTime;

  @override
  Widget build(BuildContext context) {
    return BlocListener<PaymentBloc, PaymentState>(
      listener: (context, state) {
        if (state is SubmittedPayment) {
          AppState.backButtonDispatcher!.didPopRoute();
          AppState.screenStack.add(ScreenItem.modalsheet);
          BaseUtil.openModalBottomSheet(
            isScrollControlled: true,
            enableDrag: true,
            isBarrierDismissible: false,
            addToScreenStack: false,
            content: PollingSheet(
              paymentID: state.data.data.paymentId,
              advisorName: widget.advisorName,
              fromTime: selectedTime ?? DateTime.now().toString(),
            ),
            backgroundColor: UiConstants.kBackgroundColor,
            hapticVibrate: true,
          );
        }
      },
      child: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          if (state is LoadingBookingsData) {
            return const Column(
              mainAxisSize: MainAxisSize.min,
              children: [FullScreenLoader()],
            );
          } else if (state is BookingsLoaded) {
            return _buildContent(
              context,
              state.schedule,
              widget.advisorId,
              state.isFree,
            );
          } else if (state is PricingData) {
            return _buildPaymentSummary(context, state, widget.advisorId);
          } else {
            return NewErrorPage(
              onTryAgain: () {
                BlocProvider.of<BookingBloc>(
                  context,
                  listen: false,
                ).add(
                  LoadBookingDates(
                    widget.advisorId,
                    int.tryParse(widget.duration ?? "30") ?? 30,
                    widget.scheduledOn,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    Schedule? schedule,
    String advisorId,
    bool isFree,
  ) {
    final state = context.read<BookingBloc>().state;
    BookingsLoaded? loadedState = state is BookingsLoaded ? state : null;
    final selectedDate = loadedState?.selectedDate;
    final selectedDuration = loadedState?.selectedDuration;
    final selectedTime = loadedState?.selectedTime;
    final duration = [
      {"name": '15 Mins', "value": 15},
      {"name": '30 Mins', "value": 30},
      {"name": '45 Mins', "value": 45},
      {"name": '1 hour', "value": 60},
    ];
    final dates = schedule?.slots?.keys.toList() ?? [];
    final currentTimes =
        (selectedDate != null && schedule?.slots?[selectedDate] != null)
            ? schedule!.slots![selectedDate]!.map((e) => e.fromTime).toList()
            : [];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.padding20,
          ).copyWith(
            top: SizeConfig.padding12,
          ),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Book a call',
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
                      AppState.backButtonDispatcher!.didPopRoute();
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
        Container(
          padding: EdgeInsets.all(SizeConfig.padding18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Date',
                style: TextStyles.sourceSansSB.body2,
              ),
              SizedBox(height: SizeConfig.padding16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: dates.map((date) {
                    return Padding(
                      padding: EdgeInsets.only(right: SizeConfig.padding12),
                      child: DateButton(
                        date: date,
                        isSelected: date == selectedDate,
                        onTap: () {
                          context.read<BookingBloc>().add(SelectDate(date));
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              if (!widget.isEdit) SizedBox(height: SizeConfig.padding16),
              if (!widget.isEdit)
                Divider(
                  color: UiConstants.kTextColor5.withOpacity(.3),
                ),
              if (!widget.isEdit)
                Text(
                  'Select Duration',
                  style: TextStyles.sourceSansSB.body2,
                ),
              if (!widget.isEdit) SizedBox(height: SizeConfig.padding16),
              if (!widget.isEdit)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: duration.take(isFree ? 2 : 4).map((e) {
                    return Padding(
                      padding: EdgeInsets.only(right: SizeConfig.padding12),
                      child: DateButton(
                        date: e['name'].toString(),
                        requireFormat: false,
                        isSelected: e['value'] == selectedDuration,
                        onTap: () {
                          context
                              .read<BookingBloc>()
                              .add(SelectDuration(e['value'] as int));
                        },
                      ),
                    );
                  }).toList(),
                ),
              SizedBox(height: SizeConfig.padding16),
              Divider(
                color: UiConstants.kTextColor5.withOpacity(.3),
              ),
              Text(
                'Select Time',
                style: TextStyles.sourceSansSB.body2,
              ),
              SizedBox(height: SizeConfig.padding16),
              Container(
                constraints: BoxConstraints(maxHeight: SizeConfig.padding252),
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: currentTimes.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: SizeConfig.padding12,
                    mainAxisSpacing: SizeConfig.padding16,
                    childAspectRatio: 3,
                  ),
                  itemBuilder: (context, index) {
                    final time = currentTimes[index];
                    final displayTime = time?.split(' ')[0];
                    return TimeButton(
                      time: displayTime!,
                      isSelected: time == selectedTime,
                      onTap: () {
                        context.read<BookingBloc>().add(SelectTime(time));
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: UiConstants.kTextColor5.withOpacity(.3),
        ),
        SizedBox(height: SizeConfig.padding18),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding18),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
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
                    final state = context.read<BookingBloc>().state;

                    if (state is BookingsLoaded &&
                        state.selectedDate != null &&
                        state.selectedTime != null) {
                      if (widget.isEdit && widget.bookingId != null) {
                        final event = EditBooking(
                          bookingId: widget.bookingId!,
                          selectedDate: state.selectedTime!,
                          duration: state.selectedDuration,
                        );
                        context.read<BookingBloc>().add(event);
                      } else if (state.isFree) {
                        final event = SubmitPaymentRequest(
                          reddem: false,
                          advisorId: widget.advisorId,
                          amount: 0,
                          fromTime: state.selectedTime!,
                          duration: state.selectedDuration,
                          appuse: null,
                          isFree: true,
                        );
                        context.read<PaymentBloc>().add(event);
                      } else {
                        context.read<BookingBloc>().add(
                              GetPricing(
                                state.selectedDuration,
                                widget.advisorId,
                                state.selectedDate!,
                                state.selectedTime!,
                                widget.advisorName,
                              ),
                            );
                      }
                    } else {
                      BaseUtil.showNegativeAlert(
                        'Try Again',
                        "Please select both date and time",
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (state is BookingsLoaded &&
                                state.selectedDate == null) ||
                            (state is BookingsLoaded &&
                                state.selectedTime == null)
                        ? UiConstants.kTextColor.withOpacity(0.3)
                        : UiConstants.kTextColor,
                    padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.padding16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness8),
                    ),
                  ),
                  child: Text(
                    'Confirm',
                    style: TextStyles.sourceSans.body3.colour(
                      UiConstants.kTextColor4,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: SizeConfig.padding40),
      ],
    );
  }
}

class DateButton extends StatelessWidget {
  final String date;
  final bool isSelected;
  final VoidCallback onTap;
  final bool requireFormat;

  const DateButton({
    required this.date,
    required this.isSelected,
    required this.onTap,
    this.requireFormat = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: UiConstants.kBackgroundColor,
        padding: EdgeInsets.symmetric(
          vertical: SizeConfig.padding8,
          horizontal: SizeConfig.padding10,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SizeConfig.roundness5),
          side: BorderSide(
            color:
                isSelected ? UiConstants.kTextColor : UiConstants.greyVarient,
            width: SizeConfig.padding2,
          ),
        ),
      ),
      child: Text(
        requireFormat ? getDayAndDate(date) : date,
        textAlign: TextAlign.center,
        style: TextStyles.sourceSansSB.body3,
      ),
    );
  }
}

String getDayAndDate(String dateString) {
  DateTime date = DateTime.parse(dateString);
  String day = DateFormat('EEE').format(date);
  String formattedDate = DateFormat('dd').format(date);

  return '$day\n$formattedDate';
}

String getTimeIn12HourFormat(String timeString) {
  DateTime time = DateTime.parse(timeString);
  String formattedTime = DateFormat('hh:mm a').format(time);

  return formattedTime;
}

String formatDate(String dateString) {
  DateTime date = DateTime.parse(dateString);
  String day = DateFormat('d').format(date);
  String suffix;

  if (day.endsWith('1') && !day.endsWith('11')) {
    suffix = 'st';
  } else if (day.endsWith('2') && !day.endsWith('12')) {
    suffix = 'nd';
  } else if (day.endsWith('3') && !day.endsWith('13')) {
    suffix = 'rd';
  } else {
    suffix = 'th';
  }

  String formattedDate = DateFormat("d'$suffix' MMM yyyy").format(date);
  return formattedDate;
}

class TimeButton extends StatelessWidget {
  final String time;
  final bool isSelected;
  final VoidCallback onTap;

  const TimeButton({
    required this.time,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: UiConstants.kBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SizeConfig.roundness8),
          side: BorderSide(
            color:
                isSelected ? UiConstants.kTextColor : UiConstants.greyVarient,
            width: SizeConfig.padding2,
          ),
        ),
      ),
      child: Text(
        getTimeIn12HourFormat(time),
        style: TextStyles.sourceSans.body3,
      ),
    );
  }
}

Widget _buildPaymentSummary(
  BuildContext context,
  PricingData state,
  String advisorId,
) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.padding20,
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
                  'Payment Summary',
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
                    AppState.backButtonDispatcher!.didPopRoute();
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
      Container(
        padding: EdgeInsets.all(SizeConfig.padding18),
        margin: EdgeInsets.all(SizeConfig.padding18),
        decoration: BoxDecoration(
          color: UiConstants.greyVarient,
          borderRadius: BorderRadius.circular(SizeConfig.roundness12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Call with ${state.advisorName}',
              style: TextStyles.sourceSansSB.body2,
            ),
            SizedBox(
              height: SizeConfig.padding10,
            ),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: UiConstants.kTextColor5,
                  size: SizeConfig.body3,
                ),
                SizedBox(width: SizeConfig.padding8),
                Text(
                  getTimeIn12HourFormat(state.time),
                  style: TextStyles.sourceSans.body3
                      .colour(UiConstants.customSubtitle),
                ),
                SizedBox(width: SizeConfig.padding12),
                Icon(
                  Icons.calendar_today,
                  color: UiConstants.kTextColor5,
                  size: SizeConfig.body3,
                ),
                SizedBox(width: SizeConfig.padding8),
                Text(
                  formatDate(state.date),
                  style: TextStyles.sourceSans.body3
                      .colour(UiConstants.customSubtitle),
                ),
              ],
            ),
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.only(
          left: SizeConfig.padding18,
          right: SizeConfig.padding18,
        ),
        decoration: BoxDecoration(
          color: UiConstants.greyVarient,
          borderRadius: BorderRadius.circular(SizeConfig.roundness12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PropertyChangeConsumer<UserService, UserServiceProperties>(
              properties: const [UserServiceProperties.myUserFund],
              builder: (context, m, property) {
                final minWithdrawPrize = m?.baseUser!.minRedemptionAmt;
                bool isEnabled =
                    (m?.userFundWallet?.unclaimedBalance.toInt() ?? 0) >=
                        (minWithdrawPrize ?? 200);
                return isEnabled
                    ? _buildCoinsRow(
                        isLoading: state.isApplyingReedem,
                        value: state.reedem,
                        onChanged: (p0) {
                          context.read<BookingBloc>().add(
                                SelectReedem(p0, state.duration, advisorId),
                              );
                        },
                      )
                    : const SizedBox.shrink();
              },
            ),
            Padding(
              padding: EdgeInsets.all(SizeConfig.padding18),
              child: Column(
                children: [
                  _buildSummaryRow('Call Duration', '${state.duration} Mins'),
                  _buildDottedDivider(),
                  _buildSummaryRow('Price', '₹${state.price}'),
                  _buildDottedDivider(),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: SizeTransition(
                        sizeFactor: animation,
                        child: child,
                      ),
                    ),
                    child: state.reedem
                        ? Column(
                            children: [
                              _buildSummaryRow(
                                'Reward Points',
                                '-${state.coinBalanceUse}',
                                textColor: UiConstants.teal3,
                              ),
                              _buildDottedDivider(),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),
                  _buildSummaryRow('GST (18%)', '₹${state.gst}'),
                  _buildDottedDivider(),
                  _buildSummaryRow(
                    'Net Payable',
                    '₹${state.totalPayable}',
                    isBold: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.all(SizeConfig.padding18),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              AppState.backButtonDispatcher!.didPopRoute();
              AppState.screenStack.add(ScreenItem.modalsheet);
              BaseUtil.openModalBottomSheet(
                isScrollControlled: true,
                enableDrag: false,
                isBarrierDismissible: false,
                addToScreenStack: false,
                content: PaymentSheet(
                  isCoinBalance: state.reedem,
                  advisorID: state.advisorId,
                  amount: state.totalPayable,
                  fromTime: state.time,
                  duration: state.duration,
                  advisorName: state.advisorName,
                ),
                backgroundColor: UiConstants.kBackgroundColor,
                hapticVibrate: true,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: UiConstants.kTextColor,
              padding: EdgeInsets.symmetric(
                vertical: SizeConfig.padding16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SizeConfig.roundness8),
              ),
            ),
            child: Text(
              'Make Payment',
              style:
                  TextStyles.sourceSans.body3.colour(UiConstants.kTextColor4),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget _buildCoinsRow({
  bool isLoading = false,
  bool isBold = false,
  bool value = false,
  Function(bool)? onChanged,
}) {
  return Container(
    decoration: BoxDecoration(
      color: UiConstants.kTextColor.withOpacity(.1),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(SizeConfig.roundness12),
        topRight: Radius.circular(SizeConfig.roundness12),
      ),
    ),
    padding: EdgeInsets.symmetric(
      vertical: SizeConfig.padding12,
      horizontal: SizeConfig.padding20,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Reward Points',
          style: isBold
              ? TextStyles.sourceSansSB.body2.colour(UiConstants.textGray70)
              : TextStyles.sourceSans.body3.colour(UiConstants.textGray70),
        ),
        Row(
          children: [
            PropertyChangeConsumer<UserService, UserServiceProperties>(
              properties: const [UserServiceProperties.myUserFund],
              builder: (context, m, property) {
                return Text(
                  "${m?.userFundWallet?.unclaimedBalance.toInt() ?? '-'} coins",
                  style: TextStyles.sourceSans.body4,
                );
              },
            ),
            SizedBox(
              width: SizeConfig.padding8,
            ),
            CustomSwitchNew(
              isLoading: isLoading,
              initialValue: value,
              onChanged: onChanged,
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildSummaryRow(
  String label,
  String value, {
  bool isBold = false,
  Color textColor = UiConstants.kTextColor,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: SizeConfig.padding4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isBold
              ? TextStyles.sourceSansSB.body2.colour(
                  UiConstants.textGray70,
                )
              : TextStyles.sourceSans.body3.colour(
                  UiConstants.textGray70,
                ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: child,
          ),
          child: Text(
            value,
            key: ValueKey(value),
            style: isBold
                ? TextStyles.sourceSansSB.body2.colour(textColor)
                : TextStyles.sourceSans.body3.colour(textColor),
          ),
        ),
      ],
    ),
  );
}

Widget drawDottedLine({required int lenghtOfStripes}) {
  return Row(
    children: [
      for (int i = 0; i < lenghtOfStripes; i++)
        Container(
          width: SizeConfig.padding3,
          height: SizeConfig.padding1,
          decoration: BoxDecoration(
            color: i % 2 == 0 ? UiConstants.textGray70 : Colors.transparent,
          ),
        ),
    ],
  );
}

Widget _buildDottedDivider() {
  return SizedBox(
    height: 10,
    child: CustomPaint(
      painter: DottedDashLinePainter(
        color: UiConstants.kTextColor,
      ),
      child: Container(),
    ),
  );
}

class DottedDashLinePainter extends CustomPainter {
  final double dashLength;
  final double gapLength;
  final double radius;
  final Color color;

  DottedDashLinePainter({
    this.dashLength = 2.0,
    this.gapLength = 3.0,
    this.radius = 2.0,
    this.color = Colors.white,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double startX = 0.0;
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashLength, size.height / 2),
        paint,
      );
      startX += dashLength + gapLength;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
