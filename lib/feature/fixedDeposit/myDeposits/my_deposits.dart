import 'package:felloapp/core/model/fixedDeposit/my_fds.dart';
import 'package:felloapp/feature/fixedDeposit/myDeposits/bloc/fixed_deposit_bloc.dart';
import 'package:felloapp/ui/pages/static/error_page.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyDepositsSection extends StatelessWidget {
  const MyDepositsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MyFixedDepositBloc(
        locator(),
      )..add(
          const LoadMyFDs(),
        ),
      child: const _InvestmentDetails(),
    );
  }
}

class _InvestmentDetails extends StatelessWidget {
  const _InvestmentDetails();

  @override
  Widget build(BuildContext context) {
    final myfundsBloc = context.read<MyFixedDepositBloc>();
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        myfundsBloc.add(const LoadMyFDs());
      },
      child: BlocBuilder<MyFixedDepositBloc, MyFixedDepositState>(
        builder: (context, state) {
          return switch (state) {
            LoadingMyDeposits() => const FullScreenLoader(),
            FdMyDepositsError() => NewErrorPage(
                onTryAgain: () {
                  myfundsBloc.add(const LoadMyFDs());
                },
              ),
            FdDepositsLoaded() => CustomScrollView(
                slivers: [
                  SliverOverlapInjector(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                      context,
                    ),
                  ),
                  // Add the Summary Card at the top
                  SliverToBoxAdapter(
                    child: SummaryCard(summary: state.fdData.summary),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 20.h, // Use ScreenUtil for height
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final fdData = state.fdData;
                        final portfolio = fdData.portfolio[index];

                        return _buildInvestmentSection(portfolio.issuer, {
                          'current': portfolio.currentAmount,
                          'avgXirr': portfolio.roi,
                          'invested': portfolio.investedAmount,
                          'tenure': portfolio.tenure,
                        });
                      },
                      childCount: state.fdData.portfolio.length,
                    ),
                  ),
                ],
              )
          };
        },
      ),
    );
  }

  Widget _buildInvestmentSection(String title, Map<String, dynamic> data) {
    return Container(
      margin:
          EdgeInsets.symmetric(horizontal: 20.w), // Use ScreenUtil for width

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: UiConstants.greyVarient,
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title with arrow on the right
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.sp, // Use ScreenUtil for font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.arrow_forward_ios,
                    size: 18.sp), // Use ScreenUtil for icon size
              ],
            ),
            SizedBox(height: 16.h), // Use ScreenUtil for height

            // Current amount and Avg. XIRR on the same row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'Current',
                      style: TextStyle(
                          fontSize: 16.sp), // Use ScreenUtil for font size
                    ),
                    Text(
                      '₹${data['current']}',
                      style: TextStyle(
                        fontSize: 16.sp, // Use ScreenUtil for font size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Avg. XIRR',
                      style: TextStyle(
                          fontSize: 16.sp), // Use ScreenUtil for font size
                    ),
                    Text(
                      '${data['avgXirr']}% p.a.',
                      style: TextStyle(
                        fontSize: 16.sp, // Use ScreenUtil for font size
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ],
            ),

            SizedBox(height: 16.h), // Use ScreenUtil for height

            // Invested amount and Tenure on the same row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'Invested',
                      style: TextStyle(
                          fontSize: 16.sp), // Use ScreenUtil for font size
                    ),
                    Text(
                      '₹${data['invested']}',
                      style: TextStyle(
                        fontSize: 16.sp, // Use ScreenUtil for font size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Tenure',
                      style: TextStyle(
                          fontSize: 16.sp), // Use ScreenUtil for font size
                    ),
                    Text(
                      '${data['tenure']} months',
                      style: TextStyle(
                        fontSize: 16.sp, // Use ScreenUtil for font size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final SummaryModel summary;

  const SummaryCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.symmetric(horizontal: 20.w), // Use ScreenUtil for width
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: UiConstants.greyVarient,
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title for the summary card
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Summary',
                  style: TextStyle(
                    fontSize: 18.sp, // Use ScreenUtil for font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h), // Use ScreenUtil for height

            // Display the summary details in rows and columns
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'Total Invested',
                      style: TextStyle(
                          fontSize: 16.sp), // Use ScreenUtil for font size
                    ),
                    Text(
                      '₹${summary.totalInvestedAmount}',
                      style: TextStyle(
                        fontSize: 16.sp, // Use ScreenUtil for font size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Total Current',
                      style: TextStyle(
                          fontSize: 16.sp), // Use ScreenUtil for font size
                    ),
                    Text(
                      '₹${summary.totalCurrentAmount}',
                      style: TextStyle(
                        fontSize: 16.sp, // Use ScreenUtil for font size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: 16.h), // Use ScreenUtil for height
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'Total Returns',
                      style: TextStyle(
                          fontSize: 16.sp), // Use ScreenUtil for font size
                    ),
                    Text(
                      '₹${summary.totalReturns}',
                      style: TextStyle(
                        fontSize: 16.sp, // Use ScreenUtil for font size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Avg. XIRR',
                      style: TextStyle(
                          fontSize: 16.sp), // Use ScreenUtil for font size
                    ),
                    Text(
                      '${summary.averageXIRR}% p.a.',
                      style: TextStyle(
                        fontSize: 16.sp, // Use ScreenUtil for font size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
