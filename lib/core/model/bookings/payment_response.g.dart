// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentStatusResponse _$PaymentStatusResponseFromJson(
        Map<String, dynamic> json) =>
    PaymentStatusResponse(
      message: json['message'] as String,
      success: json['success'] as bool,
      data:
          BookingTransactionData.fromJson(json['data'] as Map<String, dynamic>),
    );

BookingTransactionData _$BookingTransactionDataFromJson(
        Map<String, dynamic> json) =>
    BookingTransactionData(
      id: json['id'] as String,
      advisorId: json['advisorId'] as String,
      slotTime: TimeSlot.fromJson(json['slotTime'] as Map<String, dynamic>),
      status: json['status'] as String,
      userId: json['userId'] as String,
      intent: json['intent'] as String,
      createdAt: json['createdAt'] as String,
      paymentId: json['paymentId'] as String,
    );
