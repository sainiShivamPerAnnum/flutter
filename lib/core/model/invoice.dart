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
  final Description description;
  final String total;

  const Invoice(
      {@required this.info,
      @required this.supplier,
      @required this.customer,
      @required this.items,
      @required this.bgImage,
      @required this.brokerLogo,
      @required this.description,
      @required this.sellerLogo,
      @required this.total});
}

class InvoiceInfo {
  final String number;
  final String date;

  const InvoiceInfo({
    @required this.number,
    @required this.date,
  });
}

class InvoiceItem {
  final String description;
  final String grams;
  final String rate;
  final String amount;

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

class Description {
  final String metal;
  final String trnId;
  final String hsn;

  const Description({
    @required this.metal,
    @required this.hsn,
    @required this.trnId,
  });
}
