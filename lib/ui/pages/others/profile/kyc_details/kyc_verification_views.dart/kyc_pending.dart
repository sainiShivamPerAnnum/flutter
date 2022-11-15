import 'package:felloapp/ui/pages/others/profile/kyc_details/kyc_details_view.dart';
import 'package:felloapp/ui/pages/others/profile/kyc_details/kyc_details_vm.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class KycInProcessView extends StatelessWidget {
  final KYCDetailsViewModel model;
  const KycInProcessView({Key key, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.padding20,
      ),
      decoration: BoxDecoration(
        color: UiConstants.kBackgroundColor3,
        borderRadius: BorderRadius.circular(SizeConfig.roundness8),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(SizeConfig.padding12),
            width: SizeConfig.avatarRadius * 4,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              shape: BoxShape.circle,
              color: Colors.black,
            ),
            child: SvgPicture.asset(
              Assets.ic_upload_success,
            ),
          ),
          Expanded(
            child: Text(
              "PAN3948.png",
              style: TextStyles.sourceSansSB.body2.colour(Colors.white),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(SizeConfig.roundness5),
                border: Border.all(width: 2, color: UiConstants.tertiarySolid)),
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.padding12,
              vertical: SizeConfig.padding4,
            ),
            margin: EdgeInsets.only(right: SizeConfig.padding12),
            child: Text(
              "IN PROCESS",
              style:
                  TextStyles.rajdhaniSB.body2.colour(UiConstants.tertiarySolid),
            ),
          ),
        ],
      ),
    );
  }
}
