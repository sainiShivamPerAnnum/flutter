import 'package:felloapp/ui/pages/userProfile/kyc_details/kyc_details_view.dart';
import 'package:felloapp/ui/pages/userProfile/kyc_details/kyc_details_vm.dart';
import 'package:flutter/material.dart';

class KycFailedView extends StatelessWidget {
  final KYCDetailsViewModel model;

  const KycFailedView({required this.model, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KycBriefTile(
        label: "",
        title: "PAN Verification Failed",
        model: model,
        trailing: const SizedBox());
  }
}
