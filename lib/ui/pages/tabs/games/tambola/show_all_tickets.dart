import 'package:felloapp/ui/elements/tambola-global/tambola_ticket.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowAllTickets extends StatelessWidget {
  final List<Ticket> tambolaBoardView;
  ShowAllTickets({Key key, this.tambolaBoardView}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: UiConstants.primaryColor,
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
