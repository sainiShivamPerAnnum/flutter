import 'dart:io';

class Statement {
  final StatementInfo info;
  final List<Transaction> transactions;
  final File? bgImage;
  final File? companyLogo;
  final File? brokerLogo;

  const Statement({
    required this.info,
    required this.transactions,
    this.bgImage,
    this.companyLogo,
    this.brokerLogo,
  });
}

class StatementInfo {
  final String accountNumber;
  final String fromDate;
  final String toDate;
  final String generatedDate;

  const StatementInfo({
    required this.accountNumber,
    required this.fromDate,
    required this.toDate,
    required this.generatedDate,
  });
}

class Transaction {
  final String investment;
  final String dated;
  final String description;
  final String txnId;
  final double amount;
  final double principal;
  final double interest;
  final String txnType;
  final String? partnerRefId;
  final String utr;

  const Transaction({
    required this.investment,
    required this.dated,
    required this.description,
    required this.txnId,
    required this.amount,
    required this.principal,
    required this.interest,
    required this.txnType,
    this.partnerRefId,
    this.utr = 'null',
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      investment: json['investment'] ?? '',
      dated: json['dated'] ?? '',
      description: json['description'] ?? '',
      txnId: json['txnId'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      principal: (json['principal'] ?? 0).toDouble(),
      interest: (json['interest'] ?? 0).toDouble(),
      txnType: json['txnType'] ?? '',
      partnerRefId: json['partnerRefId'],
      utr: json['utr'] ?? 'null',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'investment': investment,
      'dated': dated,
      'description': description,
      'txnId': txnId,
      'amount': amount,
      'principal': principal,
      'interest': interest,
      'txnType': txnType,
      'partnerRefId': partnerRefId,
      'utr': utr,
    };
  }
}
