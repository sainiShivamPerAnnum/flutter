import 'package:felloapp/util/fundPalettes.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FundAppBar extends StatelessWidget {
  final String backgroundImage, title, logo;

  FundAppBar({this.backgroundImage, this.logo, this.title});
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: SizeConfig.screenHeight * 0.2,
      floating: false,
      pinned: true,
      backgroundColor: augmontGoldPalette.secondaryColor,
      iconTheme: IconThemeData(color: Colors.white),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(logo, height: kToolbarHeight * 0.4),
            SizedBox(width: 5),
            FittedBox(
              child: Text(
                title,
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        background: Image.network(
          backgroundImage,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
