import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';

class LendBoxAppBar extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback trackClosingEvent;
  final String assetName;

  const LendBoxAppBar({
    required this.isEnabled,
    required this.trackClosingEvent,
    required this.assetName,
    super.key,
  });

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
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white.withOpacity(0.4),
                ),
                onPressed: trackClosingEvent,
              ),
            ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            Assets.felloFlo,
            width: SizeConfig.screenWidth! * 0.148,
            height: SizeConfig.screenWidth! * 0.148,
          ),
          Text(
            assetName,
            style: TextStyles.rajdhaniSB.title5,
          ),
        ],
      ),
      centerTitle: true,
    );
  }
}
