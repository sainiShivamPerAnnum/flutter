import 'dart:io';

import 'package:felloapp/core/model/invoice_model.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/pdf_invoice_api.dart';
import 'package:felloapp/util/augmont_api_util.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class AugmontInvoiceService {
  Log log = const Log('AugmontInvoiceService');
  final UserService _userService = locator<UserService>();

  AugmontInvoiceService();

  Future<String?> generateInvoice(Map<String, dynamic> invoiceMap,
      Map<String, String?>? userDetails) async {
    if (invoiceMap[GetInvoice.resTransactionId] == null) {
      return null;
    }
    try {
      final pdfFile = await PdfInvoiceApi.generate(
          await _generateInvoiceContent(invoiceMap, userDetails));
      return pdfFile.path;
    } catch (e) {
      log.error('$e');
      return null;
    }
  }

  Future<Invoice> _generateInvoiceContent(
      Map<String, dynamic> data, Map<String, String?>? userDetails) async {
    final bgImage = await _getImageFileFromAssets("invoice_bg.png");
    final brokerLogo = await _getImageFileFromAssets("fello_logo.png");
    final sellerLogo = await _getImageFileFromAssets("aug-logo.png");
    final invoice = Invoice(
        bgImage: bgImage,
        brokerLogo: brokerLogo,
        sellerLogo: sellerLogo,
        supplier: const Supplier(
          name: 'Augmont GoldTech Pvt Ltd.',
          GSTIN: "GSTIN: 27AATCA3030A1Z3",
        ),
        customer: Customer(
          name: userDetails != null
              ? userDetails["name"]
              : (_userService.baseUser!.kycName != null &&
                          _userService.baseUser!.kycName!.isNotEmpty
                      ? _userService.baseUser!.kycName
                      : _userService.baseUser!.name) ??
                  "N/A",
          address: userDetails != null
              ? userDetails["email"]
              : _userService.baseUser!.email ?? "N/A",
        ),
        info: InvoiceInfo(
          date: data[GetInvoice.resDate] != null
              ? DateFormat("dd MMM, yyyy").format(
                  DateFormat("dd-MM-yyyy").parse(data[GetInvoice.resDate]))
              : 'N/A',
          number: data[GetInvoice.resInvoiceNumber] ?? 'N/A',
        ),
        description: Description(
            metal: "GOLD",
            hsn: data[GetInvoice.resHsnCode] ?? 'N/A',
            trnId: data[GetInvoice.resTransactionId] ?? 'N/A'),
        items: [
          InvoiceItem(
            description: 'Gold 24K 99.9%',
            grams: data[GetInvoice.resQuantity] ?? 'N/A',
            rate: data[GetInvoice.resRate] ?? 'N/A',
            amount: data[GetInvoice.resSubtotal] ?? 'N/A',
          ),
          InvoiceItem(
            description: 'Net Total',
            rate: "",
            grams: "",
            amount: data[GetInvoice.resSubtotal] ?? 'N/A',
          ),
          InvoiceItem(
            description: 'CGST',
            grams: "",
            rate: data['taxes']['taxSplit'][0]['taxPerc'] ?? 'N/A',
            amount: data['taxes']['taxSplit'][0]['taxAmount'] ?? 'N/A',
          ),
          InvoiceItem(
            description: 'SGST',
            grams: "",
            rate: data['taxes']['taxSplit'][1]['taxPerc'] ?? 'N/A',
            amount: data['taxes']['taxSplit'][1]['taxAmount'] ?? 'N/A',
          ),
          InvoiceItem(
            description: 'IEST',
            grams: "",
            rate: data['taxes']['taxSplit'][2]['taxPerc'] ?? 'N/A',
            amount: data['taxes']['taxSplit'][2]['taxAmount'] ?? 'N/A',
          ),
        ],
        total: data[GetInvoice.resAmount] ?? 'N/A');
    return invoice;
  }

  Future<File> _getImageFileFromAssets(String path) async {
    print(path);
    final byteData = await rootBundle.load('images/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }
}
