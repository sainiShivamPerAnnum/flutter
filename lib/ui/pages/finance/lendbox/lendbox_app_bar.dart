import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';

class LendBoxAppBar extends StatelessWidget {
  final bool isEnabled;
  final Function? trackClosingEvent;
  final bool isOldUser;
  final String assetType;

  const LendBoxAppBar(
      {required this.isEnabled,
      required this.isOldUser,
      required this.assetType,
      super.key,
      this.trackClosingEvent});

  String getTitle() {
    if (assetType == Constants.ASSET_TYPE_FLO_FELXI && isOldUser) {
      return '10% Flo';
    } else if (assetType == Constants.ASSET_TYPE_FLO_FELXI && !isOldUser) {
      return '8% Flo';
    }

    if (assetType == Constants.ASSET_TYPE_FLO_FIXED_3) {
      return '10% Flo';
    }

    if (assetType == Constants.ASSET_TYPE_FLO_FIXED_6) {
      return '12% Flo';
    }

    return 'Fello Flo';
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: !isEnabled
          ? const SizedBox()
          : Container(
              margin: EdgeInsets.only(left: SizeConfig.padding16),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios,
                    color: Colors.white.withOpacity(0.4)),
                onPressed: () {
                  if (trackClosingEvent != null) trackClosingEvent!();
                },
              ),
            ),
      // leadingWidth: SizeConfig.screenWidth! * 0.1,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            Assets.felloFlo,
            width: SizeConfig.screenWidth! * 0.148,
            height: SizeConfig.screenWidth! * 0.148,
          ),
          // SizedBox(width: SizeConfig.padding8),
          Text(
            getTitle(),
            style: TextStyles.rajdhaniSB.title5,
          ),
        ],
      ),
      centerTitle: true,
    );
  }
}
