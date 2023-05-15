import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../util/styles/styles.dart';

class CardsExpanded extends StatelessWidget {
  const CardsExpanded({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Color(0xff262629),
        elevation: 0,
      ),
      body: SafeArea(
        child: GestureDetector(
          onVerticalDragStart: (_) => Navigator.pop(context),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xff262629),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(SizeConfig.titleSize! / 2),
                bottomRight: Radius.circular(SizeConfig.titleSize! / 2),
              ),
            ),
            height: SizeConfig.screenWidth! * 1.85,
            width: SizeConfig.screenWidth!,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Transform.translate(
                    offset: Offset(0, SizeConfig.titleSize! / 2),
                    child: CircleAvatar(
                      backgroundColor: const Color(0xff262629),
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CardsExpanded(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.keyboard_arrow_up_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: SizeConfig.screenWidth! * 1.35,
                  child: Hero(
                    tag: "mainCard",
                    child: Card(
                      margin: EdgeInsets.zero,
                      color: const Color(0xFF627F8E).withOpacity(0.8),
                      child: SizedBox(
                        height: SizeConfig.screenWidth! * 0.4,
                        width: SizeConfig.screenWidth,
                        child: Column(
                          children: [],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  // right: SizeConfig.screenWidth! * 0.8 * 0.05 * 1,
                  top: SizeConfig.screenWidth! * 0.95,
                  child: Hero(
                    tag: "goldCard",
                    child: Card(
                      margin: EdgeInsets.zero,
                      color: Color(0XFF02484D).withOpacity(0.8),
                      child: SizedBox(
                        height: SizeConfig.screenWidth! * 0.4,
                        width: SizeConfig.screenWidth,
                        child: const Center(
                          child: Text(
                            'Card 3',
                            style: TextStyle(fontSize: 30.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  // right: SizeConfig.screenWidth! * 0.8 * 0.05 * 2,
                  top: SizeConfig.screenWidth! * 0.55,
                  child: Hero(
                    tag: "floCard",
                    child: Card(
                      margin: EdgeInsets.zero,
                      color: const Color(0xff39498C).withOpacity(0.8),
                      child: SizedBox(
                        height: SizeConfig.screenWidth! * 0.4,
                        width: SizeConfig.screenWidth,
                        child: Column(
                          children: [
                            Container(
                              color: const Color(0xff39498C),
                              height: SizeConfig.screenWidth! * 0.2,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  // right: SizeConfig.screenWidth! * 0.8 * 0.05 * 3,
                  top: 0,
                  child: Hero(
                    tag: "rewardCard",
                    child: Card(
                      margin: EdgeInsets.zero,
                      color: Colors.black.withOpacity(0.8),
                      child: Container(
                        padding: EdgeInsets.all(SizeConfig.titleSize! / 2),
                        height: SizeConfig.screenWidth! * 0.55,
                        width: SizeConfig.screenWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Fello Balance",
                              style: GoogleFonts.rajdhani(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize: SizeConfig.titleSize! * 0.6,
                              ),
                            ),
                            Text(
                              "Sum of all your assets on fello",
                              style: GoogleFonts.sourceSans3(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                                fontSize: SizeConfig.titleSize! * 0.4,
                              ),
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                Text(
                                  "₹ 1004",
                                  style: GoogleFonts.sourceSans3(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    fontSize: SizeConfig.titleSize! * 1.2,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_up_outlined,
                                  color: Colors.green,
                                  size: SizeConfig.titleSize,
                                ),
                                Text(
                                  "0.05%",
                                  style: GoogleFonts.sourceSans3(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.green,
                                    fontSize: SizeConfig.titleSize! * 0.4,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
