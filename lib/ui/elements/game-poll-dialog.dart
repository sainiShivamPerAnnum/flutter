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

  vote() {
    setState(() {
      isVoted = true;
    });
  }

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
            "Which game would you like to play?",
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
              fontSize: SizeConfig.largeTextSize,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: SizeConfig.screenHeight * 0.04,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GameTile(
                  isVoted: isVoted,
                  ontap: vote,
                  pollItem: pollItemList[0],
                ),
                GameTile(
                  isVoted: isVoted,
                  ontap: vote,
                  pollItem: pollItemList[1],
                ),
                GameTile(
                  isVoted: isVoted,
                  ontap: vote,
                  pollItem: pollItemList[2],
                ),
                GameTile(
                  isVoted: isVoted,
                  ontap: vote,
                  pollItem: pollItemList[3],
                ),
              ],
            ),
          ),
          SizedBox(
            height: SizeConfig.blockSizeVertical * 3,
            child: Center(
              child: Text(
                !isVoted
                    ? "Just Tap on your favourite"
                    : "Your Vote recorded. Thank you",
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: SizeConfig.smallTextSize,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class GameTile extends StatefulWidget {
  final bool isVoted;
  final PollItem pollItem;
  final Function ontap;
  GameTile({this.isVoted, this.pollItem, this.ontap});

  @override
  _GameTileState createState() => _GameTileState();
}

class _GameTileState extends State<GameTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.ontap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInSine,
        height: SizeConfig.screenHeight * 0.05,
        margin: EdgeInsets.symmetric(
          horizontal: SizeConfig.blockSizeHorizontal * 3,
        ),
        child: Stack(
          children: [
            // FractionallySizedBox(
            //   widthFactor: widget.isVoted ? widget.pollItem.votes : 1,
            //   heightFactor: 1,
            //child:
            AnimatedContainer(
              duration: Duration(milliseconds: 600),
              curve: Curves.easeInSine,
              width: widget.isVoted
                  ? SizeConfig.screenWidth * widget.pollItem.votes
                  : SizeConfig.screenWidth,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            // ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.pollItem.name,
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: SizeConfig.mediumTextSize,
                      ),
                    ),
                    Spacer(),
                    widget.isVoted
                        ? Text(
                            "${(widget.pollItem.votes * 100).toString()}%",
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: SizeConfig.mediumTextSize,
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            )
          ],
        ),
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
