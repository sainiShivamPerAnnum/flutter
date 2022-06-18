import 'package:felloapp/ui/pages/hometabs/journey/journey_vm.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';

class Background extends StatefulWidget {
  const Background({
    Key key,
  }) : super(key: key);

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
        height: JourneyPageViewModel.currentFullViewHeight,
        width: SizeConfig.screenWidth,
        child: Column(
          children: List.generate(
            JourneyPageViewModel.pageCount,
            (mlIndex) => Image.asset(
              "assets/custompathassets/bg.png",
              // color: Colors.grey,
              fit: BoxFit.cover,
              width: JourneyPageViewModel.pageWidth,
              height: JourneyPageViewModel.pageHeight,
            ),
          ),
        ),
      ),
    );
  }
}
