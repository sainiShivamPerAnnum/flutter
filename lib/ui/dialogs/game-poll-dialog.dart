import 'dart:ui';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/connectivity_status.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/ui/elements/network_bar.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GamePoll extends StatefulWidget {
  @override
  _GamePollState createState() => _GamePollState();
}

class _GamePollState extends State<GamePoll> {
  bool isVoted = false;
  bool isLoading = true;
  DBModel dbProvider;
  BaseUtil baseProvider;
  Map<String, dynamic> pollDetails;
  int totalNoOfVotes = 0;
  int userVote;
  List<String> pollItems;

  ConnectivityStatus connectivityStatus;
  vote() {
    setState(() {
      isVoted = true;
    });
  }

  getPollDetails() async {
    // isLoading = true;
    if (baseProvider != null && dbProvider != null && isLoading == true) {
      print(baseProvider.myUser.uid);
      dbProvider.getPollCount().then((res) {
        pollDetails = res;
        pollDetails.forEach((key, value) {
          totalNoOfVotes += value;
        });
        pollItems = pollDetails.keys.toList();
        if (isLoading) {
          setState(() {
            isLoading = false;
          });
        }
      });
    }
  }

  double getPollPercentage(String item) {
    return (pollDetails[item] / totalNoOfVotes);
  }

  Future<void> addPollVote(String id) async {
    if (id == null || id.isEmpty || !id.startsWith('op_')) return;
    String indStr = id.substring(3);
    int index = 0;
    try {
      index = int.parse(indStr);
    } catch (e) {
      print('Index parsing failed');
    }
    dbProvider.addUserPollResponse(baseProvider.myUser.uid, index).then((flag) {
      if (!flag) {
        Map<String, dynamic> errorDetails = {
          'error_msg': 'Adding user poll response in game-poll-dialog failed'
        };
        dbProvider.logFailure(
            baseProvider.myUser.uid, FailType.GameVoteFailed, errorDetails);
        baseProvider.showNegativeAlert('Couldn\'t save response',
            'Please try again in some time', context);
      }
      setState(() {
        isVoted = flag;
      });
    });
  }

  Future<void> getPollResponse() async {
    dbProvider.getUserPollResponse(baseProvider.myUser.uid).then((response) {
      setState(() {
        userVote = response;
        if (response != null && response != -1) isVoted = true;
      });
    });
  }

  List<GameTile> createPollTiles() {
    List<GameTile> pollList = [];
    for (int i = 0; i < pollDetails.length; i++) {
      PollItem _item =
          PollItem.build(pollItems[i], getPollPercentage(pollItems[i]));
      pollList.add(GameTile(
        isVoted: isVoted,
        ontap: () {
          if (connectivityStatus == ConnectivityStatus.Offline) {
            baseProvider.showNoInternetAlert(context);
          } else if (!isVoted) {
            Haptic.vibrate();
            addPollVote(_item.id);
          }
        },
        pollItem: _item,
      ));
    }
    return pollList;
  }

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    dbProvider = Provider.of<DBModel>(context, listen: false);
    connectivityStatus = Provider.of<ConnectivityStatus>(context);

    if (pollDetails == null) {
      getPollDetails();
      getPollResponse();
    }

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
      height: SizeConfig.screenHeight * 0.6,
      padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
      child: Column(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "Which game would you like to play on Fello next?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: SizeConfig.largeTextSize,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: SizeConfig.screenHeight * 0.03,
          ),
          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: createPollTiles(),
                  ),
          ),
          SizedBox(
            height: SizeConfig.blockSizeVertical * 3,
            child: Center(
              child: Text(
                !isVoted
                    ? "Just Tap on your favourite"
                    : ((userVote != null && userVote != -1)
                        ? "You voted for ${_getPollItemName(userVote)}"
                        : "Your vote has been recorded thank you"),
                style: TextStyle(
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

  String _getPollItemName(int i) => PollItem.getName('op_$i');
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
        duration: Duration(milliseconds: 600),
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
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: SizeConfig.mediumTextSize,
                      ),
                    ),
                    Spacer(),
                    widget.isVoted
                        ? Text(
                            "${(widget.pollItem.votes * 100).round().toString()}%",
                            style: TextStyle(
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
  final String id;
  final String name;
  final double votes;

  PollItem(this.id, this.name, this.votes);

  PollItem.build(String id, double votes) : this(id, getName(id), votes);

  static getName(String id) {
    if (id == null || id.isEmpty || !id.startsWith('op_')) return 'Error';
    String indStr = id.substring(3);
    int index = 0;
    try {
      index = int.parse(indStr);
    } catch (e) {
      print('Index parsing failed');
    }
    return Assets.POLL_FOLLOW_UP_GAME_LIST[index - 1];
  }
}
