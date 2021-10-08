import 'package:felloapp/util/palette.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:flutter/material.dart';

class MarqueeText extends StatelessWidget {
  final List<String> infoList;
  final Color bulletColor, textColor;
  final showBullet;

  const MarqueeText({
    @required this.infoList,
    this.bulletColor,
    @required this.showBullet,
    this.textColor,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: SizeConfig.globalMargin, vertical: 16),
      child: MarqueeWidget(
        pauseDuration: Duration(seconds: 1),
        animationDuration: Duration(seconds: 2),
        backDuration: Duration(seconds: 2),
        direction: Axis.horizontal,
        child: Row(
          children: List.generate(
            infoList.length,
            (index) => Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  showBullet
                      ? CircleAvatar(
                          radius: SizeConfig.mediumTextSize / 4,
                          backgroundColor: bulletColor ??
                              FelloColorPalette.augmontFundPalette()
                                  .primaryColor,
                        )
                      : SizedBox(),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    infoList[index],
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: textColor ??
                          FelloColorPalette.augmontFundPalette().secondaryColor,
                      fontSize: SizeConfig.mediumTextSize,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MarqueeWidget extends StatefulWidget {
  final Widget child;
  final Axis direction;
  final Duration animationDuration, backDuration, pauseDuration;

  MarqueeWidget({
    @required this.child,
    this.direction: Axis.horizontal,
    this.animationDuration: const Duration(milliseconds: 3000),
    this.backDuration: const Duration(milliseconds: 800),
    this.pauseDuration: const Duration(milliseconds: 800),
  });

  @override
  _MarqueeWidgetState createState() => _MarqueeWidgetState();
}

class _MarqueeWidgetState extends State<MarqueeWidget> {
  ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController(initialScrollOffset: 50.0);
    WidgetsBinding.instance.addPostFrameCallback(scroll);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: widget.child,
      scrollDirection: widget.direction,
      controller: scrollController,
    );
  }

  void scroll(_) async {
    while (scrollController.hasClients) {
      await Future.delayed(widget.pauseDuration);
      if (scrollController.hasClients)
        await scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: widget.animationDuration,
            curve: Curves.ease);
      await Future.delayed(widget.pauseDuration);
      if (scrollController.hasClients)
        await scrollController.animateTo(0.0,
            duration: widget.backDuration, curve: Curves.easeOut);
    }
  }
}
