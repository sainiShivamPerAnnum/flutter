import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/model/fixedDeposit/fd_transaction.dart';
import 'package:felloapp/core/model/fixedDeposit/my_fds.dart';
import 'package:felloapp/ui/elements/appbar/appbar.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/error_page.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class FixedDepositDetails extends StatelessWidget {
  final dynamic fdData;

  const FixedDepositDetails({
    required this.fdData,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    IndividualFDModel? individualFd;
    BankDetails? bankDetail;
    String? status;
    String? applicationId;
    num? depositAmount;
    DateTime? depositDate;
    DateTime? maturityDate;
    num? roi;
    String? tenure;
    num? maturityAmount;

    if (fdData is UserFdPortfolio) {
      // Handle UserFdPortfolio
      final portfolioItem =
          fdData.portfolio.isNotEmpty ? fdData.portfolio.first : null;
      individualFd = portfolioItem?.individualFDs.isNotEmpty
          ? portfolioItem!.individualFDs.first
          : null;

      status = individualFd?.status;
      applicationId = individualFd?.applicationId;
      depositAmount = individualFd?.depositAmount;
      depositDate = individualFd?.depositDate;
      maturityDate = individualFd?.maturityDate;
      roi = individualFd?.roi;
      maturityAmount = individualFd?.maturityAmount;
      tenure = individualFd?.tenure;
      bankDetail = individualFd?.bankDetails?.isNotEmpty == true
          ? individualFd!.bankDetails!.first
          : null;
    } else if (fdData is FDTransactionData) {
      // Handle FDTransactionData
      status = fdData.status;
      applicationId = fdData.applicationId ?? fdData.jid;
      depositAmount = fdData.depositAmount;
      maturityAmount = fdData.maturityAmount;
      depositDate = fdData.depositDate != null
          ? DateTime.tryParse(fdData.depositDate!)
          : null;
      maturityDate = fdData.maturityDate != null
          ? DateTime.tryParse(fdData.maturityDate!)
          : null;
      roi = fdData.roi;
      tenure = fdData.tenure;
      bankDetail = fdData.bankDetails?.isNotEmpty == true
          ? fdData.bankDetails!.first
          : null;
    } else {
      return const NewErrorPage();
    }

    return BaseScaffold(
      showBackgroundGrid: false,
      backgroundColor: UiConstants.bg,
      appBar: const FAppBar(
        title: 'Deposit Details',
        showHelpButton: true,
        type: FaqsType.fd,
        showCoinBar: false,
        showAvatar: false,
        leadingPadding: false,
        backgroundColor: UiConstants.grey4,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(SizeConfig.padding8),
                width: double.infinity,
                height: SizeConfig.padding104,
                decoration: BoxDecoration(
                  color: UiConstants.greyVarient,
                  border: Border.all(
                    width: SizeConfig.padding1,
                    color: UiConstants.grey7,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(SizeConfig.roundness12),
                  ),
                ),
                child: Column(
                  children: [
                    Chip(
                      label: Text(
                        status ?? 'Active',
                        style: TextStyles.sourceSansM.body6.colour(
                          UiConstants.teal3,
                        ),
                      ),
                      color: WidgetStateProperty.all(
                        UiConstants.teal4,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          SizeConfig.roundness32,
                        ),
                        side: const BorderSide(
                          color: UiConstants.teal4,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '#$applicationId',
                        style: TextStyles.sourceSansSB.body1,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.all(SizeConfig.padding18),
                decoration: BoxDecoration(
                  color: UiConstants.greyVarient,
                  border: Border.all(
                    width: SizeConfig.padding1,
                    color: UiConstants.grey7,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(SizeConfig.roundness12),
                  ),
                ),
                child: Column(
                  children: [
                    _buildDetailRow(
                      'Deposit ID',
                      '#$applicationId',
                    ),
                    _buildDetailRow(
                      'Deposit amount',
                      depositAmount == null
                          ? null
                          : BaseUtil.formatIndianRupees(
                              depositAmount,
                            ),
                    ),
                    _buildDetailRow(
                      'Deposit date',
                      _formatDate(depositDate),
                    ),
                    _buildDetailRow(
                      'Maturity date',
                      _formatDate(maturityDate),
                    ),
                    _buildDetailRow(
                      'Tenure and ROI',
                      _formatTenureAndRoi(tenure, roi),
                    ),
                    const Divider(
                      color: UiConstants.grey7,
                    ),
                    _buildDetailRow(
                      'Est. payout',
                      maturityAmount == null
                          ? null
                          : BaseUtil.formatIndianRupees(maturityAmount),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              if (bankDetail != null) ...[
                Text(
                  'Payout Bank Account',
                  style: TextStyles.sourceSansSB.body1,
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.all(SizeConfig.padding18),
                  decoration: BoxDecoration(
                    color: UiConstants.greyVarient,
                    border: Border.all(
                      width: SizeConfig.padding1,
                      color: UiConstants.grey7,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(SizeConfig.roundness12),
                    ),
                  ),
                  child: _buildDetailRow(
                    bankDetail.bankName ?? 'Bank',
                    _maskAccountNumber(
                      bankDetail.accountNumber,
                    ),
                  ),
                ),
              ],
              SizedBox(height: SizeConfig.padding34),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyles.sourceSans),
          Text(value ?? 'N/A', style: TextStyles.sourceSans),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('MMM dd, yyyy').format(date);
  }

  String _formatTenureAndRoi(String? tenure, num? roi) {
    if (tenure == null && roi == null) return 'N/A';
    return '${tenure ?? 'N/A'} @ ${roi?.toStringAsFixed(1) ?? 'N/A'}%';
  }

  String _calculateEstimatedPayout(
    num? depositAmount,
    num? roi,
    String? tenure,
  ) {
    if (depositAmount == null || roi == null || tenure == null) return 'N/A';

    num principal = depositAmount;
    num rate = roi / 100;
    num time = _getTenureInYears(tenure);
    num estimatedPayout = principal * (1 + (rate * time));

    return BaseUtil.formatIndianRupees(estimatedPayout);
  }

  num _getTenureInYears(String tenure) {
    RegExp regex = RegExp(r'(\d+)');
    var match = regex.firstMatch(tenure);
    if (match != null) {
      int value = int.parse(match.group(1)!);
      return value / 12;
    }
    return 0;
  }

  String _maskAccountNumber(String? accountNumber) {
    if (accountNumber == null || accountNumber.length <= 4) return 'N/A';
    return 'XX${accountNumber.substring(accountNumber.length - 4)}';
  }
}
