import 'dart:collection';

import 'package:felloapp/util/logger.dart';
import 'package:flutter/material.dart';

class TambolaBoardView extends StatefulWidget {
  TambolaBoardView({Key key, this.boardValueCde}) : super(key: key);

  final String boardValueCde;

  @override
  State<StatefulWidget> createState() => _TambolaBoardState();
}

class _TambolaBoardState extends State<TambolaBoardView> {
  Log log = new Log('TambolaBoard');
  static final int boardHeight = 3;
  static final int boardLength = 9;
  bool gridOnTap = false;
  var tappedX, tappedY;
  List<String> encodedTambolaList;
  List<List<int>> tambolaBoard =
      new List.generate(boardHeight, (_) => new List(boardLength));
  Map<int, int> indexValueMap = new HashMap();

  @override
  void initState() {
    decodeBoard(widget.boardValueCde);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      AspectRatio(
          aspectRatio: 0.98,
          child: SizedBox.expand(
            child: Container(
              margin: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: GridView.builder(
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
                  ? Colors.orange
                  : Colors.black,
              width: this.gridOnTap && x == this.tappedX && y == this.tappedY
                  ? 2.0
                  : 0.0),
          color: (x + y) % 2 == 0 ? Colors.blueGrey : Colors.grey,
        ),
        foregroundDecoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    width: x == 0 ? 2.0 : 0.0,
                    color: x == 0 ? Colors.orange : Colors.black),
                left: BorderSide(
                    width: y == 0 ? 2.0 : 0.0,
                    color: y == 0 ? Colors.orange : Colors.black),
                bottom: BorderSide(
                    width: x == 2 ? 2.0 : 0.0,
                    color: x == 2 || x == 5 || x == 8
                        ? Colors.orange
                        : Colors.black),
                right: BorderSide(
                    width: y == 8 ? 2.0 : 0.0,
                    color: y == 2 || y == 5 || y == 8
                        ? Colors.orange
                        : Colors.black))),
        child: Center(
          child: Text(digit == 0 ? '' : digit.toString()),
        ),
      ),
    );
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
      if (bindex > 96 && bindex < 122) {
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
