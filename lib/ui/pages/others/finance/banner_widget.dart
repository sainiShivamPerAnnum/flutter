import 'package:felloapp/core/model/asset_options_model.dart' as I;
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
      padding:
          EdgeInsets.symmetric(vertical: 8, horizontal: 4).copyWith(right: 24),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.network(
              model.image,
              height: 25,
              width: 25,
            ),
            SizedBox(
              width: 2,
            ),
            Flexible(
              child: Text(
                model.title,
                style:
                    TextStyles.sourceSans.body4.colour(UiConstants.kTextColor3),
              ),
            )
          ]),
    );
  }
}
