import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/service/tambola_service.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';

class TambolaBoard {
  static Log log = new Log('TambolaBoard');
  BaseUtil _baseUtil = locator<BaseUtil>(); //required to fetch client token
  TambolaService _tambolaService = locator<TambolaService>();
  final String doc_key;
  final Timestamp assigned_time;
  final String val;
  final String id;
  final int week_code;
  static final String fldAssignedTime = 'assigned_time';
  static final String fldId = 'id';
  static final String fldBoardValue = 'val';
  static final String fldWeekCode = 'week_code';

  ///////////
  static final int boardHeight = 3;
  static final int boardLength = 9;
  List<String> encodedTambolaList;
  List<List<int>> tambolaBoard =
      new List.generate(boardHeight, (_) => new List(boardLength));
  Map<int, int> indexValueMap = new HashMap();

  TambolaBoard(
      this.doc_key, this.assigned_time, this.val, this.id, this.week_code) {
    if (this.val != null) decodeBoard(this.val);
  }

  TambolaBoard.fromMap(Map<String, dynamic> data, String docKey)
      : this(
          docKey,
          data[fldAssignedTime],
          data[fldBoardValue],
          data[fldId],
          data[fldWeekCode],
        );

  bool isValid() {
    return (val != null); //TODO
  }

  ///////////////////////////////
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

  List<List<int>> decodeBoard(String boardCde) {
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

    return tambolaBoard;
  }

  int getRowOdds(int rowIndex, List<int> calledDigits) {
    if (tambolaBoard == null ||
        tambolaBoard.isEmpty ||
        calledDigits == null ||
        calledDigits.isEmpty) return 5;
    int digitsLeftToBeAnnounced =
        _tambolaService.dailyPicksCount * 7 - calledDigits.length;
    int rowCalledCount = 0;
    for (int i = 0; i < boardLength; i++) {
      if (tambolaBoard[rowIndex][i] != 0 &&
          calledDigits.contains(tambolaBoard[rowIndex][i])) rowCalledCount++;
    }
    int rowLeftCount = 5 - rowCalledCount;

    // if(rowLeftCount==0) return 1;
    // else if(rowLeftCount>digitsLeftToBeAnnounced)return 0;
    // else return '$rowLeftCount/$digitsLeftToBeAnnounced';
    return rowLeftCount;
  }

  int getCornerOdds(List<int> calledDigits) {
    if (tambolaBoard == null ||
        tambolaBoard.isEmpty ||
        calledDigits == null ||
        calledDigits.isEmpty) return 4;
    int cornerA = 0;
    int cornerB = 0;
    int cornerC = 0;
    int cornerD = 0;
    int cornerCount = 0;
    for (int i = 0; i < boardHeight; i++) {
      for (int j = 0; j < boardLength; j++) {
        if (tambolaBoard[i][j] != 0) {
          if (i == 0 && cornerA == 0) cornerA = tambolaBoard[i][j];
          if (i == 0) cornerB = tambolaBoard[i][j];
          if (i == 2 && cornerC == 0) cornerC = tambolaBoard[i][j];
          if (i == 2) cornerD = tambolaBoard[i][j];
        }
      }
    }
    if (calledDigits.contains(cornerA)) cornerCount++;
    if (calledDigits.contains(cornerB)) cornerCount++;
    if (calledDigits.contains(cornerC)) cornerCount++;
    if (calledDigits.contains(cornerD)) cornerCount++;
    // int digitsLeftToBeAnnounced =
    //     _baseUtil.dailyPicksCount * 7 - calledDigits.length;
    int cornerLeftCount = 4 - cornerCount;

    // if(cornerLeftCount==0) return 'HIT!';
    // else if(cornerLeftCount>digitsLeftToBeAnnounced) return '0';
    // else return '$cornerLeftCount left';
    return cornerLeftCount;
  }

  int getFullHouseOdds(List<int> calledDigits) {
    if (tambolaBoard == null ||
        tambolaBoard.isEmpty ||
        calledDigits == null ||
        calledDigits.isEmpty) return 15;
    int fullHouseCount = 0;
    int digitsLeftToBeAnnounced =
        _tambolaService.dailyPicksCount * 7 - calledDigits.length;
    for (int i = 0; i < boardHeight; i++) {
      for (int j = 0; j < boardLength; j++) {
        if (tambolaBoard[i][j] != 0) {
          if (calledDigits.contains(tambolaBoard[i][j])) fullHouseCount++;
        }
      }
    }
    int fullHouseLeftCount = 15 - fullHouseCount;

    // if(fullHouseLeftCount==0) return 'HIT!';
    // else if(fullHouseLeftCount>digitsLeftToBeAnnounced) return '0';
    // else return '$fullHouseLeftCount/$digitsLeftToBeAnnounced';

    return fullHouseLeftCount;
  }

  String getTicketNumber() => id ?? 'NA';

  int get generatedDayCode {
    //TODO disabling this logic of crossing numbers based on date of generation
    return DateTime.monday;
    // if (this.assigned_time == null) return DateTime.monday;
    // return this.assigned_time.toDate().weekday;
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
    //log.debug('Result: $char_part and $int_part');

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
