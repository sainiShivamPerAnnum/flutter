// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_fds.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserFdPortfolio _$UserFdPortfolioFromJson(Map<String, dynamic> json) =>
    UserFdPortfolio(
      portfolio: (json['portfolio'] as List<dynamic>)
          .map((e) => PortfolioModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      otherStatuses: json['otherStatuses'] as List<dynamic>,
      summary: SummaryModel.fromJson(json['summary'] as Map<String, dynamic>),
    );

PortfolioModel _$PortfolioModelFromJson(Map<String, dynamic> json) =>
    PortfolioModel(
      issuerId: json['issuerId'] as String?,
      issuer: json['issuer'] as String?,
      roi: (json['roi'] as num?)?.toDouble(),
      investedAmount: (json['investedAmount'] as num?)?.toDouble(),
      currentAmount: (json['currentAmount'] as num?)?.toDouble(),
      tenure: json['tenure'] as String?,
      individualFDs: (json['individualFDs'] as List<dynamic>?)
          ?.map((e) => IndividualFDModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

IndividualFDModel _$IndividualFDModelFromJson(Map<String, dynamic> json) =>
    IndividualFDModel(
      depositAmount: (json['depositAmount'] as num?)?.toDouble(),
      roi: (json['roi'] as num?)?.toDouble(),
      maturityDate: json['maturityDate'] == null
          ? null
          : DateTime.parse(json['maturityDate'] as String),
      depositDate: json['depositDate'] == null
          ? null
          : DateTime.parse(json['depositDate'] as String),
      interestPayoutFrequency: json['interestPayoutFrequency'] as String?,
      status: json['status'] as String?,
      bankDetails: (json['bankDetails'] as List<dynamic>?)
          ?.map((e) => BankDetails.fromJson(e as Map<String, dynamic>))
          .toList(),
      applicationId: json['applicationId'] as String?,
      tenure: json['tenure'] as String?,
    );

BankDetails _$BankDetailsFromJson(Map<String, dynamic> json) => BankDetails(
      bankName: json['bankName'] as String?,
      accountNumber: json['accountNumber'] as String?,
    );

SummaryModel _$SummaryModelFromJson(Map<String, dynamic> json) => SummaryModel(
      totalInvestedAmount: (json['totalInvestedAmount'] as num?)?.toDouble(),
      totalCurrentAmount: (json['totalCurrentAmount'] as num?)?.toDouble(),
      totalReturns: (json['totalReturns'] as num?)?.toDouble(),
      averageXIRR: (json['averageXIRR'] as num?)?.toDouble(),
    );

InvestmentModel _$InvestmentModelFromJson(Map<String, dynamic> json) =>
    InvestmentModel(
      current: json['current'] as String?,
      invested: json['invested'] as String?,
      netReturns: json['netReturns'] as String?,
      avgXIRR: json['avgXIRR'] as String?,
      status: json['status'] as String?,
    );

FixedDeposit _$FixedDepositFromJson(Map<String, dynamic> json) => FixedDeposit(
      name: json['name'] as String?,
      current: json['current'] as String?,
      invested: json['invested'] as String?,
      avgXIRR: json['avgXIRR'] as String?,
      tenure: json['tenure'] as String?,
    );
