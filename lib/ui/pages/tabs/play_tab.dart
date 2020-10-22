import 'package:felloapp/ui/elements/tambola_board_view.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget{

  @override
  GameView createState() => new GameView();
}

class GameView extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      children: <Widget>[
        Align(
          alignment: Alignment.bottomCenter,
          // margin: EdgeInsets.only(top: 35.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TambolaBoardView(boardValueCde: '3a21c43e52f71h19k36m56o61p86r9s24u48w65y88A'),
              _buildButton()
            ],
          ),
        ),
      ],
    );
  }

  _buildButton() {
    return Padding(
        padding: EdgeInsets.all(20.0),
        child:Material(
          child: MaterialButton(
            color: Colors.blueAccent,
            child: Text('Get Tickets',
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
            minWidth: double.infinity,
            height: 50,
            onPressed: () {
              //_reqProvider.pushTicketRequest(_baseProvider.myUser, 1);
            },
          ),
          borderRadius: new BorderRadius.circular(80.0),
        )
    );
  }

}