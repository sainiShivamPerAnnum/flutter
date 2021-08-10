import 'package:felloapp/ui/elements/tambola_board_view.dart';
import 'package:felloapp/ui/pages/tabs/games/tambola/tambola-home.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowAllTickets extends StatelessWidget {
  final List<Ticket> tambolaBoardView;
  ShowAllTickets({Key key, this.tambolaBoardView}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF0F0CB),
      appBar: AppBar(
        backgroundColor: Color(0xff086972),
        elevation: 2,
        shadowColor: Color(0xff086972).withOpacity(0.5),
        title: Text(
          "All Tickets",
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              Container(
                height: SizeConfig.screenWidth * 0.94 * 2,
                width: SizeConfig.screenWidth,
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: tambolaBoardView.length,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 10, crossAxisCount: 2),
                  itemBuilder: (ctx, i) => Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: tambolaBoardView[i],
                  ),
                  // [
                  // Ticket(
                  //   odds: odds,
                  //   bgColor: Color(0xff0C9463),
                  //   boardColorEven: Color(0xff09744D),
                  //   boardColorOdd: Colors.white,
                  //   boradColorMarked: Color(0xffFFD56B),

                  // ),
                  // Ticket(
                  //   odds: odds,
                  //   bgColor: Color(0xffD6C481),
                  //   boardColorEven: Color(0xffC7B36C),
                  //   boardColorOdd: Colors.white,
                  //   boradColorMarked: Color(0xffE76F51),
                  // ),
                  // Ticket(
                  //   odds: odds,
                  //   bgColor: Color(0xffEA907A),
                  //   boardColorEven: Color(0xffC56E58),
                  //   boardColorOdd: Colors.white,
                  //   boradColorMarked: Color(0xffFFD56B),
                  // ),
                  // Ticket(
                  //   odds: odds,
                  //   bgColor: Color(0xff445C3C),
                  //   boardColorEven: Color(0xffC9D99E),
                  //   boardColorOdd: Color(0xffFAE8C8),
                  //   boradColorMarked: Color(0xffFDA77F),
                  // ),
                  // Ticket(
                  //   odds: odds,
                  //   bgColor: Color(0xffD6C481),
                  //   boardColorEven: Color(0xffC7B36C),
                  //   boardColorOdd: Colors.white,
                  //   boradColorMarked: Color(0xffE76F51),
                  // ),
                  // Ticket(
                  //   odds: odds,
                  //   bgColor: Color(0xff445C3C),
                  //   boardColorEven: Color(0xffC9D99E),
                  //   boardColorOdd: Color(0xffFAE8C8),
                  //   boradColorMarked: Color(0xffFDA77F),
                  // ),
                  //],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
