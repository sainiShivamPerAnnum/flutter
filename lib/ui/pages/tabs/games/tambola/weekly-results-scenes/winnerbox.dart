import 'package:felloapp/util/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WinnerBox extends StatelessWidget {
  final Map<String, int> winningsmap;

  const WinnerBox({Key key, this.winningsmap}) : super(key: key);
  getValue(int val) {
    switch (val) {
      case 0:
        return "Corners";
        break;
      case 1:
        return "Top Row";
        break;
      case 2:
        return "Bottom Row";
        break;
      case 3:
        return "Middle Row";
        break;
      case 4:
        return "Full House";
        break;
    }
  }

  getWinningTicketTiles() {
    List<ListTile> ticketTiles = [];
    winningsmap.forEach((key, value) {
      ticketTiles.add(ListTile(
        leading: Text("#$key"),
        trailing: Text(getValue(value)),
      ));
    });
    return ticketTiles;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight / 2.5,
      width: SizeConfig.screenWidth,
      margin: EdgeInsets.symmetric(vertical: 20),
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Text(
              "Winning Tickets",
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  height: 1.5,
                  letterSpacing: 2),
            ),
          ),
          Divider(),
          Expanded(
            child: ListView(children: getWinningTicketTiles()),
          )
        ],
      ),
    );
  }
}
