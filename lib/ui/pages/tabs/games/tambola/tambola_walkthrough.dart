import 'package:felloapp/util/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Walkthrough extends StatelessWidget {
  const Walkthrough({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0C9463),
        elevation: 2,
        shadowColor: Color(0xff0C9463).withOpacity(0.5),
        title: Text(
          "Walkthrough",
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Color(0xffF0F0CB),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                "Daily Picks",
                style: GoogleFonts.montserrat(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Image.asset(
              "images/Tambola/roulette.png",
              width: SizeConfig.screenWidth,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: List.generate(
                  3,
                  (index) => Container(
                    height: 40,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 4,
                          backgroundColor: Colors.black,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "lorem ipsum dohre minjari dashdiru dd",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                "Tambola tickets",
                style: GoogleFonts.montserrat(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Image.asset(
              "images/Tambola/ticket.png",
              width: SizeConfig.screenWidth,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: List.generate(
                  3,
                  (index) => Container(
                    height: 40,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 4,
                          backgroundColor: Colors.black,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "lorem ipsum dohre minjari dashdiru dd",
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
    );
  }
}
