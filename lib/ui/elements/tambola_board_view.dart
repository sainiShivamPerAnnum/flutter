import 'dart:collection';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TambolaBoardView extends StatefulWidget {
  TambolaBoardView({Key key, this.boardValueCde, this.calledDigits, this.boardColor=Colors.blueGrey}) : super(key: key);

  final String boardValueCde;
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
  List<String> encodedTambolaList;
  List<List<int>> tambolaBoard =
      new List.generate(boardHeight, (_) => new List(boardLength));
  Map<int, int> indexValueMap = new HashMap();
  Color altGridColor = Colors.blueGrey;

  @override
  void initState() {
    decodeBoard(widget.boardValueCde);
    if(widget.boardColor != Colors.blueGrey) {
      int r = widget.boardColor.red;
      int g = widget.boardColor.green;
      int b = widget.boardColor.blue;

      int rx = r + (255-r*0.25).round();
      int gx = g + (255-g*0.25).round();
      int bx = b + (255-b*0.25).round();

      altGridColor = Color.fromRGBO(rx, gx, bx, 1);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Column(children: <Widget>[
        AspectRatio(
            aspectRatio: 3.1,
            child: SizedBox.expand(
              child: Container(
                margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6.0),
                  child: GridView.builder(
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
            child: _buildGridItem(x, y, tambolaBoard[x][y]),
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
          color: (x + y) % 2 == 0 ? altGridColor : Colors.grey,
        ),
        foregroundDecoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    width: x == 0 ? 4.0 : 0.0,
                    color: x == 0 ? widget.boardColor : Colors.black),
                left: BorderSide(
                    width: y == 0 ? 4.0 : 0.0,
                    color: y == 0 ? widget.boardColor : Colors.black),
                bottom: BorderSide(
                    width: x == 2 ? 4.0 : 0.0,
                    color: x == 2 || x == 5 || x == 8
                        ? widget.boardColor
                        : Colors.black),
                right: BorderSide(
                    width: y == 8 ? 4.0 : 0.0,
                    color: y == 2 || y == 5 || y == 8
                        ? widget.boardColor
                        : Colors.black))),
        child: Center(
          child: _getDecoratedDigit(digit, widget.calledDigits),
        ),
      ),
    );
  }

  Widget _getDecoratedDigit(int digit, List<int> calledDigits) {
    if(digit == 0) return Text('');
    else if(calledDigits.contains(digit)) return StrikeThroughWidget(
      child: Text(digit.toString(),
        style: Theme.of(context).textTheme.bodyText1.copyWith(fontFamily: 'rms', color: Colors.black),
      ),
    );
    else{
      return Text(digit.toString(),
        style: Theme.of(context).textTheme.bodyText1.copyWith(fontFamily: 'rms', color: Colors.black),
      );
    }
  }

  List<String> encodedStringToArray(String cde) {
    try {
      return cde.split(RegExp('(?<=[Aa-z])'));
    } catch (e) {
      return new List();
    }
  }

  Map<int, int> compileEncodedArrayToMap() {
    Map<int, int> map = new HashMap();
    encodedTambolaList.forEach((val) {
      TambolaValueObject obj = new TambolaValueObject(val);
      if (obj.index != TambolaValueObject.INVALID &&
          obj.value != TambolaValueObject.INVALID)
        map[obj.index] = obj.value;
      else
        log.error("Error while inserting Tambola item value: $val");
    });

    return map;
  }

  List<List<int>> compileBoardMap() {
    for (int i = 0; i < boardHeight; i++) {
      for (int j = 0; j < boardLength; j++) {
        int key = i * boardLength + j;
        tambolaBoard[i][j] =
            (indexValueMap.containsKey(key)) ? indexValueMap[key] : 0;
      }
    }
    return tambolaBoard;
  }

  decodeBoard(String boardCde) {
    encodedTambolaList = encodedStringToArray(boardCde);
    log.debug(encodedTambolaList.toString());
    if (encodedTambolaList.isNotEmpty && encodedTambolaList.length == 15) {
      indexValueMap = compileEncodedArrayToMap();
      if (indexValueMap.isNotEmpty) {
        tambolaBoard = compileBoardMap();
      } else {
        log.error("indexValueMap is empty");
      }
    } else {
      log.error(
          'Invalid decomposition of boardCode: ${encodedTambolaList.toString()}');
    }
  }

  String getRowOdds(int rowIndex) {
    if(tambolaBoard==null || tambolaBoard.isEmpty
        || widget.calledDigits==null || widget.calledDigits.isEmpty) return 'NA';
    int digitsLeftToBeAnnounced = BaseUtil.TOTAL_DRAWS-widget.calledDigits.length;
    int rowCalledCount = 0;
    for(int i=0; i<boardLength; i++) {
      if(tambolaBoard[rowIndex][i] !=0 && widget.calledDigits.contains(tambolaBoard[rowIndex][i]))rowCalledCount++;
    }
    int rowLeftCount = 5-rowCalledCount;

    if(rowLeftCount==0) return 'HIT!';
    else if(rowLeftCount>digitsLeftToBeAnnounced)return '0';
    else return '$rowLeftCount/$digitsLeftToBeAnnounced';
  }

  String getCornerOdds() {
    if(tambolaBoard==null || tambolaBoard.isEmpty
        || widget.calledDigits==null || widget.calledDigits.isEmpty) return 'NA';
    int cornerA = 0;
    int cornerB = 0;
    int cornerC = 0;
    int cornerD = 0;
    int cornerCount = 0;
    for(int i=0; i<boardHeight; i++) {
      for(int j=0; j<boardLength; j++) {
        if(tambolaBoard[i][j] != 0) {
          if(i==0 && cornerA == 0)cornerA = tambolaBoard[i][j];
          if(i==0)cornerB = tambolaBoard[i][j];
          if(i==2 && cornerC == 0)cornerC = tambolaBoard[i][j];
          if(i==2)cornerD = tambolaBoard[i][j];
        }
      }
    }
    if(widget.calledDigits.contains(cornerA))cornerCount++;
    if(widget.calledDigits.contains(cornerB))cornerCount++;
    if(widget.calledDigits.contains(cornerC))cornerCount++;
    if(widget.calledDigits.contains(cornerD))cornerCount++;
    int digitsLeftToBeAnnounced = BaseUtil.TOTAL_DRAWS-widget.calledDigits.length;
    int cornerLeftCount = 4-cornerCount;

    if(cornerLeftCount==0) return 'HIT!';
    else if(cornerLeftCount>digitsLeftToBeAnnounced) return '0';
    else return '$cornerLeftCount left';
  }

  String getFullHouseOdds() {
    if(tambolaBoard==null || tambolaBoard.isEmpty
        || widget.calledDigits==null || widget.calledDigits.isEmpty) return 'NA';
    int fullHouseCount = 0;
    int digitsLeftToBeAnnounced = BaseUtil.TOTAL_DRAWS-widget.calledDigits.length;
    for(int i=0; i<boardHeight; i++) {
      for(int j=0; j<boardLength; j++) {
        if(tambolaBoard[i][j] != 0) {
          if(widget.calledDigits.contains(tambolaBoard[i][j]))fullHouseCount++;
        }
      }
    }
    int fullHouseLeftCount = 15-fullHouseCount;

    if(fullHouseLeftCount==0) return 'HIT!';
    else if(fullHouseLeftCount>digitsLeftToBeAnnounced) return '0';
    else return '$fullHouseLeftCount/$digitsLeftToBeAnnounced';
  }
}

