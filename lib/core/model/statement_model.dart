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
  final String userId;
  final double initiatedAmount;
  final String initiatedStatus;
  final String initiatedDate;
  final double paidAmount;
  final String bankStatus;
  final String paymentDate;
  final String utrNo;
  final String createdAt;
  final String updatedAt;

  const Transaction({
    required this.userId,
    required this.initiatedAmount,
    required this.initiatedStatus,
    required this.initiatedDate,
    required this.paidAmount,
    required this.bankStatus,
    required this.paymentDate,
    required this.utrNo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      userId: json['investment'] ?? '',
      initiatedAmount: (json['initiatedAmount'] ?? 0).toDouble(),
      initiatedStatus: json['initiatedStatus'] ?? '',
      initiatedDate: json['txnId'] ?? '',
      paidAmount: (json['paidAmount'] ?? 0).toDouble(),
      paymentDate: json['paymentDate'] ?? '',
      bankStatus: json['bankStatus'] ?? '',
      utrNo: json['utrNo'] ?? 'null',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'initiatedAmount': initiatedAmount,
      'initiatedStatus': initiatedStatus,
      'initiatedDate': initiatedDate,
      'paidAmount': paidAmount,
      'paymentDate': paymentDate,
      'bankStatus': bankStatus,
      'utrNo': utrNo,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
