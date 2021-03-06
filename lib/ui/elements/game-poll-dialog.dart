import 'dart:ui';

import 'package:flutter/material.dart';

class GamePoll extends StatefulWidget {
  @override
  _GamePollState createState() => _GamePollState();
}

class _GamePollState extends State<GamePoll> {
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
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        children: [
          Text("What will be our next game ??"),
        ],
      ),
    );
  }
}
