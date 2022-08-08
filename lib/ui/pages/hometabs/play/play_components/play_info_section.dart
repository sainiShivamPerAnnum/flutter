import 'package:felloapp/ui/pages/hometabs/play/play_components/titlesGames.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../util/styles/ui_constants.dart';

class InfoComponent extends StatefulWidget {
  InfoComponent({
    @required this.heading,
    @required this.assetList,
    @required this.titleList,
    Key key,
  }) : super(key: key);

  String heading;
  List<String> assetList;
  List<String> titleList;

  @override
  State<InfoComponent> createState() => _InfoComponentState();
}

class _InfoComponentState extends State<InfoComponent> {
  bool isBoxOpen = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      // height: SizeConfig.screenWidth * 0.184,
      margin: EdgeInsets.all(SizeConfig.padding24),
      decoration: BoxDecoration(
        color: UiConstants.kDarkBoxColor,
        borderRadius: BorderRadius.circular(SizeConfig.roundness8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: SizeConfig.padding20,
          ),
          TextButton(
            onPressed: () {
              //Chaning the state of the box on click
              setState(() {
                isBoxOpen = !isBoxOpen;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.heading,
                  style: TextStyles.rajdhaniSB.title5,
                ),
                SizedBox(
                  width: SizeConfig.padding24,
                ),
                Icon(
                  isBoxOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          SizedBox(
            height: SizeConfig.padding20,
          ),
          isBoxOpen
              ? Column(
                  children: [
                    SizedBox(
                      height: SizeConfig.padding20,
                    ),
                    TitlesGames(
                      richText: RichText(
                        text: TextSpan(
                          text: widget.titleList[0],
                          style: TextStyles.sourceSans.body3,
                        ),
                      ),
                      icon: SvgPicture.asset(
                        widget.assetList[0],
                        height: SizeConfig.padding54,
                        width: SizeConfig.padding54,
                      ),
                    ),
                    TitlesGames(
                      richText: RichText(
                        text: TextSpan(
                          text: widget.titleList[1],
                          style: TextStyles.sourceSans.body3,
                        ),
                      ),
                      icon: SvgPicture.asset(
                        widget.assetList[1],
                        height: SizeConfig.padding54,
                        width: SizeConfig.padding54,
                      ),
                    ),
                    TitlesGames(
                      richText: RichText(
                        text: TextSpan(
                          text: widget.titleList[2],
                          style: TextStyles.sourceSans.body3,
                        ),
                      ),
                      icon: Padding(
                        padding: EdgeInsets.only(top: SizeConfig.padding4),
                        child: SvgPicture.asset(
                          widget.assetList[2],
                          height: SizeConfig.padding40,
                          width: SizeConfig.padding40,
                        ),
                      ),
                      isLast: true,
                    ),
                    SizedBox(
                      height: SizeConfig.padding40,
                    ),
                  ],
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
