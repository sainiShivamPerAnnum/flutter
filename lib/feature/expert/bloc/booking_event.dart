part of 'booking_bloc.dart';

sealed class BookingEvent {
  const BookingEvent();
}

class LoadBookingDates extends BookingEvent {
  const LoadBookingDates(this.advisorId, this.duration,this.scheduledOn);
  final String advisorId;
  final int duration;
  final DateTime? scheduledOn;
}

class SelectDate extends BookingEvent {
  final String selectedDate;
  const SelectDate(this.selectedDate);
}

class SelectDuration extends BookingEvent {
  final int selectDuration;
  const SelectDuration(this.selectDuration);
}

class SelectTime extends BookingEvent {
  final String selectedTime;
  const SelectTime(this.selectedTime);
}

class GetPricing extends BookingEvent {
  final int duration;
  final String advisorId;
  final String selectedDate;
  final String selectedTime;
  final String advisorName;
  const GetPricing(
    this.duration,
    this.advisorId,
    this.selectedDate,
    this.selectedTime,
    this.advisorName,
  );
}

class LoadPSPApps extends BookingEvent {
  const LoadPSPApps();
}

class SubmitPaymentRequest extends BookingEvent {
  const SubmitPaymentRequest({
    required this.advisorId,
    required this.amount,
    required this.fromTime,
    required this.duration,
    required this.appuse,
    required this.isFree,
  });
  final String advisorId;
  final num amount;
  final String fromTime;
  final num duration;
  final ApplicationMeta? appuse;
  final bool isFree;
}

class EditBooking extends BookingEvent{
  const EditBooking({
    required this.duration,
    required this.bookingId,
    required this.selectedDate,
  });
  final String bookingId;
  final String selectedDate;
  final int duration;
}