class TambolaValueObject {
  Log log = new Log("TambolaValueObject");
  int _value = 0;
  int _index = 0;
  bool _valueInvalid = false;
  bool _indexInvalid = false;
  static final int INVALID = -1;

  TambolaValueObject(String val) {
    String int_part = val.replaceAll(RegExp('[^0-9]'), '');
    String char_part = val.replaceAll(int_part, '');
    log.debug('Result: $char_part and $int_part');

    try {
      int bval = int.parse(int_part);
      if (bval < 1 || bval > 90)
        _valueInvalid = true;
      else
        _value = bval;
    } catch (e) {
      _valueInvalid = true;
    }

    if (char_part.length != 1)
      _indexInvalid = true;
    else {
      int bindex = char_part.codeUnitAt(0);
      if (bindex > 96 && bindex < 123) {
        _index = bindex - 97;
      } else if (bindex == 65) {
        _index = 26;
      } else {
        _indexInvalid = true;
      }
    }
  }

  bool get indexInvalid => _indexInvalid;

  bool get valueInvalid => _valueInvalid;

  int get index => _indexInvalid ? INVALID : _index;

  int get value => _valueInvalid ? INVALID : _value;
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
      padding: EdgeInsets.symmetric(horizontal: 6), // this line is optional to make strikethrough effect outside a text
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(Assets.strikeThroughGraphic), fit: BoxFit.fitWidth),
      ),
    );
  }
}