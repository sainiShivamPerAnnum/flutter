import 'package:felloapp/ui/pages/others/profile/kyc_details/kyc_details_view.dart';
import 'package:felloapp/ui/pages/others/profile/kyc_details/kyc_details_vm.dart';
import 'package:flutter/material.dart';

class NoKycView extends StatelessWidget {
  final KYCDetailsViewModel model;

  const NoKycView({Key key, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KycBriefTile(
      title: "No Kyc Data Found",
      model: model,
      trailing: Icon(
        Icons.rotate_left,
        color: Colors.amber,
      ),
    );
  }
}
