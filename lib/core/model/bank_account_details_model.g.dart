// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_account_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BankAccountDetailsModel _$BankAccountDetailsModelFromJson(
        Map<String, dynamic> json) =>
    BankAccountDetailsModel(
      id: json['id'] as String? ?? '',
      account: json['account'] as String? ?? '',
      ifsc: json['ifsc'] as String? ?? '',
      name: json['name'] as String? ?? '',
      bankName: json['bankName'] as String? ?? '',
      logo: json['logo'] as String? ??
          'https://img.phonepe.com/images/banks/40/40/DEFAULT.png',
      netBankingStatus: $enumDecodeNullable(
              _$NetBankingStatusEnumMap, json['netBankingStatus']) ??
          NetBankingStatus.UN_SUPPORTED,
      availability: $enumDecodeNullable(
              _$BankAvailabilityEnumMap, json['availability']) ??
          BankAvailability.UNAVAILABLE,
      message: json['message'] as String?,
    );

const _$NetBankingStatusEnumMap = {
  NetBankingStatus.SUPPORTED: 'SUPPORTED',
  NetBankingStatus.UN_SUPPORTED: 'UN_SUPPORTED',
};

const _$BankAvailabilityEnumMap = {
  BankAvailability.AVAILABLE: 'AVAILABLE',
  BankAvailability.UNAVAILABLE: 'UNAVAILABLE',
  BankAvailability.DEGRADED: 'DEGRADED',
};
