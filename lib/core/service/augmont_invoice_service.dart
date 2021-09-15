import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/invoice.dart';
import 'package:felloapp/core/service/pdf_invoice_api.dart';
import 'package:felloapp/util/augmont_api_util.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class AugmontInvoiceService {
  Log log = new Log('AugmontInvoiceService');
  BaseUtil _baseUtil = locator<BaseUtil>();

  AugmontInvoiceService();

  // Future<String> generateInvoice(Map<String, dynamic> invoiceMap) async {
  //   if (invoiceMap == null || invoiceMap[GetInvoice.resTransactionId] == null) {
  //     return null;
  //   }
  //   try {
  //     Directory appDocDir = await getTemporaryDirectory();

  //     final String targetPath = appDocDir.path;
  //     // final String targetFileName = invoiceMap[GetInvoice.resTransactionId];
  //     final String targetFileName =
  //         'fello-invoice-' + invoiceMap[GetInvoice.resInvoiceNumber];
  //     final String htmlContent = await _generatePdfData(invoiceMap);
  //     final generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
  //         htmlContent, targetPath, targetFileName);
  //     String generatedPdfFilePath = generatedPdfFile.path;

  //     log.debug(generatedPdfFilePath);
  //     return generatedPdfFilePath;
  //   } catch (e) {
  //     log.error('$e');
  //     return null;
  //   }
  // }

  Future<String> generateInvoice(Map<String, dynamic> invoiceMap) async {
    if (invoiceMap == null || invoiceMap[GetInvoice.resTransactionId] == null) {
      return null;
    }
    try {
      // Directory appDocDir = await getTemporaryDirectory();

      // final String targetPath = appDocDir.path;
      // // final String targetFileName = invoiceMap[GetInvoice.resTransactionId];
      // final String targetFileName =
      //     'fello-invoice-' + invoiceMap[GetInvoice.resInvoiceNumber];
      // final String content = await _generatePdfData(invoiceMap);
      final pdfFile = await PdfInvoiceApi.generate(
          await _generateInvoiceContent(invoiceMap));
      return pdfFile.path;
      // final generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
      //     htmlContent, targetPath, targetFileName);
      // String generatedPdfFilePath = generatedPdfFile.path;

      // log.debug(generatedPdfFilePath);
      // return generatedPdfFilePath;

    } catch (e) {
      log.error('$e');
      return null;
    }
  }

  Future<Invoice> _generateInvoiceContent(Map<String, dynamic> data) async {
    final bgImage = await _getImageFileFromAssets("invoice_bg.png");
    final brokerLogo = await _getImageFileFromAssets("fello_logo.png");
    final sellerLogo = await _getImageFileFromAssets("aug-logo.png");
    final invoice = Invoice(
        bgImage: bgImage,
        brokerLogo: brokerLogo,
        sellerLogo: sellerLogo,
        supplier: Supplier(
          name: 'Augmont GoldTech Pvt Ltd.',
          GSTIN: "GSTIN: 27AATCA3030A1Z3",
        ),
        customer: Customer(
          name: _baseUtil.myUser.name ?? "N/A",
          address: _baseUtil.myUser.email ?? "N/A",
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

  // Future<String> _generatePdfData(Map<String, dynamic> data) async {
  //   try {
  //     String _content = await rootBundle
  //         .loadString('resources/augmont/fello-augmont-invoice.html');

  //     log.debug('\$__' + 'xyz' + '__\$');
  //     // RegExp exp = _makeKey('ghi');
  //     // log.debug(exp.pattern);

  //     _content = _content.replaceAll(_makeKey(GetInvoice.PDF_KEY_TRANID),
  //         data[GetInvoice.resTransactionId] ?? 'N/A');
  //     _content = _content.replaceAll(_makeKey(GetInvoice.PDF_KEY_INVOICENUMBER),
  //         data[GetInvoice.resInvoiceNumber] ?? 'N/A');
  //     _content = _content.replaceAll(_makeKey(GetInvoice.PDF_KEY_INVOICEDATE),
  //         data[GetInvoice.resDate] ?? 'N/A');
  //     _content = _content.replaceAll(_makeKey(GetInvoice.PDF_KEY_QUANTITY),
  //         data[GetInvoice.resQuantity] ?? 'N/A');
  //     _content = _content.replaceAll(
  //         _makeKey(GetInvoice.PDF_KEY_RATE), data[GetInvoice.resRate] ?? 'N/A');
  //     _content = _content.replaceAll(_makeKey(GetInvoice.PDF_KEY_HSN),
  //         data[GetInvoice.resHsnCode] ?? 'N/A');
  //     //tax keys
  //     _content = _content.replaceAll(_makeKey(GetInvoice.PDF_KEY_CGST),
  //         data['taxes']['taxSplit'][0]['taxPerc'] ?? 'N/A');
  //     _content = _content.replaceAll(_makeKey(GetInvoice.PDF_KEY_SGST),
  //         data['taxes']['taxSplit'][1]['taxPerc'] ?? 'N/A');
  //     _content = _content.replaceAll(_makeKey(GetInvoice.PDF_KEY_IGST),
  //         data['taxes']['taxSplit'][2]['taxPerc'] ?? 'N/A');
  //     //tax value
  //     _content = _content.replaceAll(_makeKey(GetInvoice.PDF_KEY_CGST_AMOUNT),
  //         data['taxes']['taxSplit'][0]['taxAmount'] ?? 'N/A');
  //     _content = _content.replaceAll(_makeKey(GetInvoice.PDF_KEY_SGST_AMOUNT),
  //         data['taxes']['taxSplit'][1]['taxAmount'] ?? 'N/A');
  //     _content = _content.replaceAll(_makeKey(GetInvoice.PDF_KEY_IGST_AMOUNT),
  //         data['taxes']['taxSplit'][2]['taxAmount'] ?? 'N/A');
  //     //
  //     _content = _content.replaceAll(_makeKey(GetInvoice.PDF_KEY_AMOUNT),
  //         data[GetInvoice.resAmount] ?? 'N/A');
  //     _content = _content.replaceAll(
  //         _makeKey(GetInvoice.PDF_KEY_PRETAX_SUBTOTAL),
  //         data[GetInvoice.resSubtotal] ?? 'N/A');

  //     return _content;
  //   } catch (e) {
  //     return '';
  //   }
  // }

  // String _makeKey(String key) => ("\$\$__" + key + "__\$\$");
}
