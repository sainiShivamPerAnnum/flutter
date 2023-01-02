import 'package:felloapp/ui/pages/hometabs/save/save_view.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SaveAssetsFooter extends StatelessWidget {
  const SaveAssetsFooter({Key? key}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    S locale = locator<S>();
    return Padding(
      padding: EdgeInsets.only(
          left: SizeConfig.pageHorizontalMargins,
          right: SizeConfig.pageHorizontalMargins,
          top: SizeConfig.padding6,
          bottom: SizeConfig.padding20),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SaveInfoSection(
              title: locale.govtAcc,
              imageAsset: Assets.augmontLogo,
              imageHeight: SizeConfig.screenWidth! * 0.07,
              imageWidth: SizeConfig.screenWidth! * 0.16,
            ),
            VerticalDivider(
              color: Colors.white,
              thickness: 0.2,
              width: 10,
              indent: 2,
              endIndent: 2,
            ),
            SaveInfoSection(
              title: locale.rbiCertified,
              imageAsset: Assets.lendboxLogo,
              imageHeight: SizeConfig.screenWidth! * 0.07,
              imageWidth: SizeConfig.screenWidth! * 0.16,
            ),
            VerticalDivider(
              color: Colors.white,
              thickness: 0.2,
              width: 10,
              indent: 2,
              endIndent: 2,
            ),
            SaveInfoSection(
              title: locale.trustedBy,
              imageAsset: Assets.rbiLogo,
              imageHeight: SizeConfig.screenWidth! * 0.07,
              imageWidth: SizeConfig.screenWidth! * 0.16,
            ),
          ],
        ),
      ),
    );
  }
}

class SaveInfoSection extends StatelessWidget {
  final String? title;
  final String? imageAsset;
  final double? imageHeight;
  final double? imageWidth;

  const SaveInfoSection(
      {Key? key,
      this.title,
      this.imageAsset,
      this.imageHeight,
      this.imageWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title ?? '',
            style: TextStyles.sourceSans.body4.colour(UiConstants.kTextColor2),
          ),
          SizedBox(
            height: SizeConfig.padding6,
          ),
          SizedBox(
            height: imageHeight ?? 0,
            width: imageWidth ?? 0,
            child: SvgPicture.asset(
              imageAsset ?? '',
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
