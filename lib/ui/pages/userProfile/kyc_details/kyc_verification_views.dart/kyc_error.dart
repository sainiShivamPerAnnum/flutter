import 'package:felloapp/ui/pages/userProfile/kyc_details/kyc_details_view_new.dart';
import 'package:felloapp/ui/pages/userProfile/kyc_details/kyc_details_vm.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';

class NoKycView extends StatelessWidget {
  final KYCDetailsViewModel model;

  const NoKycView({required this.model, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final S locale = S.of(context);
    return KycBriefTile(
      title: locale.noKYCfound,
      label: locale.refreshKYC,
      model: model,
      trailing: Padding(
        padding: EdgeInsets.only(right: SizeConfig.padding8),
        child: IconButton(
          onPressed: model.init,
          icon: const Icon(
            Icons.rotate_left,
            color: Colors.amber,
          ),
        ),
      ),
    );
  }
}
