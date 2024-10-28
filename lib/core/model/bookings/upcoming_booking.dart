import 'package:json_annotation/json_annotation.dart';

part 'upcoming_booking.g.dart';

const _deserializable = JsonSerializable(
  createToJson: false,
);

@_deserializable
class UpcomingBooking {
  final List<Booking> bookings;

  UpcomingBooking({
    required this.bookings,
  });
  factory UpcomingBooking.fromJson(Map<String, dynamic> json) =>
      _$UpcomingBookingFromJson(json);
}

@_deserializable
class Booking {
  // final String 
  final String advisorName;
  final String image;
  final DateTime scheduledOn;
  final String duration;
  final String? recordingLink;
  final String advisorId;
  final String guestCode;

  Booking({
    required this.advisorName,
    required this.image,
    required this.scheduledOn,
    required this.duration,
    this.recordingLink,
    required this.advisorId,
    required this.guestCode,
  });

  factory Booking.fromJson(Map<String, dynamic> json) =>
      _$BookingFromJson(json);
}
