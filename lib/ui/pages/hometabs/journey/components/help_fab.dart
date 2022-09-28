import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HelpFab extends StatefulWidget {
  const HelpFab({Key key}) : super(key: key);

  @override
  State<HelpFab> createState() => _HelpFabState();
}

class _HelpFabState extends State<HelpFab> {
  double width = SizeConfig.avatarRadius * 2.4;
  bool isOpen = false;
  expandFab() {
    setState(() {
      isOpen = true;
      width = SizeConfig.padding80;
    });
    Future.delayed(Duration(seconds: 5), () {
      collapseFab();
    });
  }

  collapseFab() {
    setState(() {
      isOpen = false;
      width = SizeConfig.avatarRadius * 2.4;
    });
  }

  @override
  void initState() {
    Future.delayed(Duration(seconds: 5), () {
      expandFab();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isOpen ? () {} : expandFab,
      child: AnimatedContainer(
          height: SizeConfig.avatarRadius * 2.4,
          duration: Duration(milliseconds: 600),
          width: this.width,
          curve: Curves.easeInOutCubic,
          margin: EdgeInsets.only(
              bottom: SizeConfig.navBarHeight + kBottomNavigationBarHeight),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: Colors.white, width: 1),
            color: Colors.black,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.translate(
                offset: Offset(0, SizeConfig.padding3),
                child: SvgPicture.asset(
                  Assets.winScreenReferalAsset,
                  height: SizeConfig.avatarRadius * 1.8,
                  width: SizeConfig.avatarRadius * 1.8,
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 600),
                curve: Curves.easeInOutCubic,
                width: isOpen ? SizeConfig.padding32 : 0,
                child: FittedBox(
                  child: Text(
                    " Help",
                    style: TextStyles.sourceSansSB.body3,
                  ),
                ),
              )
            ],
          )),
    );
  }
}
