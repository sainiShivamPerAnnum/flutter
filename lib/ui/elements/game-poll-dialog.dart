import 'dart:ui';

import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GamePoll extends StatefulWidget {
  @override
  _GamePollState createState() => _GamePollState();
}

class _GamePollState extends State<GamePoll> {
  bool isVoted = false;
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        child: dialogContent(context),
      ),
    );
  }

  dialogContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        gradient: new LinearGradient(
          colors: [
            UiConstants.primaryColor,
            Color(0xff355C7D),
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      height: SizeConfig.screenHeight * 0.5,
      padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
      child: Column(
        children: [
          SizedBox(height: 20),
          Text(
            "What will be our next game ??",
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: SizeConfig.largeTextSize,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: SizeConfig.screenHeight * 0.04,
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: pollItemList.length,
              itemBuilder: (ctx, i) {
                return ListTile(
                  // height: SizeConfig.screenHeight * 0.08,
                  // width: double.infinity,
                  // padding: EdgeInsets.symmetric(
                  //   vertical: SizeConfig.blockSizeVertical * 2,
                  //   horizontal: SizeConfig.screenHeight * 0.02,
                  // ),
                  title: Text(
                    pollItemList[i].name,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: SizeConfig.mediumTextSize,
                    ),
                  ),
                  trailing: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.blockSizeHorizontal * 4,
                        vertical: SizeConfig.blockSizeHorizontal * 2),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isVoted = true;
                        });
                      },
                      child: Text(
                        isVoted
                            ? (pollItemList[i].votes * 100).toString()
                            : "Vote",
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: SizeConfig.mediumTextSize,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Text(
            "Just Tap on your favourite",
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: SizeConfig.smallTextSize,
            ),
          )
        ],
      ),
    );
  }
}

class PollItem {
  final String name;
  final double votes;

  PollItem({this.name, this.votes});
}

List<PollItem> pollItemList = [
  PollItem(name: "Ludo", votes: 0.4),
  PollItem(name: "Snake and ladder", votes: 0.2),
  PollItem(name: "Spin Wheel", votes: 0.3),
  PollItem(name: "BB", votes: 0.1),
];
