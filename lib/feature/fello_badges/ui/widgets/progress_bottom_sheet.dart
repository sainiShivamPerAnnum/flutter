import 'package:felloapp/util/extensions/rich_text_extension.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProgressBottomSheet extends StatelessWidget {
  const ProgressBottomSheet(
      {required this.title,
      required this.description,
      required this.badgeUrl,
      required this.buttonText,
      required this.onButtonPressed,
      super.key});

  final String title;
  final String description;
  final String badgeUrl;
  final String buttonText;
  final VoidCallback onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: SizeConfig.padding16, horizontal: SizeConfig.padding52),
      decoration: BoxDecoration(
        color: const Color(0xff39393C),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(SizeConfig.padding16),
          topRight: Radius.circular(SizeConfig.padding16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: SizeConfig.padding100,
            height: SizeConfig.padding4,
            decoration: BoxDecoration(
              color: const Color(0xFFD9D9D9).withOpacity(0.4),
              borderRadius: BorderRadius.circular(SizeConfig.padding4),
            ),
          ),
          SizedBox(
            height: SizeConfig.padding24,
          ),
          SvgPicture.network(
            badgeUrl,
            width: SizeConfig.padding132,
            height: SizeConfig.padding132,
          ),
          SizedBox(
            height: SizeConfig.padding16,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyles.rajdhaniSB.title4.colour(
              Colors.white,
            ),
          ),
          SizedBox(
            height: SizeConfig.padding4,
          ),
          description.beautify(
            style: TextStyles.sourceSans.body3.colour(
              const Color(0xFFBDBDBE),
            ),
            boldStyle: TextStyles.sourceSansSB.body3.colour(
              const Color(0xFFBDBDBE),
            ),
            alignment: TextAlign.center,
          ),
          SizedBox(
            height: SizeConfig.padding36,
          ),
          MaterialButton(
            onPressed: onButtonPressed,
            color: Colors.white,
            minWidth: SizeConfig.padding100,
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.padding60,
                vertical: SizeConfig.padding12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(SizeConfig.roundness5),
            ),
            height: SizeConfig.padding34,
            child: Text(
              buttonText,
              style: TextStyles.rajdhaniB.body3.colour(Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
