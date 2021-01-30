import 'package:flutter/material.dart';

class KycOnboardController extends StatefulWidget {
  @override
  State createState() => _KycOnboardControllerState();
}

class _KycOnboardControllerState extends State<KycOnboardController>{

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Perform KYC here'),
      ),
    );
  }
}