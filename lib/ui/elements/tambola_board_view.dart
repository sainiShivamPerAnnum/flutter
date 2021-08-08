import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TambolaBoardView extends StatefulWidget {
  TambolaBoardView({
    Key key,
    this.tambolaBoard,
    this.calledDigits,
    this.boardColor,
    this.ticketColor1,
    this.ticketColor2,
  }) : super(key: key);

  @required
  final List<List<int>> tambolaBoard;
  @required
  final Color boardColor;
  @required
  final Color ticketColor1;
  @required
  final Color ticketColor2;
  @required
  final List<int> calledDigits;

  @override
  State<StatefulWidget> createState() => TambolaBoardState();
}

class TambolaBoardState extends State<TambolaBoardView> {
  Log log = new Log('TambolaBoard');
  static final int boardHeight = 3;
  static final int boardLength = 9;
  bool gridOnTap = false;
  var tappedX, tappedY;

  // @override
  // void initState() {
  //   //decodeBoard(widget.boardValueCde);
  //   if (widget.boardColor != Colors.blueGrey) {
  //     int r = widget.boardColor.red;
  //     int g = widget.boardColor.green;
  //     int b = widget.boardColor.blue;

  //     int rx = r + (255 - r * 0.25).round();
  //     int gx = g + (255 - g * 0.25).round();
  //     int bx = b + (255 - b * 0.25).round();

  //     altGridColor = Color.fromRGBO(
  //         rx, gx, bx, 1); //widget.boardColor;//Color.fromRGBO(rx, gx, bx, 1);
  //     borderColor = widget.boardColor;
  //   }
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      AspectRatio(
          aspectRatio: 2.9,
          child: SizedBox.expand(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: widget.boardColor),
              padding: EdgeInsets.all(4),
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: boardLength,
                ),
                itemBuilder: _buildGridItems,
                itemCount: boardLength * boardHeight,
              ),
            ),
          )),
    ]);
  }

  Widget _buildGridItems(BuildContext context, int index) {
    int x, y = 0;
    x = (index / boardLength).floor();
    y = (index % boardLength);

    return GestureDetector(
      onTap: () => gridItemTapped(x, y),
      child: GridTile(
        child: Container(
          child: Center(
            child: _buildGridItem(x, y, widget.tambolaBoard[x][y]),
          ),
        ),
      ),
    );
  }

  gridItemTapped(int x, int y) {
    setState(() {
      this.gridOnTap = true;
      print(x.toString() + "," + y.toString());
      this.tappedX = x;
      this.tappedY = y;
      print(this.tappedX.toString() + "tap" + this.tappedY.toString());
    });
  }

  Widget _buildGridItem(int x, int y, int digit) {
    BorderRadius getBorderRadius() {
      if (x == 0 && y == 0)
        return BorderRadius.only(
          topLeft: Radius.circular(8),
        );
      else if (x == 0 && y == 8)
        return BorderRadius.only(
          topRight: Radius.circular(8),
        );
      else if (x == 2 && y == 0)
        return BorderRadius.only(bottomLeft: Radius.circular(8));
      else if (x == 2 && y == 8)
        return BorderRadius.only(bottomRight: Radius.circular(8));
      else
        return BorderRadius.zero;
    }

    return SizedBox.expand(
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: this.gridOnTap && x == this.tappedX && y == this.tappedY
                    ? widget.boardColor
                    : Colors.transparent,
                width: this.gridOnTap && x == this.tappedX && y == this.tappedY
                    ? 2.0
                    : 0.0),
            color: (x + y) % 2 == 0 ? widget.ticketColor1 : widget.ticketColor2,
            borderRadius: getBorderRadius()),
        foregroundDecoration: BoxDecoration(
            // border: Border(
            //   top: BorderSide(
            //       width: 0.0, color: x == 0 ? borderColor : Colors.black),
            //   left: BorderSide(
            //       width: 0.0, color: y == 0 ? borderColor : Colors.black),
            //   bottom: BorderSide(
            //       width: 0.0,
            //       color: x == 2 || x == 5 || x == 8 ? borderColor : Colors.black),
            //   right: BorderSide(
            //       width: 0.0,
            //       color: y == 2 || y == 5 || y == 8 ? borderColor : Colors.black),
            // ),
            ),
        child: Center(
          child: _getDecoratedDigit(digit, widget.calledDigits),
        ),
      ),
    );
  }

  Widget _getDecoratedDigit(int digit, List<int> calledDigits) {
    if (digit == 0)
      return Text('');
    else if (calledDigits.contains(digit))
      return StrikeThroughWidget(
        child: Text(
          digit.toString(),
          style: GoogleFonts.montserrat(fontWeight: FontWeight.w500),
        ),
      );
    else {
      return Text(
        digit.toString(),
        style: GoogleFonts.montserrat(fontWeight: FontWeight.w500),
      );
    }
  }
}

class StrikeThroughWidget extends StatelessWidget {
  final Widget _child;

  StrikeThroughWidget({Key key, @required Widget child})
      : this._child = child,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _child,
      padding: EdgeInsets.symmetric(horizontal: 6),
      // this line is optional to make strikethrough effect outside a text
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(Assets.strikeThroughGraphic),
            fit: BoxFit.fitWidth),
      ),
    );
  }
}
