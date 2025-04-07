import 'package:json_annotation/json_annotation.dart';

part 'my_fds.g.dart';

const _deserializable = JsonSerializable(
  createToJson: false,
);

@_deserializable
class UserFdPortfolio {
  final List<PortfolioModel> portfolio;
  final List<dynamic> otherStatuses;
  final SummaryModel summary;

  UserFdPortfolio({
    required this.portfolio,
    required this.otherStatuses,
    required this.summary,
  });

  factory UserFdPortfolio.fromJson(Map<String, dynamic> json) =>
      _$UserFdPortfolioFromJson(json);
}

@_deserializable
class PortfolioModel {
  final String? issuerId;
  final String? issuer;
  final double? roi;
  final double? investedAmount;
  final double? currentAmount;
  final String? tenure;
  final List<IndividualFDModel>? individualFDs;

  PortfolioModel({
    this.issuerId,
    this.issuer,
    this.roi,
    this.investedAmount,
    this.currentAmount,
    this.tenure,
    this.individualFDs,
  });

  factory PortfolioModel.fromJson(Map<String, dynamic> json) =>
      _$PortfolioModelFromJson(json);
}

@_deserializable
class IndividualFDModel {
  final String? applicationId;
  final double? depositAmount;
  final String? tenure;
  final double? roi;
  final DateTime? maturityDate;
  final DateTime? depositDate;
  final String? interestPayoutFrequency;
  final String? status;
  final List<BankDetails>? bankDetails;

  IndividualFDModel({
    this.depositAmount,
    this.roi,
    this.maturityDate,
    this.depositDate,
    this.interestPayoutFrequency,
    this.status,
    this.bankDetails,
    this.applicationId,
    this.tenure,
  });

  factory IndividualFDModel.fromJson(Map<String, dynamic> json) =>
      _$IndividualFDModelFromJson(json);
}

@_deserializable
class BankDetails {
  final String? bankName;
  final String? accountNumber;

  BankDetails({
    this.bankName,
    this.accountNumber,
  });

  factory BankDetails.fromJson(Map<String, dynamic> json) =>
      _$BankDetailsFromJson(json);
}

@_deserializable
class SummaryModel {
  final double? totalInvestedAmount;
  final double? totalCurrentAmount;
  final double? totalReturns;
  final double? averageXIRR;

  SummaryModel({
    this.totalInvestedAmount,
    this.totalCurrentAmount,
    this.totalReturns,
    this.averageXIRR,
  });

  factory SummaryModel.fromJson(Map<String, dynamic> json) =>
      _$SummaryModelFromJson(json);
}

@_deserializable
class InvestmentModel {
  final String? current;
  final String? invested;
  final String? netReturns;
  final String? avgXIRR;
  final String? status;

  InvestmentModel({
    this.current,
    this.invested,
    this.netReturns,
    this.avgXIRR,
    this.status,
  });

  factory InvestmentModel.fromJson(Map<String, dynamic> json) =>
      _$InvestmentModelFromJson(json);
}

@_deserializable
class FixedDeposit {
  final String? name;
  final String? current;
  final String? invested;
  final String? avgXIRR;
  final String? tenure;

  FixedDeposit({
    this.name,
    this.current,
    this.invested,
    this.avgXIRR,
    this.tenure,
  });

  factory FixedDeposit.fromJson(Map<String, dynamic> json) =>
      _$FixedDepositFromJson(json);
}
