import 'package:json_annotation/json_annotation.dart';

part 'payment_polling.g.dart';

const _deserializable = JsonSerializable(
  createToJson: false,
);

@_deserializable
class PollingStatusResponse {
  final String message;
  final bool success;
  final BookingPollingData data;

  const PollingStatusResponse({
    required this.message,
    required this.success,
    required this.data,
  });

  factory PollingStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$PollingStatusResponseFromJson(json);
}

@_deserializable
class BookingPollingData {
  final PaymentDetails? paymentDetails;
  final String? sId;
  final String? userId;
  final String? advisorId;
  final String? bookingId;
  final String? createdAt;
  final String? updatedAt;

  const BookingPollingData({
    this.paymentDetails,
    this.sId,
    this.userId,
    this.advisorId,
    this.bookingId,
    this.createdAt,
    this.updatedAt,
  });

  factory BookingPollingData.fromJson(Map<String, dynamic> json) =>
      _$BookingPollingDataFromJson(json);
}

@_deserializable
class PaymentDetails {
  final num amount;
  final String? type;
  @JsonKey(unknownEnumValue: BookingPaymentStatus.pending)
  final BookingPaymentStatus? status;
  final String? appUse;
  final String? method;
  final String? note;
  final String? paymentId;
  final Misc? misc;

  const PaymentDetails({
    required this.amount,
    this.status = BookingPaymentStatus.pending,
    this.type,
    this.appUse,
    this.method,
    this.note,
    this.paymentId,
    this.misc,
  });

  factory PaymentDetails.fromJson(Map<String, dynamic> json) =>
      _$PaymentDetailsFromJson(json);
}

@_deserializable
class Misc {
  final String? type;
  final String? upiTransactionId;
  final String? utr;

  const Misc(this.type, this.upiTransactionId, this.utr);

  factory Misc.fromJson(Map<String, dynamic> json) => _$MiscFromJson(json);
}

enum BookingPaymentStatus {
  pending,
  complete,
  failed,
  cancelled,
}
