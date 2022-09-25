import 'package:felloapp/ui/pages/hometabs/save/save_view.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class SaveAssetsFooter extends StatelessWidget {
  const SaveAssetsFooter({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.padding24),
      child: Column(
        children: [
          Text(
            '100% SAFE AND SECURED',
            style: TextStyles.sourceSans.body3.colour(UiConstants.kTextColor2),
          ),
          SizedBox(
            height: SizeConfig.padding20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding54),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SaveInfoSection(
                    title: 'In Compliance with',
                    imageAsset: Assets.sebiLogo,
                    imageHeight: SizeConfig.screenWidth * 0.07,
                    imageWidth: SizeConfig.screenWidth * 0.07,
                  ),
                  VerticalDivider(
                    color: Colors.white,
                    thickness: 0.2,
                    width: 10,
                    indent: 2,
                    endIndent: 2,
                  ),
                  SaveInfoSection(
                    title: 'RBI Approved',
                    imageAsset: Assets.rbiLogo,
                    imageHeight: SizeConfig.screenWidth * 0.07,
                    imageWidth: SizeConfig.screenWidth * 0.07,
                  ),
                  VerticalDivider(
                    color: Colors.white,
                    thickness: 0.2,
                    width: 10,
                    indent: 2,
                    endIndent: 2,
                  ),
                  SaveInfoSection(
                    title: 'Banking Partner',
                    imageAsset: Assets.iciciLogo,
                    imageHeight: SizeConfig.screenWidth * 0.07,
                    imageWidth: SizeConfig.screenWidth * 0.16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
