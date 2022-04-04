import 'dart:io';

import 'package:felloapp/core/model/invoice_model.dart';
import 'package:felloapp/core/service/pdf_api.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
// import 'package:flutter/material.dart' as mt show NetworkImage;

class PdfInvoiceApi {
  static Future<File> generate(Invoice invoice) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      pageTheme: PageTheme(
          theme: ThemeData(softWrap: true),
          margin: EdgeInsets.all(0),
          buildBackground: (ctx) {
            final image = MemoryImage(
              invoice.bgImage.readAsBytesSync(),
            );

            return Image(
              image,
              alignment: Alignment.center,
              fit: BoxFit.cover,
            );
          }),
      build: (context) => [
        SizedBox(height: 2 * PdfPageFormat.cm),
        buildTitle(invoice),
        buildHeader(invoice),
        buildDescription(invoice.description),
        SizedBox(height: PdfPageFormat.cm),
        buildInvoice(invoice),
        Divider(endIndent: 2 * PdfPageFormat.cm, indent: 2 * PdfPageFormat.cm),
        buildTotal(invoice),
      ],
      footer: (context) => buildFooter(invoice),
    ));

    return PdfApi.saveDocument(
        name: "fello_invoice_no_${invoice.info.number}.pdf", pdf: pdf);
  }

  static Widget buildHeader(Invoice invoice) => Container(
      margin: EdgeInsets.symmetric(
          horizontal: 2 * PdfPageFormat.cm, vertical: PdfPageFormat.cm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            buildCustomerAddress(invoice.customer),
            SizedBox(height: 1 * PdfPageFormat.cm),
            buildSupplierAddress(invoice.supplier),
          ]),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                height: 80,
                width: 150,
                child: Image(
                  MemoryImage(invoice.sellerLogo.readAsBytesSync()),
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 1 * PdfPageFormat.cm),
              buildInvoiceInfo(invoice.info),
            ],
          )
        ],
      ));

  static Widget buildImage(String asset) {
    final image = MemoryImage(
      File(asset).readAsBytesSync(),
    );

    return Center(child: Image(image));
  }

  static Widget buildCustomerAddress(Customer customer) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Bill To",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 3 * PdfPageFormat.mm),
          Text(customer.name, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(customer.address),
        ],
      );

  static Widget buildInvoiceInfo(InvoiceInfo info) {
    final titles = <String>[
      'Invoice Number:',
      'Invoice Date:',
    ];
    final data = <String>[
      info.number,
      info.date,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(title: title, value: value, width: 200);
      }),
    );
  }

  static Widget buildDescription(Description inDes) {
    final titles = <String>['Metal:', 'Transaction ID:', 'HSN Code:'];
    final data = <String>[inDes.metal, inDes.trnId, inDes.hsn];
    List<Widget> children = List.generate(titles.length, (index) {
      final title = titles[index];
      final value = data[index];
      return buildText(title: title, value: value, width: 300);
    });

    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: 2 * PdfPageFormat.cm, vertical: PdfPageFormat.cm * 0.5),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          )
        ],
      ),
    );
  }

  static Widget buildSupplierAddress(Supplier supplier) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Sold By",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 3 * PdfPageFormat.mm),
          Text(supplier.name, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text(supplier.GSTIN),
        ],
      );

  static Widget buildTitle(Invoice invoice) => Container(
        margin: EdgeInsets.symmetric(horizontal: 2 * PdfPageFormat.cm),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'INVOICE',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            // BarcodeWidget(
            //   barcode: Barcode.qrCode(),
            //   data: invoice.info.number,
            // ),
          ],
        ),
      );

  static Widget buildInvoice(Invoice invoice) {
    final headers = ['Description', 'Grams', 'Rate/gm(INR)', 'Amount(INR)'];
    final data = invoice.items.map((item) {
      final total = item.amount;

      return [
        item.description,
        '${item.grams}',
        '${item.rate}',
        '${item.amount}',
      ];
    }).toList();

    return Container(
        margin: EdgeInsets.symmetric(horizontal: 2 * PdfPageFormat.cm),
        child: Table.fromTextArray(
          headers: headers,
          data: data,
          border: null,
          headerStyle: TextStyle(fontWeight: FontWeight.bold),
          headerDecoration: BoxDecoration(color: PdfColors.grey300),
          cellHeight: 30,
          cellAlignments: {
            0: Alignment.centerLeft,
            1: Alignment.centerRight,
            2: Alignment.centerRight,
            3: Alignment.centerRight,
            4: Alignment.centerRight,
            5: Alignment.centerRight,
          },
        ));
  }

  static Widget buildTotal(Invoice invoice) {
    final netTotal = invoice.items
        .map((item) => item.amount)
        .reduce((item1, item2) => item1 + item2);
    final total = netTotal;

    return Container(
      alignment: Alignment.centerRight,
      margin: EdgeInsets.symmetric(horizontal: 2 * PdfPageFormat.cm),
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  title: 'Total',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: invoice.total,
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildFooter(Invoice invoice) => Container(
      margin: EdgeInsets.symmetric(horizontal: 2 * PdfPageFormat.cm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 50,
            width: 80,
            child: Image(
              MemoryImage(invoice.brokerLogo.readAsBytesSync()),
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 2 * PdfPageFormat.mm),
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          Text("Fello Technologies Pvt Ltd"),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text("https://fello.in/"),
          SizedBox(height: PdfPageFormat.cm / 2)
        ],
      ));

  static buildSimpleText({
    String title,
    String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    String title,
    String value,
    double width = double.infinity,
    TextStyle titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      margin: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          SizedBox(width: 20),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}

// class Utils {
//   static formatPrice(double price) => '\$ ${price.toStringAsFixed(2)}';
//   static formatDate(DateTime date) => DateFormat.yMd().format(date);
// }
