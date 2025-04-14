// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fd_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FDTransactionData _$FDTransactionDataFromJson(Map<String, dynamic> json) =>
    FDTransactionData(
      jid: json['jid'] as String?,
      status: json['status'] as String?,
      issuerId: json['issuerId'] as String?,
      applicationId: json['applicationId'] as String?,
      depositAmount: json['depositAmount'] as num?,
      roi: json['roi'] as num?,
      maturityDate: json['maturityDate'] as String?,
      depositDate: json['depositDate'] as String?,
      bankDetails: (json['bankDetails'] as List<dynamic>?)
          ?.map((e) => BankDetails.fromJson(e as Map<String, dynamic>))
          .toList(),
      maturityAmount: json['maturityAmount'] as num?,
      tenure: json['tenure'] as String?,
    );
