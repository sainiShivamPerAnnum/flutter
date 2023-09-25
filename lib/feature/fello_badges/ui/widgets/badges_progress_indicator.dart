import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class BadgesProgressIndicator extends StatefulWidget {
  const BadgesProgressIndicator(
      {required this.level,
      required this.isSuperFello,
      required this.width,
      super.key});

  final int level;
  final bool isSuperFello;
  final double width;

  @override
  State<BadgesProgressIndicator> createState() =>
      _BadgesProgressIndicatorState();
}

class _BadgesProgressIndicatorState extends State<BadgesProgressIndicator> {
  double level0 = 0.1;
  double level1 = 0.0;
  double level2 = 0.0;

  void _updateProgress() {
    switch (widget.level) {
      case 2:
        setState(() {
          level0 = 1.0;
          level1 = 0.1;
        });
        break;
      case 3:
        setState(() {
          level0 = 1.0;
          level1 = 1.0;
          level2 = 0.1;
        });
        break;
    }
  }

  @override
  void initState() {
    super.initState();

    _updateProgress();
  }

  @override
  Widget build(BuildContext context) {
    return widget.level == 4
        ? const SizedBox.shrink()
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Container(
                    width: widget.width,
                    height: SizeConfig.padding6,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFD9D9D9).withOpacity(0.25),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: SizeConfig.padding6,
                    child: AnimatedContainer(
                      alignment: Alignment.bottomCenter,
                      width: level0 * (widget.width),
                      height: SizeConfig.padding6,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInExpo,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFF79780),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                      ),
                      // color: const Color(0xFFF79780),
                    ),
                  ),
                ],
              ),
              SizedBox(width: SizeConfig.padding2),
              Stack(
                children: [
                  Container(
                    width: widget.width,
                    height: SizeConfig.padding6,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFD9D9D9).withOpacity(0.25),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: SizeConfig.padding6,
                    child: AnimatedContainer(
                      alignment: Alignment.bottomCenter,
                      width: level1 * (widget.width),
                      height: SizeConfig.padding6,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInExpo,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF93B5FE),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                      ),
                      // color: const Color(0xFFF79780),
                    ),
                  ),
                ],
              ),
              SizedBox(width: SizeConfig.padding2),
              Stack(
                children: [
                  Container(
                    width: widget.width,
                    height: SizeConfig.padding6,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFD9D9D9).withOpacity(0.25),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: SizeConfig.padding6,
                    child: AnimatedContainer(
                      alignment: Alignment.bottomCenter,
                      width: level2 * (widget.width),
                      height: SizeConfig.padding6,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInExpo,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFFFD979),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                      ),
                      // color: const Color(0xFFF79780),
                    ),
                  ),
                ],
              ),
            ],
          );
  }
}
