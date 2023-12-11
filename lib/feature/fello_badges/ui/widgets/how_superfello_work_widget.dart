import 'package:felloapp/core/model/fello_badges_model.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class HowSuperFelloWorksWidget extends StatefulWidget {
  const HowSuperFelloWorksWidget({
    required this.superFelloWorks,
    super.key,
    this.isBoxOpen = true,
  });

  final bool isBoxOpen;
  final SuperFelloWorks superFelloWorks;

  @override
  State<HowSuperFelloWorksWidget> createState() =>
      _HowSuperFelloWorksWidgetState();
}

class _HowSuperFelloWorksWidgetState extends State<HowSuperFelloWorksWidget> {
  bool _isBoxOpen = false;

  @override
  void initState() {
    super.initState();
    _isBoxOpen = widget.isBoxOpen;
  }

  void _toggle() {
    setState(() {
      _isBoxOpen = !_isBoxOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final subText = widget.superFelloWorks.subText;
    const duration = Duration(
      milliseconds: 300,
    );
    const curve = Curves.ease;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding24,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding12,
        vertical: SizeConfig.padding4,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment(-0.01, 1.00),
          end: Alignment(0.01, -1),
          colors: [Color(0xFF3A393C), Color(0xFF232326)],
        ),
        borderRadius: BorderRadius.circular(SizeConfig.roundness12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: _toggle,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: SizeConfig.padding8,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Container(
                    margin: EdgeInsets.only(left: SizeConfig.padding36),
                    child: Text(
                      widget.superFelloWorks.mainText,
                      style: TextStyles.rajdhaniSB.body1,
                    ),
                  ),
                  const Spacer(),
                  AnimatedRotation(
                    curve: curve,
                    duration: duration,
                    turns: _isBoxOpen ? .5 : 0,
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ClipRRect(
            child: AnimatedAlign(
              duration: duration,
              curve: curve,
              alignment: Alignment.topCenter,
              heightFactor: _isBoxOpen ? 1 : 0,
              child: Padding(
                padding: EdgeInsets.only(
                  top: SizeConfig.padding20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i = 0; i < subText.length; i++)
                      _BadgeInformationItem(
                        subText: subText[i],
                        showDivider: i != subText.length - 1,
                      ),
                    SizedBox(
                      height: SizeConfig.padding16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeInformationItem extends StatelessWidget {
  const _BadgeInformationItem({
    required this.subText,
    this.showDivider = false,
  });

  final String subText;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          subText,
          textAlign: TextAlign.center,
          style: TextStyles.sourceSans.body2.colour(
            Colors.white,
          ),
        ),
        if (showDivider) ...[
          SizedBox(
            height: SizeConfig.padding8,
          ),
          const _DottedLine(),
        ]
      ],
    );
  }
}

class _DottedLine extends StatelessWidget {
  const _DottedLine();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 24,
      child: CustomPaint(
        painter: VerticalDashPainter(
          color: UiConstants.kTealTextColor,
        ),
      ),
    );
  }
}

class VerticalDashPainter extends CustomPainter {
  final double dashHeight;
  final double dashWidth;
  final double dashSpace;
  final Color color;

  const VerticalDashPainter({
    this.dashHeight = 3,
    this.dashWidth = 1,
    this.dashSpace = 2,
    this.color = Colors.grey,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double startY = 0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = dashWidth;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant VerticalDashPainter oldDelegate) =>
      oldDelegate.dashHeight != dashHeight ||
      oldDelegate.dashWidth != dashWidth ||
      oldDelegate.dashSpace != dashSpace ||
      oldDelegate.color != color;
}
