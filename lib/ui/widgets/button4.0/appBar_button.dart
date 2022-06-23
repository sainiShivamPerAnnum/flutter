import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarButton extends StatelessWidget {
  final String svgAsset, coin;
  final Color borderColor;
  final double screenWidth;
  final VoidCallback onTap;
  final TextStyle style;
  const AppBarButton({
    this.svgAsset,
    this.coin,
    this.borderColor,
    this.screenWidth,
    this.onTap,
    this.style,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 8.0),
      width: screenWidth,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
      onTap: onTap,

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SvgPicture.asset(
              svgAsset,
            ),
            Text(
              coin,
              style: style,
            ),
          ],
        ),
      ),
    );
  }
}
