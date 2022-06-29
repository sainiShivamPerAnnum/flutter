import 'package:felloapp/ui/pages/hometabs/journey/journey_vm.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Background extends StatefulWidget {
  final JourneyPageViewModel model;
  const Background({Key key, this.model}) : super(key: key);

  @override
  State<Background> createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {
  double bgZoom = 1.5;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        bgZoom = 1;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      alignment: Alignment.center,
      duration: const Duration(seconds: 3),
      curve: Curves.easeOutCubic,
      scale: bgZoom,
      child: SizedBox(
        height: widget.model.currentFullViewHeight,
        width: SizeConfig.screenWidth,
        child: Column(
          children: List.generate(
            widget.model.pageCount,
            (mlIndex) => SvgPicture.asset(
              "assets/journey/bg.svg",
              // color: Colors.grey,
              fit: BoxFit.cover,
              width: widget.model.pageWidth,
              height: widget.model.pageHeight,
            ),
          ),
        ),
      ),
    );
  }
}
