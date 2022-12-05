import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';

class SaveBanner extends StatelessWidget {
  const SaveBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.screenHeight! * 0.04,
      width: SizeConfig.screenWidth,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 9,
            child: Container(
              height: double.infinity,
              alignment: Alignment.centerLeft,
              color: Color(0xff289379),
              child: RichText(
                text: TextSpan(
                  text: "Happy Hour ending in",
                  style: TextStyles.sourceSans.body3.colour(Colors.white),
                  children: [
                    TextSpan(
                        text: "09 : 04 mins",
                        style:
                            TextStyles.sourceSansB.body3.colour(Colors.white))
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: double.infinity,
              child: Icon(
                Icons.info_outline,
                color: Colors.white,
              ),
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

