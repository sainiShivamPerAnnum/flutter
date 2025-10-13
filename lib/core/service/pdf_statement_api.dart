import 'dart:io';
import 'package:felloapp/core/model/statement_model.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/pdf_api.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/extensions/string_extension.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

extension StatementExtension on Statement {
  Statement copyWith({
    StatementInfo? info,
    List<Transaction>? transactions,
    File? bgImage,
    File? brokerLogo,
  }) {
    return Statement(
      info: info ?? this.info,
      transactions: transactions ?? this.transactions,
      bgImage: bgImage ?? this.bgImage,
      brokerLogo: brokerLogo ?? this.brokerLogo,
    );
  }
}

class PdfStatementApi {
  static const int firstPageTransactionLimit = 10;
  static const int subsequentPageTransactionLimit = 20;


  static Future<File> generate(Statement statement) async {
    final pdf = Document();
    final ByteData headerImageData =
        await rootBundle.load(Assets.statementHeader);
    final Uint8List headerImageBytes = headerImageData.buffer.asUint8List();

    // Split transactions for different pages
    final List<List<Transaction>> transactionPages =
        _splitTransactionsForPages(statement.transactions);

    // First page with header, statement info, and limited transactions
    pdf.addPage(
      MultiPage(
        maxPages: 1,
        pageTheme: PageTheme(
          theme: ThemeData(softWrap: true),
          margin: const EdgeInsets.all(0),
          buildBackground: (ctx) {
            if (statement.bgImage != null) {
              final image = MemoryImage(
                statement.bgImage!.readAsBytesSync(),
              );
              return Image(
                image,
                alignment: Alignment.center,
                fit: BoxFit.cover,
              );
            }
            return Container();
          },
        ),
        build: (context) {
          List<Widget> widgets = [
            // Header
            Container(
              width: double.infinity,
              height: 150,
              child: Image(
                MemoryImage(headerImageBytes),
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter,
              ),
            ),
            buildStatementInfo(statement.info),
            SizedBox(height: PdfPageFormat.cm * 1.5),
          ];

          // Add first page transactions or empty message
          if (transactionPages.isNotEmpty) {
            widgets.add(
              buildTransactionsTable(
                transactionPages[0],
                isFirstPage: true,
                pageNumber: 1,
                totalPages: transactionPages.length,
                totalTransactions: statement.transactions.length,
              ),
            );
          } else {
            widgets.add(buildEmptyTransactionsMessage());
          }

          // REMOVED: Summary is no longer added to first page
          // The summary will always be on a separate page now

          return widgets;
        },
        footer: (context) => buildFooter(statement),
      ),
    );

    // Add subsequent pages for remaining transactions (if any)
    for (int i = 1; i < transactionPages.length; i++) {
      pdf.addPage(
        MultiPage(
          maxPages: 1,
          pageTheme: PageTheme(
            theme: ThemeData(softWrap: true),
            margin: const EdgeInsets.all(0),
            buildBackground: (ctx) {
              if (statement.bgImage != null) {
                final image = MemoryImage(
                  statement.bgImage!.readAsBytesSync(),
                );
                return Image(
                  image,
                  alignment: Alignment.center,
                  fit: BoxFit.cover,
                );
              }
              return Container();
            },
          ),
          build: (context) {
            List<Widget> widgets = [
              SizedBox(height: PdfPageFormat.cm * 2),
              buildTransactionsTable(
                transactionPages[i],
                isFirstPage: false,
                pageNumber: i + 1,
                totalPages: transactionPages.length,
                totalTransactions: statement.transactions.length,
              ),
            ];

            // REMOVED: Summary is no longer added to last transaction page
            // The summary will always be on a separate page now

            return widgets;
          },
          footer: (context) => buildFooter(statement),
        ),
      );
    }

    // NEW: Always add a dedicated summary page
    // pdf.addPage(
    //   MultiPage(
    //     maxPages: 1,
    //     pageTheme: PageTheme(
    //       theme: ThemeData(softWrap: true),
    //       margin: const EdgeInsets.all(0),
    //       buildBackground: (ctx) {
    //         if (statement.bgImage != null) {
    //           final image = MemoryImage(
    //             statement.bgImage!.readAsBytesSync(),
    //           );
    //           return Image(
    //             image,
    //             alignment: Alignment.center,
    //             fit: BoxFit.cover,
    //           );
    //         }
    //         return Container();
    //       },
    //     ),
    //     build: (context) {
    //       return [
    //         SizedBox(height: PdfPageFormat.cm * 2),
    //         buildSummary(statement),
    //         SizedBox(height: PdfPageFormat.cm),
    //       ];
    //     },
    //     footer: (context) => buildFooter(statement),
    //   ),
    // );

    final String userName = (locator<UserService>().baseUser!.kycName != null &&
                locator<UserService>().baseUser!.kycName!.isNotEmpty
            ? locator<UserService>().baseUser!.kycName
            : locator<UserService>().baseUser!.name) ??
        "N/A";
    return PdfApi.saveDocument(
      name: "soa_$userName.pdf",
      pdf: pdf,
    );
  }

