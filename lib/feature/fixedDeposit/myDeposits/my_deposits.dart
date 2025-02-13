import 'package:felloapp/feature/fixedDeposit/myDeposits/bloc/fixed_deposit_bloc.dart';
import 'package:felloapp/ui/pages/static/error_page.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: SizeConfig.padding20,
                    ),
                  ),
                  SliverList(delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final fdData = state.fdData;
                      _buildInvestmentSection('Current', {
                        'current': '51,567.54',
                        'avgXirr': '9.2% p.a.',
                        'invested': '50,000',
                        'tenure': '6 months',
                      });
                    },
                  ))
                ],
              )
          };
        },
      ),
    );
  }

  Widget _buildInvestmentSection(String title, Map<String, dynamic> data) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            _buildDetailRow('Current', data['current']),
            _buildDetailRow('Avg. XIRR', data['avgXirr']),
            _buildDetailRow('Invested', data['invested']),
            if (data.containsKey('netReturns'))
              _buildDetailRow('Net returns', data['netReturns']),
            if (data.containsKey('tenure'))
              _buildDetailRow('Tenure', data['tenure']),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, dynamic value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16)),
          Text(value.toString(),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
