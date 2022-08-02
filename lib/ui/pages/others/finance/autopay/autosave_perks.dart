import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AutosavePerks extends StatelessWidget {
  final String image;
  final String svg;
  final String text;

  AutosavePerks({this.image, @required this.text, this.svg});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: SizeConfig.padding12),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                // border: Border.all(color: UiConstants.tertiarySolid, width: 1),
                shape: BoxShape.circle,
                color: Colors.white),
            padding: EdgeInsets.all(SizeConfig.padding4),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                backgroundColor: UiConstants.tertiaryLight,
                child: image != null
                    ? Image.asset(
                        image,
                        height: SizeConfig.padding16,
                      )
                    : SvgPicture.asset(
                        svg,
                        height: SizeConfig.padding16,
                      ),
                radius: SizeConfig.padding16,
              ),
            ),
          ),
          SizedBox(height: SizeConfig.padding4),
          Container(
            alignment: Alignment.center,
            child: Text(
              text,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyles.body4,
            ),
          )
        ],
      ),
    );
  }
}
