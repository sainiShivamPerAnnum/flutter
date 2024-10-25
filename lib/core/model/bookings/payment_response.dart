import 'package:felloapp/core/model/bookings/new_booking.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment_response.g.dart';

const _deserializable = JsonSerializable(
  createToJson: false,
);
@_deserializable
class PricingResponse {
  final num price;
  final num gst;
  final num totalPrice;

  const PricingResponse({
    required this.price,
    required this.gst,
    required this.totalPrice,
  });

  factory PricingResponse.fromJson(Map<String, dynamic> json) =>
      _$PricingResponseFromJson(json);
}

@_deserializable
class PaymentStatusResponse {
  final String message;
  final bool success;
  final BookingTransactionData data;

  const PaymentStatusResponse({
    required this.message,
    required this.success,
    required this.data,
  });

  factory PaymentStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentStatusResponseFromJson(json);
}

@_deserializable
class BookingTransactionData {
  final String id;
  final String advisorId;
  final TimeSlot slotTime;
  final String userId;
  final String? intent;
  final String createdAt;
  final String status;
  final String paymentId;

  const BookingTransactionData({
    required this.id,
    required this.advisorId,
    required this.slotTime,
    required this.status,
    required this.userId,
    required this.createdAt,
    required this.paymentId,
    this.intent,
  });

  factory BookingTransactionData.fromJson(Map<String, dynamic> json) =>
      _$BookingTransactionDataFromJson(json);
}
