import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/model/bookings/new_booking.dart';
import 'package:felloapp/feature/expert/bloc/booking_bloc.dart';
import 'package:felloapp/feature/expert/payment_sheet.dart';
import 'package:felloapp/feature/p2p_home/ui/shared/error_state.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class BookCallSheetView extends StatelessWidget {
  final String advisorID;
  final String advisorName;
  const BookCallSheetView({
    required this.advisorID,
    required this.advisorName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookingBloc(
        locator(),
        locator(),
      )..add(LoadBookingDates(advisorID, 30)),
      child: _BookCallBottomSheet(
        advisorId: advisorID,
        advisorName: advisorName,
      ),
    );
  }
}

class _BookCallBottomSheet extends StatefulWidget {
  const _BookCallBottomSheet({
    required this.advisorId,
    required this.advisorName,
  });
  final String advisorId;
  final String advisorName;

  @override
  State<_BookCallBottomSheet> createState() => _BookCallBottomSheetState();
}

class _BookCallBottomSheetState extends State<_BookCallBottomSheet> {
  String? selectedDate;
  String? selectedTime;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        if (state is LoadingBookingsData) {
          return const Column(
            mainAxisSize: MainAxisSize.min,
            children: [FullScreenLoader()],
          );
        } else if (state is BookingsLoaded) {
          return _buildContent(context, state.schedule, widget.advisorId);
        } else if (state is PricingData) {
          return _buildPaymentSummary(context, state);
        } else {
          return const ErrorPage();
        }
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    Schedule? schedule,
    String advisorId,
  ) {
    final state = context.read<BookingBloc>().state;
    final selectedDate = state is BookingsLoaded ? state.selectedDate : null;
    final selectedDuration =
        state is BookingsLoaded ? state.selectedDuration : null;
    final selectedTime = state is BookingsLoaded ? state.selectedTime : null;
    final duration = [
      {"name": '15 Mins', "value": 15},
      {"name": '30 Mins', "value": 30},
      {"name": '45 Mins', "value": 45},
      {"name": '1 hour', "value": 60},
    ];
    final dates = schedule?.slots?.keys.toList() ?? [];

    final currentTimes = selectedDate != null
        ? schedule!.slots![selectedDate]!.map((e) => e.fromTime).toList()
        : [];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
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
                'Book a call',
                style: TextStyles.sourceSansSB.body1,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: dates.take(4).map((date) {
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
              SizedBox(height: SizeConfig.padding16),
              Divider(
                color: UiConstants.kTextColor5.withOpacity(.3),
              ),
              Text(
                'Select Duration',
                style: TextStyles.sourceSansSB.body2,
              ),
              SizedBox(height: SizeConfig.padding16),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: duration.take(4).map((e) {
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
                      context.read<BookingBloc>().add(
                            GetPricing(
                              state.selectedDuration,
                              widget.advisorId,
                              state.selectedDate!,
                              state.selectedTime!,
                              widget.advisorName,
                            ),
                          );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select both date and time'),
                        ),
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

Widget _buildPaymentSummary(BuildContext context, PricingData state) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
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
              'Payment Summary',
              style: TextStyles.sourceSansSB.body1,
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
        padding: EdgeInsets.all(SizeConfig.padding18),
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
            _buildSummaryRow('Call Duration', '${state.duration} Mins'),
            _buildDottedDivider(),
            _buildSummaryRow('Price', '₹${state.price}'),
            _buildSummaryRow('GST (18%)', '₹${state.gst}'),
            const Divider(color: UiConstants.greyVarient),
            _buildSummaryRow(
              'Net Payable',
              '₹${state.totalPayable}',
              isBold: true,
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
                enableDrag: true,
                isBarrierDismissible: true,
                addToScreenStack: false,
                content: PaymentSheet(
                  advisorID: state.advisorId,
                  amount: state.price,
                  fromTime: state.time,
                  duration: state.duration,
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

Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: SizeConfig.padding4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isBold
              ? TextStyles.sourceSansSB.body2.colour(UiConstants.textGray70)
              : TextStyles.sourceSans.body3.colour(UiConstants.textGray70),
        ),
        Text(
          value,
          style: isBold
              ? TextStyles.sourceSansSB.body2
              : TextStyles.sourceSans.body3,
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
    height: 10, // Adjust the height as needed
    child: CustomPaint(
      painter: DottedLinePainter(
        gap: 5.0, // Adjust the gap between dots
        radius: 2.0, // Adjust the size of the dots
        color: UiConstants.greyVarient, // Adjust the color as needed
      ),
      child: Container(),
    ),
  );
}

class DottedLinePainter extends CustomPainter {
  final double gap;
  final double radius;
  final Color color;

  DottedLinePainter({
    this.gap = 5.0,
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
      canvas.drawCircle(Offset(startX, size.height / 2), radius, paint);
      startX += 2 * radius + gap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
