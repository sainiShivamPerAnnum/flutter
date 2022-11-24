import 'package:felloapp/ui/pages/others/profile/kyc_details/kyc_details_view.dart';
import 'package:felloapp/ui/pages/others/profile/kyc_details/kyc_details_vm.dart';
import 'package:flutter/material.dart';

class KycFailedView extends StatelessWidget {
  final KYCDetailsViewModel model;

  const KycFailedView({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KycBriefTile(
        label: "",
        title: "PAN Verification Failed",
        model: model,
        trailing: SizedBox());
  }
}
