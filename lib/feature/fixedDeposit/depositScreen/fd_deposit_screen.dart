import 'package:felloapp/feature/fixedDeposit/depositScreen/bloc/fixed_deposit_bloc.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/consultant_card.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/error_page.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FdCalculatorView extends StatelessWidget {
  const FdCalculatorView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FDCalculatorBloc(
        locator(),
      )..add(
          const LoadFDCalculator(),
        ),
      child: _FDDepositView(),
    );
  }
}

class _FDDepositView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final fundsBloc = context.read<FDCalculatorBloc>();
    return BaseScaffold(
      showBackgroundGrid: true,
      body: BlocBuilder<FDCalculatorBloc, FixedDepositCalculatorState>(
        builder: (context, state) {
          return switch (state) {
            LoadingFdCalculator() => const FullScreenLoader(),
            FCalculatorError() => NewErrorPage(
                onTryAgain: () {
                  fundsBloc.add(const LoadFDCalculator());
                },
              ),
            FdCalculatorLoaded() => SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Company Name and Description
                    Text(
                      state.fdCalculatorData.displayName,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      state.fdCalculatorData.description,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: 24),

                    // Investment Options
                    Text(
                      "Investment Amount",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: state.fdCalculatorData.investmentOptions
                          .map<Widget>((option) => Chip(
                                label: Text(option.amount),
                              ))
                          .toList(),
                    ),
                    SizedBox(height: 24),

                    // Lock-in Tenure
                    Text(
                      "Lock-in Tenure",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: state.fdCalculatorData.lockInTenure
                          .map<Widget>((tenure) => Chip(
                                label: Text(tenure.range),
                              ))
                          .toList(),
                    ),
                    SizedBox(height: 24),

                    // Interest Rates Table
                    Text(
                      "Interest Rates",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Table(
                      border: TableBorder.all(),
                      children: [
                        TableRow(
                          children: [
                            TableCell(child: Center(child: Text("Tenure"))),
                            TableCell(child: Center(child: Text("General"))),
                            TableCell(
                                child: Center(child: Text("Sr. Citizen"))),
                          ],
                        ),
                        ...state.fdCalculatorData.interestRates
                            .map<TableRow>((rate) {
                          return TableRow(
                            children: [
                              TableCell(
                                  child: Center(child: Text(rate.tenure))),
                              TableCell(
                                  child: Center(child: Text(rate.general))),
                              TableCell(
                                  child:
                                      Center(child: Text(rate.seniorCitizen))),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                    SizedBox(height: 24),

                    // Interest Payout
                    Text(
                      "Interest Payout: ${state.fdCalculatorData.interestPayout}",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 16),

                    // Estimated Payout
                    Text(
                      "Your estimated payout after 1 year",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${state.fdCalculatorData.estimatedPayout.amount} giving ${state.fdCalculatorData.estimatedPayout.returns}",
                      style: TextStyle(fontSize: 16, color: Colors.green),
                    ),
                    SizedBox(height: 24),

                    // Call to Action Buttons
                    ElevatedButton(
                      onPressed: () {
                        // Handle Invest Now
                      },
                      child: Text(state.fdCalculatorData.cta.investNow),
                    ),
                    SizedBox(height: 16),
                    const ConsultationWidget()
                  ],
                ),
              )
          };
        },
      ),
    );
  }
}
