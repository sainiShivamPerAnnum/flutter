import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/material.dart';

class TambolaBoardView extends StatefulWidget {
  TambolaBoardView(
      {Key key,
      this.tambolaBoard,
      this.calledDigits,
      this.boardColor = Colors.blueGrey})
      : super(key: key);

  final List<List<int>> tambolaBoard;
  final Color boardColor;
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
  Color altGridColor = Colors.blueGrey;
  Color borderColor = Colors.blueGrey;

  @override
  void initState() {
    //decodeBoard(widget.boardValueCde);
    if (widget.boardColor != Colors.blueGrey) {
      int r = widget.boardColor.red;
      int g = widget.boardColor.green;
      int b = widget.boardColor.blue;

      int rx = r + (255 - r * 0.25).round();
      int gx = g + (255 - g * 0.25).round();
      int bx = b + (255 - b * 0.25).round();

      altGridColor = Color.fromRGBO(
          rx, gx, bx, 1); //widget.boardColor;//Color.fromRGBO(rx, gx, bx, 1);
      borderColor = widget.boardColor;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      AspectRatio(
          aspectRatio: 3.1,
          child: SizedBox.expand(
            child: Container(
              margin: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: boardLength,
                  ),
                  itemBuilder: _buildGridItems,
                  itemCount: boardLength * boardHeight,
                ),
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
    return SizedBox.expand(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
              color: this.gridOnTap && x == this.tappedX && y == this.tappedY
                  ? widget.boardColor
                  : Colors.black,
              width: this.gridOnTap && x == this.tappedX && y == this.tappedY
                  ? 2.0
                  : 0.0),
          color: (x + y) % 2 == 0 ? altGridColor : Colors.grey[400],
        ),
        foregroundDecoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    width: x == 0 ? 4.0 : 0.0,
                    color: x == 0 ? borderColor : Colors.black),
                left: BorderSide(
                    width: y == 0 ? 4.0 : 0.0,
                    color: y == 0 ? borderColor : Colors.black),
                bottom: BorderSide(
                    width: x == 2 ? 4.0 : 0.0,
                    color: x == 2 || x == 5 || x == 8
                        ? borderColor
                        : Colors.black),
                right: BorderSide(
                    width: y == 8 ? 4.0 : 0.0,
                    color: y == 2 || y == 5 || y == 8
                        ? borderColor
                        : Colors.black))),
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
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(fontFamily: 'rms', color: Colors.black),
        ),
      );
    else {
      return Text(
        digit.toString(),
        style: Theme.of(context)
            .textTheme
            .bodyText1
            .copyWith(fontFamily: 'rms', color: Colors.black),
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
