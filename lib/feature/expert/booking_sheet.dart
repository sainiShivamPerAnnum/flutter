import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/model/bookings/new_booking.dart';
import 'package:felloapp/core/model/experts/experts_home.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/feature/expert/bloc/booking_bloc.dart';
import 'package:felloapp/feature/expert/bloc/cart_bloc.dart';
import 'package:felloapp/feature/expert/payment_sheet.dart';
import 'package:felloapp/feature/expert/polling_sheet.dart';
import 'package:felloapp/feature/expert/widgets/custom_switch.dart';
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
import 'package:intl/intl.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class BookCallSheetView extends StatelessWidget {
  final String advisorID;
  final String advisorName;
  final String advisorImage;
  final bool isEdit;
  final String? bookingId;
  final String? duration;
  final DateTime? scheduledOn;
  final String? selectedDate;
  final String? selectedTime;
  final int? selectedDuration;
  final bool cartPayment;

  const BookCallSheetView({
    required this.advisorID,
    required this.advisorName,
    required this.advisorImage,
    required this.isEdit,
    this.bookingId,
    this.duration,
    this.scheduledOn,
    this.selectedDate,
    this.selectedTime,
    this.selectedDuration,
    this.cartPayment = false,
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
              cartPayment
                  ? GetPricing(
                      selectedDuration!,
                      advisorID,
                      selectedDate!,
                      selectedTime!,
                      advisorName,
                    )
                  : LoadBookingDates(
                      advisorID,
                      int.tryParse(duration ?? "15") ?? 15,
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
        advisorImage: advisorImage,
      ),
    );
  }
}

