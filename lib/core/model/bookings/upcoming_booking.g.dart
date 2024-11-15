// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upcoming_booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpcomingBooking _$UpcomingBookingFromJson(Map<String, dynamic> json) =>
    UpcomingBooking(
      bookings: (json['bookings'] as List<dynamic>)
          .map((e) => Booking.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Booking _$BookingFromJson(Map<String, dynamic> json) => Booking(
      bookingId: json['bookingId'] as String,
      advisorName: json['advisorName'] as String,
      image: json['image'] as String,
      scheduledOn: DateTime.parse(json['scheduledOn'] as String),
      duration: json['duration'] as String,
      advisorId: json['advisorId'] as String,
      guestCode: json['guestCode'] as String,
      recordingLink: json['recordingLink'] as String?,
      eventId: json['eventId'] as String?,
    );
