part of 'booking_bloc.dart';

sealed class BookingEvent {
  const BookingEvent();
}

class LoadBookingDates extends BookingEvent {
  const LoadBookingDates(this.advisorId);
  final String advisorId;
}

class SelectDate extends BookingEvent {
  final String selectedDate;
  const SelectDate(this.selectedDate);
}

class SelectTime extends BookingEvent {
  final String selectedTime;
  const SelectTime(this.selectedTime);
}

class GetPricing extends BookingEvent {
  final String selectedDate;
  final String selectedTime;
  final String advisorId;

  const GetPricing(this.selectedDate, this.selectedTime,this.advisorId);
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
  });
  final String advisorId;
  final num amount;
  final String fromTime;
  final num duration;
  final ApplicationMeta appuse;
}