class _BookCallBottomSheet extends StatefulWidget {
  const _BookCallBottomSheet({
    required this.advisorId,
    required this.advisorName,
    required this.advisorImage,
    required this.isEdit,
    this.duration,
    this.scheduledOn,
    this.bookingId,
  });
  final String advisorId;
  final String advisorName;
  final String advisorImage;
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
              state.finalSchedule,
              widget.advisorId,
              state.isFree,
            );
          } else if (state is PricingData) {
            return _buildPaymentSummary(
              context,
              state,
              widget.advisorId,
              state.isFree,
            );
          } else {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.h),
                  child: NewErrorPage(
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
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    Schedule? schedule,
    Schedule? finalSchedule,
    String advisorId,
    bool isFree,
  ) {
    final state = context.read<BookingBloc>().state;
    BookingsLoaded? loadedState = state is BookingsLoaded ? state : null;
    final selectedDate = loadedState?.selectedDate;
    final selectedDuration = loadedState?.selectedDuration;
    final selectedTime = loadedState?.selectedTime;
    final selectedMonth = loadedState?.selectedMonth ?? DateTime.now();
    final currentDurations =
        (selectedDate != null && finalSchedule?.slots?[selectedDate] != null)
            ? finalSchedule!.slots![selectedDate]!.keys.toList()
            : [];
    final durations = [
      {"name": '15 Mins', "value": 15},
      {"name": '30 Mins', "value": 30},
      {"name": '45 Mins', "value": 45},
      {"name": '1 hour', "value": 60},
    ];
    final filteredDurations = durations.where((duration) {
      final valueAsString = duration['value'].toString();
      final matchesCurrentDurations = currentDurations.contains(valueAsString);
      final isAllowedForFree =
          !isFree || (duration['value'] == 15 || duration['value'] == 30);
      return matchesCurrentDurations && isAllowedForFree;
    }).toList();
    final totalDates = schedule?.slots?.keys.toList() ?? [];
    final dates = finalSchedule?.slots?.keys.toList() ?? [];
    final List<String?> currentTimes = (selectedDate != null &&
            finalSchedule?.slots?[selectedDate] != null &&
            selectedDuration != null &&
            finalSchedule?.slots?[selectedDate]?[selectedDuration.toString()] !=
                null)
        ? finalSchedule!.slots![selectedDate]![selectedDuration.toString()]!
            .map((slot) => slot.fromTime)
            .toList()
        : [];

    final availableDatesForMonth = dates.where((date) {
      final dateTime = DateTime.parse(date);
      return dateTime.month == selectedMonth.month;
    }).toList();
    void changeMonth(DateTime newMonth) {
      final availableDatesForNewMonth = totalDates.where((date) {
        final dateTime = DateTime.parse(date);
        return dateTime.month == newMonth.month;
      }).toList();
      if (availableDatesForNewMonth.isNotEmpty) {
        context.read<BookingBloc>().add(ChangeMonth(newMonth));
      }
    }

    final slotsWithBookedSlots = generateTimeSlotsWithBookedSlots(
      currentTimes,
      selectedDuration ?? 30,
    );

    return availableDatesForMonth.isEmpty
        ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w).copyWith(
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
                          'No available slots',
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
              AppImage(Assets.noSlots, height: 124.h),
              Text(
                'No Slots Available at the Moment',
                style: TextStyles.sourceSansM.body0,
              ),
              SizedBox(
                height: 12.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 18.w,
                ),
                child: Text(
                  'Unfortunately, ${widget.advisorName} doesn’t have any available slots right now. You can discover more experts who are ready to assist you.',
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
                padding: EdgeInsets.all(18.r),
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
                          AppState.delegate!.parseRoute(Uri.parse("experts"));
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
                          'Explore Advisors',
                          style: TextStyles.sourceSans.body3
                              .colour(UiConstants.kTextColor4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                          'Book a call',
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w).copyWith(
                  top: 10.h,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: MonthButton(
                        date: DateFormat('MMMM yyyy').format(selectedMonth),
                        isSelected: false,
                        onTap: () {},
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            final prevMonth = DateTime(
                              selectedMonth.year,
                              selectedMonth.month - 1,
                            );
                            changeMonth(prevMonth);
                          },
                          child: Material(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              side: BorderSide(
                                color: UiConstants.greyVarient,
                                width: 2.w,
                              ),
                            ),
                            elevation: 0,
                            color: Colors.transparent,
                            child: Padding(
                              padding: EdgeInsets.all(8.r),
                              child: Icon(
                                Icons.chevron_left,
                                size: 14.r,
                                color: UiConstants.kTextColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        GestureDetector(
                          onTap: () {
                            final nextMonth = DateTime(
                              selectedMonth.year,
                              selectedMonth.month + 1,
                            );
                            changeMonth(nextMonth);
                          },
                          child: Material(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              side: BorderSide(
                                color: UiConstants.greyVarient,
                                width: 2.w,
                              ),
                            ),
                            elevation: 0,
                            color: Colors.transparent,
                            child: Padding(
                              padding: EdgeInsets.all(8.r),
                              child: Icon(
                                Icons.chevron_right,
                                size: 14.r,
                                color: UiConstants.kTextColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(18.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: dates.map((date) {
                            return Padding(
                              padding: EdgeInsets.only(right: 12.w),
                              child: DateButton(
                                date: date,
                                isSelected: date == selectedDate,
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: getDayAndDateParts(date).day,
                                        style: TextStyles.sourceSansM.body4
                                            .copyWith(
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: SizedBox(
                                          height: 2.h,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            '\n${getDayAndDateParts(date).date}',
                                        style: TextStyles.sourceSansM.body0
                                            .copyWith(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  context
                                      .read<BookingBloc>()
                                      .add(SelectDate(date));
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    if (!widget.isEdit) SizedBox(height: 16.h),
                    if (!widget.isEdit)
                      Divider(
                        color: UiConstants.kTextColor5.withOpacity(.3),
                      ),
                    if (!widget.isEdit)
                      Text(
                        'Select Duration',
                        style: TextStyles.sourceSansSB.body2,
                      ),
                    if (!widget.isEdit) SizedBox(height: 16.h),
                    if (!widget.isEdit)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: filteredDurations.map((e) {
                          return Padding(
                            padding: EdgeInsets.only(right: 12.w),
                            child: DateButton(
                              date: e['name'].toString(),
                              requireFormat: false,
                              padding: EdgeInsets.symmetric(
                                vertical: 8.h,
                                horizontal: 24.w,
                              ),
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
                    SizedBox(height: 16.h),
                    Divider(
                      color: UiConstants.kTextColor5.withOpacity(.3),
                    ),
                    Text(
                      'Select Time',
                      style: TextStyles.sourceSansSB.body2,
                    ),
                    SizedBox(height: 16.h),
                    SizedBox(
                      height: 70.h,
                      child: GridView.builder(
                        shrinkWrap: true,
                        itemCount: slotsWithBookedSlots.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12.h,
                          mainAxisSpacing: 16.w,
                          childAspectRatio: 3,
                        ),
                        itemBuilder: (context, index) {
                          final time = slotsWithBookedSlots[index];
                          final isBookedSlot = time!.startsWith('BOOKED_');
                          final displayTime = isBookedSlot
                              ? time.replaceFirst('BOOKED_', '')
                              : time;
                          return TimeButton(
                            time: time,
                            isSelected: displayTime == selectedTime,
                            onTap: () {
                              context
                                  .read<BookingBloc>()
                                  .add(SelectTime(displayTime));
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
              SizedBox(height: 18.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
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
                              context.read<CartBloc>().add(
                                    AddToCart(
                                      advisor: Expert(
                                        advisorId: widget.advisorId,
                                        name: widget.advisorName,
                                        experience: '',
                                        rating: 0,
                                        expertise: '',
                                        qualifications: '',
                                        rate: 0,
                                        rateNew: '',
                                        image: widget.advisorImage,
                                        isFree: false,
                                      ),
                                      selectedDate: state.selectedDate,
                                      selectedTime: state.selectedTime,
                                      selectedDuration: state.selectedDuration,
                                    ),
                                  );
                              context.read<BookingBloc>().add(
                                    GetPricing(
                                      state.selectedDuration,
                                      widget.advisorId,
                                      state.selectedDate!,
                                      state.selectedTime!,
                                      widget.advisorName,
                                      isFree: true,
                                    ),
                                  );
                            } else {
                              context.read<CartBloc>().add(
                                    AddToCart(
                                      advisor: Expert(
                                        advisorId: widget.advisorId,
                                        name: widget.advisorName,
                                        experience: '',
                                        rating: 0,
                                        expertise: '',
                                        qualifications: '',
                                        rate: 0,
                                        rateNew: '',
                                        image: widget.advisorImage,
                                        isFree: false,
                                      ),
                                      selectedDate: state.selectedDate,
                                      selectedTime: state.selectedTime,
                                      selectedDuration: state.selectedDuration,
                                    ),
                                  );
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
                            vertical: 16.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
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
              SizedBox(height: 40.h),
            ],
          );
  }
}

class DateButton extends StatelessWidget {
  final String date;
  final bool isSelected;
  final EdgeInsets? padding;
  final VoidCallback onTap;
  final bool requireFormat;
  final Widget? child;

  const DateButton({
    required this.date,
    required this.isSelected,
    required this.onTap,
    this.padding,
    this.requireFormat = true,
    this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: UiConstants.kBackgroundColor,
        padding: padding ??
            EdgeInsets.symmetric(
              vertical: 18.h,
              horizontal: 10.w,
            ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
          side: BorderSide(
            color:
                isSelected ? UiConstants.kTextColor : UiConstants.greyVarient,
            width: 1.w,
          ),
        ),
      ),
      child: child ??
          Text(
            requireFormat ? getDayAndDate(date) : date,
            textAlign: TextAlign.center,
            style: TextStyles.sourceSansM.body4,
          ),
    );
  }
}

({String day, String date}) getDayAndDateParts(String dateString) {
  DateTime date = DateTime.parse(dateString);
  String day = DateFormat('EEE').format(date);
  String formattedDate = DateFormat('dd').format(date);

  return (day: day, date: formattedDate);
}

class MonthButton extends StatelessWidget {
  final String date;
  final bool isSelected;
  final VoidCallback onTap;
  final bool requireFormat;

  const MonthButton({
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
          vertical: 8.h,
          horizontal: 10.h,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
          side: BorderSide(
            color:
                isSelected ? UiConstants.kTextColor : UiConstants.greyVarient,
            width: 2.w,
          ),
        ),
      ),
      child: Text(
        date,
        textAlign: TextAlign.center,
        style: TextStyles.sourceSansM.body4,
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

List<String?> generateTimeSlotsWithBookedSlots(
  List<String?> availableSlots,
  int selectedDuration,
) {
  if (availableSlots.isEmpty) {
    return availableSlots;
  }
  final startTime =
      DateTime.tryParse(availableSlots.first ?? '') ?? DateTime.now();
  final endTime =
      DateTime.tryParse(availableSlots.last ?? '') ?? DateTime.now();

  final allSlots = <String>[];
  final bookedSlots = <String>[];
  DateTime currentTime = startTime;
  while (
      currentTime.isBefore(endTime) || currentTime.isAtSameMomentAs(endTime)) {
    final currentTimeString = currentTime.toIso8601String();
    if (availableSlots.contains(currentTimeString)) {
      allSlots.add(currentTimeString);
    } else {
      final bookedSlotString = 'BOOKED_$currentTimeString';
      allSlots.add(bookedSlotString);
      bookedSlots.add(bookedSlotString);
    }
    currentTime = currentTime.add(Duration(minutes: selectedDuration));
  }
  while (bookedSlots.length < 3) {
    final lastSlot =
        DateTime.tryParse(allSlots.last.replaceFirst('BOOKED_', '')) ??
            DateTime.now();
    final newBookedSlot = lastSlot.add(Duration(minutes: selectedDuration));
    final newBookedSlotString = 'BOOKED_${newBookedSlot.toIso8601String()}';
    allSlots.add(newBookedSlotString);
    bookedSlots.add(newBookedSlotString);
  }
  return allSlots;
}

class TimeButton extends StatelessWidget {
  final String time;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isBooked;

  const TimeButton({
    required this.time,
    required this.isSelected,
    required this.onTap,
    this.isBooked = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isBookedSlot = time.startsWith('BOOKED_');
    final displayTime = isBookedSlot
        ? getTimeIn12HourFormat(time.replaceFirst('BOOKED_', ''))
        : getTimeIn12HourFormat(time);

    return ElevatedButton(
      onPressed: isBookedSlot ? null : onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: isBookedSlot
            ? const Color(0xffA6A6AC).withOpacity(0.07)
            : UiConstants.kBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
          side: BorderSide(
            color: isBookedSlot
                ? UiConstants.kTextColor6.withOpacity(0.07)
                : (isSelected
                    ? UiConstants.kTextColor
                    : UiConstants.greyVarient),
            width: 1.w,
          ),
        ),
      ),
      child: Text(
        displayTime,
        style: TextStyles.sourceSansM.body4.copyWith(
          color: isBookedSlot ? UiConstants.kTextColor6.withOpacity(0.5) : null,
        ),
      ),
    );
  }
}

Widget _buildPaymentSummary(
  BuildContext context,
  PricingData state,
  String advisorId,
  bool isFree,
) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
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
                  isFree ? "Call Confirmation" : 'Payment Summary',
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
      Container(
        padding: EdgeInsets.all(18.r),
        margin: EdgeInsets.all(18.r),
        decoration: BoxDecoration(
          color: UiConstants.greyVarient,
          borderRadius: BorderRadius.circular(12.r),
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
              height: 10.h,
            ),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: UiConstants.kTextColor5,
                  size: 14.r,
                ),
                SizedBox(width: 8.w),
                Text(
                  getTimeIn12HourFormat(state.time),
                  style: TextStyles.sourceSans.body3
                      .colour(UiConstants.customSubtitle),
                ),
                SizedBox(width: 12.w),
                Icon(
                  Icons.calendar_today,
                  color: UiConstants.kTextColor5,
                  size: 14.r,
                ),
                SizedBox(width: 8.w),
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
          left: 18.w,
          right: 18.w,
        ),
        decoration: BoxDecoration(
          color: UiConstants.greyVarient,
          borderRadius: BorderRadius.circular(12.r),
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
              padding: EdgeInsets.all(18.r),
              child: Column(
                children: [
                  _buildSummary(
                    'Call Duration',
                    '${state.duration} Mins',
                  ),
                  _buildDottedDivider(),
                  _buildSummaryRow(
                    'Price',
                    '₹${state.price}',
                    isFree: isFree,
                    subText: 'Free',
                    textColor: isFree
                        ? UiConstants.kTextColor.withOpacity(.6)
                        : UiConstants.kTextColor,
                  ),
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
                                isFree: isFree,
                              ),
                              _buildDottedDivider(),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),
                  _buildSummaryRow(
                    'GST (18%)',
                    '₹${state.gst}',
                    isFree: isFree,
                    subText: '₹0',
                    textColor: isFree
                        ? UiConstants.kTextColor.withOpacity(.6)
                        : UiConstants.kTextColor,
                  ),
                  _buildDottedDivider(),
                  _buildSummaryRow(
                    'Net Payable',
                    '₹${state.totalPayable}',
                    isFinalValue: true,
                    isFree: isFree,
                    textColor: isFree
                        ? UiConstants.kTabBorderColor
                        : UiConstants.kTextColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        height: 18.h,
      ),
      const Divider(
        color: UiConstants.greyVarient,
      ),
      Padding(
        padding: EdgeInsets.all(18.r).copyWith(
          bottom: 40.h,
        ),
        child: isFree
            ? Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
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
                        AppState.screenStack.add(ScreenItem.modalsheet);
                        BaseUtil.openModalBottomSheet(
                          isScrollControlled: true,
                          enableDrag: false,
                          isBarrierDismissible: false,
                          addToScreenStack: false,
                          content: PaymentSheet(
                            isCoinBalance: state.reedem,
                            advisorID: state.advisorId,
                            amount: 0,
                            fromTime: state.time,
                            duration: state.duration,
                            advisorName: state.advisorName,
                            isFree: true,
                          ),
                          backgroundColor: UiConstants.kBackgroundColor,
                          hapticVibrate: true,
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
                        'Confirm',
                        style: TextStyles.sourceSans.body3
                            .colour(UiConstants.kTextColor4),
                      ),
                    ),
                  ),
                ],
              )
            : SizedBox(
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
                        isFree: false,
                      ),
                      backgroundColor: UiConstants.kBackgroundColor,
                      hapticVibrate: true,
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
                    'Make Payment',
                    style: TextStyles.sourceSans.body3
                        .colour(UiConstants.kTextColor4),
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
        topLeft: Radius.circular(12.r),
        topRight: Radius.circular(12.r),
      ),
    ),
    padding: EdgeInsets.symmetric(
      vertical: 12.h,
      horizontal: 20.w,
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
              width: 8.w,
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
  bool isFinalValue = false,
  Color textColor = UiConstants.kTextColor,
  Color subTextColor = UiConstants.kTextColor,
  bool isFree = false,
  String? subText,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 4.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isFinalValue
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (isFree && subText != null)
                Padding(
                  padding: EdgeInsets.only(right: 6.w),
                  child: Text(
                    subText,
                    style: TextStyles.sourceSansSB.body2.colour(subTextColor),
                  ),
                ),
              Text(
                isFinalValue && isFree ? 'FREE' : value,
                key: ValueKey(value),
                style: isFinalValue
                    ? TextStyles.sourceSansSB.body2.colour(textColor).copyWith(
                          decoration: isFree && !isFinalValue
                              ? TextDecoration.lineThrough
                              : null,
                          decorationColor: UiConstants.kTextColor,
                        )
                    : TextStyles.sourceSans.body3.colour(textColor).copyWith(
                          decoration: isFree && !isFinalValue
                              ? TextDecoration.lineThrough
                              : null,
                          decorationColor: UiConstants.kTextColor,
                        ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildSummary(
  String label,
  String value, {
  bool isFinalValue = false,
  Color textColor = UiConstants.kTextColor,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 4.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isFinalValue
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
            style: isFinalValue
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
          width: 3.w,
          height: 1.h,
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
