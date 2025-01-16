// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_polling.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PollingStatusResponse _$PollingStatusResponseFromJson(
        Map<String, dynamic> json) =>
    PollingStatusResponse(
      message: json['message'] as String,
      success: json['success'] as bool,
      data: BookingPollingData.fromJson(json['data'] as Map<String, dynamic>),
    );

BookingPollingData _$BookingPollingDataFromJson(Map<String, dynamic> json) =>
    BookingPollingData(
      paymentDetails: json['paymentDetails'] == null
          ? null
          : PaymentDetails.fromJson(
              json['paymentDetails'] as Map<String, dynamic>),
      sId: json['sId'] as String?,
      userId: json['userId'] as String?,
      advisorId: json['advisorId'] as String?,
      bookingId: json['bookingId'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

PaymentDetails _$PaymentDetailsFromJson(Map<String, dynamic> json) =>
    PaymentDetails(
      amount: json['amount'] as num,
      status: $enumDecodeNullable(_$BookingPaymentStatusEnumMap, json['status'],
              unknownValue: BookingPaymentStatus.pending) ??
          BookingPaymentStatus.pending,
      type: json['type'] as String?,
      appUse: json['appUse'] as String?,
      method: json['method'] as String?,
      note: json['note'] as String?,
      paymentId: json['paymentId'] as String?,
      misc: json['misc'] == null
          ? null
          : Misc.fromJson(json['misc'] as Map<String, dynamic>),
    );

const _$BookingPaymentStatusEnumMap = {
  BookingPaymentStatus.pending: 'pending',
  BookingPaymentStatus.complete: 'complete',
  BookingPaymentStatus.failed: 'failed',
  BookingPaymentStatus.cancelled: 'cancelled',
};

Misc _$MiscFromJson(Map<String, dynamic> json) => Misc(
      json['type'] as String?,
      json['upiTransactionId'] as String?,
      json['utr'] as String?,
    );
