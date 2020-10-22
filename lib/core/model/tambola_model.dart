import 'dart:collection';

import 'package:countdown/countdown.dart';
import 'package:felloapp/ui/pages/tabs/play_tab.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/widgets.dart';

abstract class TambolaViewModel extends State<GameScreen> {
  Log log = new Log('TambolaModel');
  static final int boardHeight = 3;
  static final int boardLength = 9;

  String sampleTambolaString = "3a21c43e52f71h19k36m56o61p86r9s24u48w65y88A";
  List<String> encodedTambolaList;
  List<List<int>> tambolaBoard =
      new List.generate(boardHeight, (_) => new List(boardLength));
  Map<int, int> indexValueMap = new HashMap();
  List<List<int>> manualSoal = new List.generate(3, (_) => new List(9));

  bool playButton = false;
  bool gridOnTap = false;
  var tappedX, tappedY;
  var sub;
  CountDown cd;
  String countDownText = "00:15:00";
  bool manualCheck = false;
  var totalSeconds;
  bool success = false;

  int rowcek;
  int colcek;

  static const int UNASSIGNED = 0;
  static const int M = 3;
  static const int N = 9;
  static const int SQN = 3;

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

  gridItemTapped(int x, int y) {
    setState(() {
      this.gridOnTap = true;
      print(x.toString() + "," + y.toString());
      this.tappedX = x;
      this.tappedY = y;
      print(this.tappedX.toString() + "tap" + this.tappedY.toString());
    });
  }

  onTapInsertGrid(int v) {
    setState(() {
      // if (manualSoal[this.tappedX][this.tappedY] == UNASSIGNED){
      //   sudokuBoard[this.tappedX][this.tappedY] = v;
      //   print(manualSoal.toString());
      //   print(sudokuBoard.toString());
      //   if(!isSafe(sudokuBoard, this.tappedX, this.tappedY, v)){
      //     manualCheck = true;
      //   }else
      //     manualCheck = false;
      //
      // }
      // print(manualCheck.toString());
    });
  }

  @override
  void initState() {
    super.initState();
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
