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
  final String issuerId;
  final String issuer;
  final double roi;
  final double investedAmount;
  final double currentAmount;
  final int? tenure;
  final List<IndividualFDModel> individualFDs;

  PortfolioModel({
    required this.issuerId,
    required this.issuer,
    required this.roi,
    required this.investedAmount,
    required this.currentAmount,
    this.tenure,
    required this.individualFDs,
  });

  factory PortfolioModel.fromJson(Map<String, dynamic> json) =>
      _$PortfolioModelFromJson(json);
}

@_deserializable
class IndividualFDModel {
  final String applicationId;
  final double depositAmount;
  final int? tenure;
  final double roi;
  final DateTime maturityDate;
  final DateTime depositDate;
  final String interestPayoutFrequency;
  final String status;
  final List<BankDetails> bankDetails;

  IndividualFDModel({
    required this.applicationId,
    required this.depositAmount,
    this.tenure,
    required this.roi,
    required this.maturityDate,
    required this.depositDate,
    required this.interestPayoutFrequency,
    required this.status,
    required this.bankDetails,
  });

  factory IndividualFDModel.fromJson(Map<String, dynamic> json) =>
      _$IndividualFDModelFromJson(json);
}

@_deserializable
class BankDetails {
  final String bankName;
  final String accountNumber;

  BankDetails({
    required this.bankName,
    required this.accountNumber,
  });

  factory BankDetails.fromJson(Map<String, dynamic> json) =>
      _$BankDetailsFromJson(json);
}

@_deserializable
class SummaryModel {
  final double totalInvestedAmount;
  final double totalCurrentAmount;
  final double totalReturns;
  final double averageXIRR;

  SummaryModel({
    required this.totalInvestedAmount,
    required this.totalCurrentAmount,
    required this.totalReturns,
    required this.averageXIRR,
  });

  factory SummaryModel.fromJson(Map<String, dynamic> json) =>
      _$SummaryModelFromJson(json);
}

@_deserializable
class InvestmentModel {
  final String current;
  final String invested;
  final String netReturns;
  final String avgXIRR;
  final String status;

  InvestmentModel({
    required this.current,
    required this.invested,
    required this.netReturns,
    required this.avgXIRR,
    required this.status,
  });

  factory InvestmentModel.fromJson(Map<String, dynamic> json) =>
      _$InvestmentModelFromJson(json);
}

@_deserializable
class FixedDeposit {
  final String name;
  final String current;
  final String invested;
  final String avgXIRR;
  final String tenure;

  FixedDeposit({
    required this.name,
    required this.current,
    required this.invested,
    required this.avgXIRR,
    required this.tenure,
  });

  factory FixedDeposit.fromJson(Map<String, dynamic> json) =>
      _$FixedDepositFromJson(json);
}
