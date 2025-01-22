import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/ui/elements/appbar/appbar.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class FixedDepositDetails extends StatelessWidget {
  const FixedDepositDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: const FAppBar(
        title: 'Deposit Details',
        showHelpButton: true,
        type: FaqsType.felloFlo,
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
                    Radius.circular(
                      SizeConfig.roundness12,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    Chip(
                      label: Text(
                        'Active',
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
                    Text(
                      '#346H76',
                      style: TextStyles.sourceSansSB.body1,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(SizeConfig.padding18),
                decoration: BoxDecoration(
                  color: UiConstants.greyVarient,
                  border: Border.all(
                    width: SizeConfig.padding1,
                    color: UiConstants.grey7,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      SizeConfig.roundness12,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    _buildDetailRow('Deposit ID', '#13TH89'),
                    _buildDetailRow('Deposit amount', '¥75,000'),
                    _buildDetailRow('Deposit date', 'Nov 12, 2024'),
                    _buildDetailRow('Maturity date', 'Nov 12, 2025'),
                    _buildDetailRow('Tenure and ROI', '8 mos @ 14%'),
                    const Divider(
                      color: UiConstants.grey7,
                    ),
                    _buildDetailRow('Est. payout', '¥81,846.54'),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(value: false, onChanged: (bool? value) {}),
                  Text('Maturing in 20 days', style: TextStyles.sourceSans),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Payout Bank Account',
                style: TextStyles.sourceSansSB.body1,
              ),
              SizedBox(height: 8),
              Container(
                  padding: EdgeInsets.all(SizeConfig.padding18),
                  decoration: BoxDecoration(
                    color: UiConstants.greyVarient,
                    border: Border.all(
                      width: SizeConfig.padding1,
                      color: UiConstants.grey7,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        SizeConfig.roundness12,
                      ),
                    ),
                  ),
                  child: _buildDetailRow('HDFC Bank', 'XX4747')),
              SizedBox(height: SizeConfig.padding34),
              Text(
                'Payout History',
                style: TextStyles.sourceSansSB.body1,
              ),
              SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(SizeConfig.padding18),
                decoration: BoxDecoration(
                  color: UiConstants.greyVarient,
                  border: Border.all(
                    width: SizeConfig.padding1,
                    color: UiConstants.grey7,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      SizeConfig.roundness12,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPayoutHistory(
                      '12 Dec, 2024',
                      '¥3,330',
                      'CM58530873948',
                    ),
                    _buildPayoutHistory(
                      '12 Jan, 2025',
                      '¥3,330',
                      'CM58530873948',
                    ),
                    _buildPayoutHistory(
                      '12 Feb, 2025',
                      '¥3,330',
                      'CM58530873948',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyles.sourceSans),
          Text(value, style: TextStyles.sourceSans),
        ],
      ),
    );
  }

  Widget _buildPayoutHistory(String date, String amount, String utr) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(date, style: TextStyles.sourceSans),
          SizedBox(height: 4),
          Text('$amount interest transferred to xx4747',
              style: TextStyles.sourceSans),
          Text('UTR - $utr', style: TextStyles.sourceSans),
        ],
      ),
    );
  }
}