  // Helper method to split transactions based on page limits
  static List<List<Transaction>> _splitTransactionsForPages(
      List<Transaction> transactions) {
    if (transactions.isEmpty) return [];

    List<List<Transaction>> pages = [];
    int currentIndex = 0;

    // First page: maximum 5 transactions
    if (currentIndex < transactions.length) {
      final firstPageCount =
          currentIndex + firstPageTransactionLimit > transactions.length
              ? transactions.length
              : firstPageTransactionLimit;
      pages.add(transactions.sublist(currentIndex, firstPageCount));
      currentIndex = firstPageCount;
    }

    // Subsequent pages: maximum 10 transactions each
    while (currentIndex < transactions.length) {
      final endIndex =
          currentIndex + subsequentPageTransactionLimit > transactions.length
              ? transactions.length
              : currentIndex + subsequentPageTransactionLimit;
      pages.add(transactions.sublist(currentIndex, endIndex));
      currentIndex = endIndex;
    }

    return pages;
  }

  static Widget buildStatementInfo(StatementInfo info) {
    final titles = <String>[
      'Statement Period:',
      'Generated On:',
    ];
    final data = <String>[
      '${info.fromDate} to ${info.toDate}',
      info.generatedDate,
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2 * PdfPageFormat.cm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statement Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: PdfColors.grey800,
            ),
          ),
          SizedBox(height: PdfPageFormat.cm * 0.5),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: PdfColors.grey300),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              children: List.generate(titles.length, (index) {
                final title = titles[index];
                final value = data[index];
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: index % 2 == 0 ? PdfColors.grey50 : PdfColors.white,
                    border: index < titles.length - 1
                        ? const Border(
                            bottom: BorderSide(color: PdfColors.grey200),
                          )
                        : null,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: PdfColors.grey700,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          value,
                          style: const TextStyle(
                            fontSize: 12,
                            color: PdfColors.grey900,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildEmptyTransactionsMessage() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2 * PdfPageFormat.cm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transaction History',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: PdfColors.grey800,
            ),
          ),
          SizedBox(height: PdfPageFormat.cm * 0.5),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              border: Border.all(color: PdfColors.grey300),
              borderRadius: BorderRadius.circular(4),
              color: PdfColors.grey50,
            ),
            child: Center(
              child: Text(
                'No transactions found for this period.',
                style: TextStyle(
                  fontSize: 14,
                  color: PdfColors.grey600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildTransactionsTable(
    List<Transaction> transactions, {
    required bool isFirstPage,
    required int pageNumber,
    required int totalPages,
    required int totalTransactions,
  }) {
    final headers = ['Date', 'Investment', 'UTR', 'Amount'];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2 * PdfPageFormat.cm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isFirstPage ? 'Transaction History' : 'Transaction History',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: PdfColors.grey800,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (totalPages > 1)
                    Text(
                      'Page $pageNumber of $totalPages',
                      style: const TextStyle(
                        fontSize: 10,
                        color: PdfColors.grey600,
                      ),
                    ),
                  Text(
                    'Total Transactions: $totalTransactions',
                    style: const TextStyle(
                      fontSize: 9,
                      color: PdfColors.grey500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: PdfPageFormat.cm * 0.5),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: PdfColors.grey300),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              children: [
                // Header row
                Container(
                  decoration: const BoxDecoration(
                    color: PdfColors.grey700,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(3),
                      topRight: Radius.circular(3),
                    ),
                  ),
                  child: Table(
                    border:
                        TableBorder.all(color: PdfColors.grey200, width: 0.5),
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(3),
                      2: FlexColumnWidth(2),
                      3: FlexColumnWidth(2),
                    },
                    children: [
                      TableRow(
                        children: headers
                            .map((header) => Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 12),
                                  child: Text(
                                    header,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                      color: PdfColors.white,
                                    ),
                                    textAlign: header == 'Amount'
                                        ? TextAlign.right
                                        : TextAlign.left,
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),

                // Transaction rows
                ...transactions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final transaction = entry.value;

                  return Container(
                    decoration: BoxDecoration(
                      color:
                          index % 2 == 0 ? PdfColors.white : PdfColors.grey50,
                    ),
                    child: Table(
                      border:
                          TableBorder.all(color: PdfColors.grey200, width: 0.5),
                      columnWidths: const {
                        0: FlexColumnWidth(2),
                        1: FlexColumnWidth(3),
                        2: FlexColumnWidth(2),
                        3: FlexColumnWidth(2),
                      },
                      children: [
                        TableRow(
                          children: [
                           Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8, 
                                vertical: 10,
                              ),
                              child: Text(
                                DateFormat('dd/MM/yyyy')
                                    .format(DateFormat('yyyy-MM-dd')
                                    .parse(transaction.paymentDate)),
                                style: const TextStyle(
                                  fontSize: 9,
                                  color: PdfColors.grey800,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 10,),
                              child: Text(
                                transaction.bankStatus == "Paid" ?
                                   "Withdrawal": transaction.bankStatus,
                                style: const TextStyle(
                                  fontSize: 9,
                                  color: PdfColors.grey800,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 10,),
                              child: Text(
                                transaction.utrNo,
                                style: const TextStyle(
                                  fontSize: 9,
                                  color: PdfColors.grey800,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 10,),
                              child: Text(
                                'Rs. ${transaction.paidAmount}',
                                style: const TextStyle(
                                  fontSize: 9,
                                  color: PdfColors.grey800,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // static Widget buildSummary(Statement statement) {
  //   final totalCredits = statement.transactions
  //       .where((t) => t.txnType.toUpperCase() == 'CREDIT')
  //       .map((t) => t.paidAmount)
  //       .fold(0.0, (sum, paidAmount) => sum + paidAmount);

  //   final totalDebits = statement.transactions
  //       .where((t) => t.txnType.toUpperCase() == 'DEBIT')
  //       .map((t) => t.paidAmount)
  //       .fold(0.0, (sum, paidAmount) => sum + paidAmount);

  //   final balance =
  //       totalDebits > totalCredits ? 0.0 : totalCredits - totalDebits;

  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 2 * PdfPageFormat.cm),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           'Summary',
  //           style: TextStyle(
  //             fontSize: 18,
  //             fontWeight: FontWeight.bold,
  //             color: PdfColors.grey800,
  //           ),
  //         ),
  //         SizedBox(height: PdfPageFormat.cm * 0.5),
  //         Row(
  //           children: [
  //             Expanded(
  //               flex: 2,
  //               child: Container(
  //                 decoration: BoxDecoration(
  //                   border: Border.all(color: PdfColors.grey300),
  //                   borderRadius: BorderRadius.circular(4),
  //                 ),
  //                 child: Table(
  //                   border: TableBorder.all(
  //                     color: PdfColors.grey200,
  //                     width: 0.5,
  //                   ),
  //                   columnWidths: const {
  //                     0: FlexColumnWidth(2),
  //                     1: FlexColumnWidth(1),
  //                   },
  //                   children: [
  //                     _buildSummaryTableRow(
  //                       'Total Deposits',
  //                       'Rs. ${totalCredits.toStringAsFixed(2)}',
  //                     ),
  //                     _buildSummaryTableRow(
  //                       'Total Withdrawals',
  //                       'Rs. ${totalDebits.toStringAsFixed(2)}',
  //                     ),
  //                     _buildSummaryTableRow(
  //                       'Balance',
  //                       'Rs. ${balance.toStringAsFixed(2)}',
  //                       isTotal: true,
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             Expanded(flex: 1, child: Container()),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // static TableRow _buildSummaryTableRow(
  //   String title,
  //   String value, {
  //   bool isTotal = false,
  // }) {
  //   return TableRow(
  //     decoration: BoxDecoration(
  //       color: isTotal ? PdfColors.grey200 : PdfColors.white,
  //     ),
  //     children: [
  //       Container(
  //         padding: const EdgeInsets.all(8),
  //         child: Text(
  //           title,
  //           style: TextStyle(
  //             fontSize: isTotal ? 12 : 11,
  //             fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
  //             color: PdfColors.grey700,
  //           ),
  //         ),
  //       ),
  //       Container(
  //         padding: const EdgeInsets.all(8),
  //         child: Text(
  //           value,
  //           textAlign: TextAlign.right,
  //           style: TextStyle(
  //             fontSize: isTotal ? 12 : 11,
  //             fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
  //             color: isTotal ? PdfColors.grey900 : PdfColors.grey800,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  static Widget buildFooter(Statement statement) => Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 2 * PdfPageFormat.cm),
        padding: const EdgeInsets.symmetric(vertical: PdfPageFormat.cm * 0.5),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: PdfColors.grey300)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (statement.brokerLogo != null)
              Container(
                height: 40,
                width: 60,
                margin: const EdgeInsets.only(bottom: 10),
                child: Image(
                  MemoryImage(statement.brokerLogo!.readAsBytesSync()),
                  fit: BoxFit.contain,
                ),
              ),
            Text(
              "Expertree Technologies Private Limited".capitalize(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: PdfColors.grey700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4),
            Text(
              "https://fello.in/",
              style: const TextStyle(
                fontSize: 10,
                color: PdfColors.grey600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              "This is a computer generated statement and does not require signature.",
              style: TextStyle(
                fontSize: 8,
                fontStyle: FontStyle.italic,
                color: PdfColors.grey500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
}
