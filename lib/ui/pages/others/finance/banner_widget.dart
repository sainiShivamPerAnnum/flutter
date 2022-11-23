import 'package:felloapp/core/model/asset_options_model.dart' as I;
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BannerWidget extends StatelessWidget {
  const BannerWidget({Key? key, required this.model}) : super(key: key);
  final I.Banner model;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: UiConstants.kModalSheetSecondaryBackgroundColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(5),
      ),
      margin:
          EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.padding8,
        horizontal: SizeConfig.padding12,
      ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: SizeConfig.padding32,
              width: SizeConfig.padding32,
              child: SvgPicture.network(
                model.image,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(width: SizeConfig.padding4),
            Flexible(
              child: Text(
                model.title,
                maxLines: 2,
                style:
                    TextStyles.sourceSans.body4.colour(UiConstants.kTextColor3),
              ),
            )
          ]),
    );
  }
}
