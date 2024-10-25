import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class HelpWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(SizeConfig.padding20),
      padding: EdgeInsets.only(
          top: SizeConfig.padding14,
          bottom: SizeConfig.padding14,
          left: SizeConfig.padding18,
          right: SizeConfig.padding18),
      decoration: BoxDecoration(
        color: Color(0xff2D3135),
        borderRadius: BorderRadius.circular(SizeConfig.roundness16),
      ),
      child: Row(
        children: [
          // Left side text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Need help?',
                  style: TextStyles.sourceSans.body6
                      .colour(UiConstants.primaryColor),
                ),
                // SizedBox(height: 8),
                Text('For more help contact us at: 1800-123-123455',
                    style: TextStyles.sourceSans.body2),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.only(
                        left: SizeConfig.padding12,
                        right: SizeConfig.padding12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text('Call Us Now',
                      style: TextStyles.sourceSansM.body4
                          .colour(UiConstants.textColor)),
                ),
              ],
            ),
          ),
          // Right side image
          SizedBox(
            width: 64,
            height: 64,
            child: Image.asset(
              Assets.help, // Path to your image asset
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
