import 'package:felloapp/ui/pages/hometabs/play/play_components/play_title.dart';
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
    @required this.onStateChanged,
    Key key,
  }) : super(key: key);

  String heading;
  List<String> assetList;
  List<String> titleList;
  Function onStateChanged;

  @override
  State<InfoComponent> createState() => _InfoComponentState();
}

class _InfoComponentState extends State<InfoComponent> {
  bool isBoxOpen = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        setState(() {
          isBoxOpen = true;
        });
      });
    });
    super.initState();
  }

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

              Future.delayed(const Duration(milliseconds: 200), () {
                widget.onStateChanged();
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

class InfoComponent2 extends StatefulWidget {
  InfoComponent2({
    @required this.heading,
    @required this.assetList,
    @required this.titleList,
    @required this.height,
    Key key,
  }) : super(key: key);

  String heading;
  List<String> assetList;
  List<String> titleList;
  double height;

  @override
  State<InfoComponent2> createState() => _InfoComponent2State();
}

class _InfoComponent2State extends State<InfoComponent2> {
  double heightOfObject = SizeConfig.screenWidth * 0.3;

  bool isOpen = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: SizeConfig.pageHorizontalMargins,
            right: SizeConfig.pageHorizontalMargins,
            top: SizeConfig.pageHorizontalMargins,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.heading,
                style: TextStyles.rajdhaniSB.body0,
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    isOpen = !isOpen;
                  });
                },
                icon: Icon(
                  isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
        AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          child: isOpen
              ? Container(
                  height: widget.height + SizeConfig.padding80,
                  margin: EdgeInsets.symmetric(
                      vertical: SizeConfig.pageHorizontalMargins),
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    itemCount: widget.assetList.length,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  left: index == 0
                                      ? SizeConfig.pageHorizontalMargins
                                      : 0.0,
                                  right: index == widget.assetList.length - 1
                                      ? SizeConfig.pageHorizontalMargins
                                      : 0.0,
                                ),
                                height: heightOfObject,
                                width: heightOfObject,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.7),
                                      width: 0.5),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    widget.assetList[index],
                                    width: heightOfObject / 2.5,
                                  ),
                                ),
                              ),
                              if (index != widget.assetList.length - 1)
                                Container(
                                  width: SizeConfig.padding44,
                                  height: 0.5,
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.7)),
                                )
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              top: SizeConfig.padding14,
                              left: index == 0
                                  ? SizeConfig.pageHorizontalMargins
                                  : 0.0,
                              right: index == widget.assetList.length - 1
                                  ? SizeConfig.pageHorizontalMargins
                                  : 0.0,
                            ),
                            width: heightOfObject,
                            child: Text(
                              widget.titleList[index],
                              textAlign: TextAlign.center,
                              style: TextStyles.sourceSans.body4
                                  .colour(UiConstants.kTextColor2),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                )
              : SizedBox.shrink(),
        ),
      ],
    );
  }
}
