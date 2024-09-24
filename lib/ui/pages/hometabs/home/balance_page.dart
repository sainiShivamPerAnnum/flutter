import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class FelloBalancePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:UiConstants.bg,
      appBar: AppBar(
        title: Text('Fello Balance'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BalanceHeader(),
            SizedBox(height: 20),
            InvestmentSection(
              title: 'Fello Flo',
              balance: '₹502',
              change: '₹2',
              investedAmount: '₹500',
              buttonLabel: 'Invest',
            ),
            SizedBox(height: 20),
            InvestmentSection(
              title: 'Digital Gold',
              balance: '₹502',
              change: '₹2',
              investedAmount: '₹500',
              buttonLabel: 'Invest',
            ),
            SizedBox(height: 20),
            InvestmentSection(
              title: 'Fello Rewards',
              balance: '₹502',
              change: '₹2',
              investedAmount: '₹500',
              buttonLabel: 'Redeem',
            ),
          ],
        ),
      ),
    );
  }
}

class BalanceHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Fello Balance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {},
              child: Text('View Breakdown'),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Text(
              '₹ 12,66,320.78',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 10),
            Text(
              '+11.3%',
              style: TextStyle(
                fontSize: 16,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class InvestmentSection extends StatelessWidget {
  final String title;
  final String balance;
  final String change;
  final String investedAmount;
  final String buttonLabel;

  InvestmentSection({
    required this.title,
    required this.balance,
    required this.change,
    required this.investedAmount,
    required this.buttonLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text(
                '₹$balance',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 5),
              Text(
                '▲$change',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.green,
                ),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {},
                child: Text(buttonLabel),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text('Gold Value'),
              Spacer(),
              Text(investedAmount),
            ],
          ),
        ],
      ),
    );
  }
}