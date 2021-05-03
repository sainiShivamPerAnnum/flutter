import 'package:felloapp/base_util.dart';
import 'package:felloapp/ui/elements/tambola_board_view.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TambolaCardsList extends StatelessWidget {
  final List<TambolaBoardView> tambolaBoardView;

  TambolaCardsList({this.tambolaBoardView});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: UiConstants.primaryColor,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            "My Tambola Cards",
            style: GoogleFonts.montserrat(
                color: Colors.white, fontWeight: FontWeight.w500),
          )),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView.builder(
            itemCount: tambolaBoardView.length,
            itemBuilder: (ctx, i) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: tambolaBoardView[i],
              );
            }),
      ),
    );
  }
}
