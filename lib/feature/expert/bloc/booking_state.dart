part of 'booking_bloc.dart';

sealed class BookingState extends Equatable {
  const BookingState();
}

class LoadingBookingsData extends BookingState {
  const LoadingBookingsData();

  @override
  List<Object?> get props => const [];
}

class BookingError extends BookingState {
  const BookingError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

final class BookingsLoaded extends BookingState {
  final String advisorId;
  final Schedule? schedule;
  final String? selectedDate;
  final int selectedDuration;
  final String? selectedTime;
  final bool isFree;

  const BookingsLoaded({
    required this.advisorId,
    required this.schedule,
    required this.isFree,
    this.selectedDate,
    this.selectedTime,
    this.selectedDuration = 30,
  });

  BookingState copyWith({
    String? advisorId,
    Schedule? schedule,
    String? selectedDate,
    String? selectedTime,
    int? selectedDuration,
    bool? isFree,
  }) {
    return BookingsLoaded(
      advisorId: advisorId ?? this.advisorId,
      schedule: schedule ?? this.schedule,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      selectedDuration: selectedDuration ?? this.selectedDuration,
      isFree: isFree ?? this.isFree,
    );
  }

  @override
  List<Object?> get props => [
        advisorId,
        schedule,
        selectedDate,
        selectedTime,
        selectedDuration,
        isFree,
      ];
}

class PricingData extends BookingState {
  final String advisorId;
  final String advisorName;
  final String time;
  final String date;
  final num price;
  final num duration;
  final num gst;
  final num totalPayable;
  final bool reedem;
  final num coinBalanceUse;
  final bool isApplyingReedem;

  const PricingData({
    required this.advisorId,
    required this.advisorName,
    required this.time,
    required this.date,
    required this.price,
    required this.duration,
    required this.gst,
    required this.totalPayable,
    required this.coinBalanceUse,
    this.reedem = false,
    this.isApplyingReedem = false,
  });
  PricingData copyWith({
    String? advisorId,
    String? advisorName,
    String? time,
    String? date,
    num? price,
    num? duration,
    num? gst,
    num? totalPayable,
    bool? reedem,
    bool? isApplyingReedem,
    num? coinBalanceUse,
  }) {
    return PricingData(
      advisorId: advisorId ?? this.advisorId,
      advisorName: advisorName ?? this.advisorName,
      time: time ?? this.time,
      date: date ?? this.date,
      price: price ?? this.price,
      duration: duration ?? this.duration,
      gst: gst ?? this.gst,
      totalPayable: totalPayable ?? this.totalPayable,
      reedem: reedem ?? this.reedem,
      isApplyingReedem: isApplyingReedem ?? this.isApplyingReedem,
      coinBalanceUse: coinBalanceUse ?? this.coinBalanceUse,
    );
  }

  @override
  List<Object?> get props => [
        advisorId,
        advisorName,
        time,
        date,
        price,
        duration,
        gst,
        totalPayable,
        reedem,
        isApplyingReedem,
        coinBalanceUse,
      ];
}

sealed class PaymentState extends Equatable {
  const PaymentState();
}

class MandateInitialState extends PaymentState {
  const MandateInitialState();

  @override
  List<Object?> get props => const [];
}

class ListingPSPApps extends PaymentState {
  const ListingPSPApps();

  @override
  List<Object?> get props => const [];
}

class ListedPSPApps extends PaymentState {
  final List<ApplicationMeta> pspApps;

  const ListedPSPApps(
    this.pspApps,
  );

  ListedPSPApps copyWith() {
    return ListedPSPApps(
      pspApps,
    );
  }

  @override
  List<Object?> get props => [
        pspApps,
      ];
}

class SubmittingPayment extends PaymentState {
  const SubmittingPayment();

  @override
  List<Object?> get props => const [];
}

class SubmittingPaymentFailed extends PaymentState {
  const SubmittingPaymentFailed(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class SubmittedPayment extends PaymentState {
  final PaymentStatusResponse data;
  const SubmittedPayment({
    required this.data,
  });

  @override
  List<Object?> get props => [
        data,
      ];
}
