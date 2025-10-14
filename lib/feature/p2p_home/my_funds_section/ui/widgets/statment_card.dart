import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/statement_model.dart';
import 'package:felloapp/core/repository/transactions_history_repo.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/pdf_opener.dart';
import 'package:felloapp/core/service/pdf_statement_api.dart';
import 'package:felloapp/feature/p2p_home/my_funds_section/bloc/my_funds_section_bloc.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class StatementCard extends StatefulWidget {
  const StatementCard({
    required this.fundBloc,
    this.customerName = "User",
    this.accountNumber = "ACC001",
    super.key,
  });

  final MyFundsBloc fundBloc;
  final String customerName;
  final String accountNumber;

  @override
  State<StatementCard> createState() => _StatementCardState();
}

class _StatementCardState extends State<StatementCard> {
  bool _isGeneratingPdf = false;

  Future<void> _generateAndDownloadStatement() async {
    setState(() {
      _isGeneratingPdf = true;
    });

    try {
      final transactions = await _getTransactions();

      // Calculate from and to dates based on transactions
      String fromDate = "01/01/2024"; // Default fallback
      String toDate = "31/12/2024";   // Default fallback

      if (transactions.isNotEmpty) {
        final sortedTransactions = List<Transaction>.from(transactions)
          ..sort((a, b) {
            final dateA = _parseTransactionDate(a.paymentDate);
            final dateB = _parseTransactionDate(b.paymentDate);
            return dateA.compareTo(dateB);
          });
        fromDate = sortedTransactions.first.paymentDate;
        toDate = sortedTransactions.last.paymentDate;
      }

      final statement = Statement(
        info: StatementInfo(
          accountNumber: widget.accountNumber,
          fromDate: fromDate,
          toDate: toDate,
          generatedDate: DateFormat('dd/MM/yyyy').format(DateTime.now()),
        ),
        transactions: transactions,
      );

      await PdfStatementApi.generate(statement);
      Directory? directory;
      try {
        directory = await getExternalStorageDirectory();
      } catch (e) {
        directory = await getApplicationDocumentsDirectory();
      }
      final String userName =
          (locator<UserService>().baseUser!.kycName != null &&
                      locator<UserService>().baseUser!.kycName!.isNotEmpty
                  ? locator<UserService>().baseUser!.kycName
                  : locator<UserService>().baseUser!.name) ??
              "N/A";
      final filePath = '${directory?.path}/soa_$userName.pdf';
      final file = File(filePath);
      await PdfOpener.openPdf(file);
    } catch (e) {
      if (mounted) {
        BaseUtil.showNegativeAlert('Error generating statement', e.toString());
      }
    } finally {
      setState(() {
        _isGeneratingPdf = false;
      });
    }
  }

  // Helper method to parse transaction date string to DateTime
  DateTime _parseTransactionDate(String dateString) {
    try {
      // The API returns date in format: "14/03/2024 18:34"
      // Parse the full datetime string
      return DateFormat('dd/MM/yyyy HH:mm').parse(dateString);
    } catch (e) {
      try {
        // Fallback: try just the date part if time parsing fails
        if (dateString.contains(' ')) {
          final datePart = dateString.split(' ')[0]; // Get "14/03/2024" part
          return DateFormat('dd/MM/yyyy').parse(datePart);
        }

        // If no space, assume it's just the date
        return DateFormat('dd/MM/yyyy').parse(dateString);
      } catch (e2) {
        // If all parsing fails, return current date as fallback
        debugPrint('Error parsing date: $dateString, Error: $e2');
        return DateTime.now();
      }
    }
  }

  Future<List<Transaction>> _getTransactions() async {
    try {
      final result =
          await locator<TransactionHistoryRepository>().getStatement();
      return result.model ?? [];
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: UiConstants.grey5,
        borderRadius: BorderRadius.circular(
          SizeConfig.roundness12,
        ),
      ),
      padding: EdgeInsets.all(SizeConfig.padding20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Statement of account',
            style: TextStyles.sourceSansSB.body2.colour(UiConstants.kTextColor),
          ),
          SizedBox(height: SizeConfig.padding2),
          Text(
            'View detailed history of your investments and withdrawals',
            style: TextStyles.sourceSans.body4.colour(UiConstants.kTextColor3),
            maxLines: 2,
          ),
          SizedBox(height: SizeConfig.padding12),
          GestureDetector(
            onTap: _isGeneratingPdf ? null : _generateAndDownloadStatement,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: SizeConfig.padding14,
              ),
              decoration: BoxDecoration(
                color: _isGeneratingPdf
                    ? UiConstants.kTextColor3.withOpacity(0.5)
                    : UiConstants.kTextColor,
                borderRadius: BorderRadius.circular(
                  SizeConfig.roundness8,
                ),
              ),
              child: Center(
                child: _isGeneratingPdf
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: SizeConfig.padding16,
                            width: SizeConfig.padding16,
                            child: CircularProgressIndicator(
                              strokeWidth: SizeConfig.padding2,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                UiConstants.kTextColor4,
                              ),
                            ),
                          ),
                          SizedBox(width: SizeConfig.padding8),
                          Text(
                            'GENERATING...',
                            style: TextStyles.sourceSansSB.colour(
                              UiConstants.kTextColor4,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        'DOWNLOAD',
                        style: TextStyles.sourceSansSB.colour(
                          UiConstants.kTextColor4,
                        ),
                      ),
              ),
            ),
          ),
          SizedBox(height: SizeConfig.padding12),

          // Additional info text
          Text(
            'Portfolio page may show incorrect data about your investments, refer the statement instead',
            style: TextStyles.sourceSans.body4.colour(UiConstants.kTextColor3),
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}
