import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';

class GoldenTicketView extends StatelessWidget {
  const GoldenTicketView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: Center(
        child: Hero(
          tag: '0',
          child: Container(
            width: SizeConfig.screenWidth / 2,
            margin: EdgeInsets.only(left: SizeConfig.pageHorizontalMargins),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/gticket.png"),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
