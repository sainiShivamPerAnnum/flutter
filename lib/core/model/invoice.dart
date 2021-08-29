import 'dart:io';
import 'package:flutter/cupertino.dart';

class Invoice {
  final InvoiceInfo info;
  final Supplier supplier;
  final Customer customer;
  final List<InvoiceItem> items;
  final File bgImage;
  final File sellerLogo;
  final File brokerLogo;

  const Invoice(
      {@required this.info,
      @required this.supplier,
      @required this.customer,
      @required this.items,
      @required this.bgImage,
      @required this.brokerLogo,
      @required this.sellerLogo});
}

class InvoiceInfo {
  final String description;
  final String number;
  final DateTime date;
  final DateTime dueDate;

  const InvoiceInfo({
    @required this.description,
    @required this.number,
    @required this.date,
    @required this.dueDate,
  });
}

class InvoiceItem {
  final String description;
  final double grams;
  final String rate;
  final double amount;

  const InvoiceItem({
    @required this.description,
    @required this.grams,
    @required this.rate,
    @required this.amount,
  });
}

class Customer {
  final String name;
  final String address;

  const Customer({
    @required this.name,
    @required this.address,
  });
}

class Supplier {
  final String name;
  final String GSTIN;

  const Supplier({
    @required this.name,
    @required this.GSTIN,
  });
}
