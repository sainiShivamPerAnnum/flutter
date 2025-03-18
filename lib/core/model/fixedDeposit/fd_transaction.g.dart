// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fd_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FDTransactionData _$FDTransactionDataFromJson(Map<String, dynamic> json) =>
    FDTransactionData(
      jid: json['jid'] as String,
      status: json['status'] as String,
      issuerId: json['issuerId'] as String,
      applicationId: json['applicationId'] as String,
      depositAmount: (json['depositAmount'] as num).toDouble(),
      roi: (json['roi'] as num).toDouble(),
      maturityDate: json['maturityDate'] as String,
      depositDate: json['depositDate'] as String,
      bankDetails: (json['bankDetails'] as List<dynamic>)
          .map((e) => BankDetails.fromJson(e as Map<String, dynamic>))
          .toList(),
      tenure: json['tenure'] as String?,
    );

Map<String, dynamic> _$FDTransactionDataToJson(FDTransactionData instance) =>
    <String, dynamic>{
      'jid': instance.jid,
      'status': instance.status,
      'issuerId': instance.issuerId,
      'applicationId': instance.applicationId,
      'depositAmount': instance.depositAmount,
      'tenure': instance.tenure,
      'roi': instance.roi,
      'maturityDate': instance.maturityDate,
      'depositDate': instance.depositDate,
      'bankDetails': instance.bankDetails,
    };

BankDetails _$BankDetailsFromJson(Map<String, dynamic> json) => BankDetails(
      bankName: json['bankName'] as String,
      accountNumber: json['accountNumber'] as String,
    );

Map<String, dynamic> _$BankDetailsToJson(BankDetails instance) =>
    <String, dynamic>{
      'bankName': instance.bankName,
      'accountNumber': instance.accountNumber,
    };
