import 'dart:collection';
import 'dart:developer';

import 'package:felloapp/core/model/helper_model.dart';
import 'package:felloapp/core/model/timestamp_model.dart';

const int boardHeight = 3;
const int boardLength = 9;

class TambolaTicketModel {
  final TimestampModel assignedTime;
  final String val;
  final String id;
  final int weekCode;
  final int winProbability;
  List<String>? encodedTambolaList;
  List<int> ticketsNumList = List.generate(15, (index) => 0);
  List<List<int>>? tambolaBoard =
      List.generate(boardHeight, (_) => List.generate(boardLength, (i) => 0));
  static final helper =
      HelperModel<TambolaTicketModel>(TambolaTicketModel.fromMap);

  Map<int, int> indexValueMap = HashMap();

  // final _logger = locator<CustomLogger>();

  TambolaTicketModel(
      {required this.assignedTime,
      required this.val,
      required this.id,
      required this.winProbability,
      required this.weekCode}) {
    decodeBoard(val);
  }

  factory TambolaTicketModel.fromMap(Map<String, dynamic> map) {
    return TambolaTicketModel(
      assignedTime: TimestampModel.fromMap(map['assignedOn']),
      val: map['tval'] ?? '',
      id: map['tid'] ?? 0,
      winProbability: map['winProbability'] ?? 0,
      weekCode: map['week_code'] ?? 0,
    );
  }

  factory TambolaTicketModel.none() {
    return TambolaTicketModel(
      assignedTime: TimestampModel.none(),
      val: '',
      id: '',
      winProbability: 0,
      weekCode: 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tid': id,
      'tval': val,
      'week_code': weekCode,
      'createdOn': assignedTime.toMap(),
    };
  }

  bool get isValid => val.isNotEmpty;

  List<String> encodedStringToArray(String cde) {
    try {
      return cde.split(RegExp('(?<=[Aa-z])'));
    } catch (e) {
      return [];
    }
  }

  Map<int, int> compileEncodedArrayToMap() {
    Map<int, int> map = HashMap();
    for (final val in encodedTambolaList!) {
      TambolaValueObject obj = TambolaValueObject(val);
      if (obj.index != TambolaValueObject.INVALID &&
          obj.value != TambolaValueObject.INVALID) {
        map[obj.index] = obj.value;
      } else {
        log("Error while inserting Tambola item value: $val");
      }
    }
    return map;
  }

  List<List<int>> compileBoardMap() {
    for (int i = 0; i < boardHeight; i++) {
      for (int j = 0; j < boardLength; j++) {
        int key = i * boardLength + j;
        tambolaBoard![i][j] =
            (indexValueMap.containsKey(key)) ? indexValueMap[key]! : 0;
      }
    }
    return tambolaBoard!;
  }

  List<List<int>>? decodeBoard(String boardCde) {
    encodedTambolaList = encodedStringToArray(boardCde);
    log(encodedTambolaList.toString());
    if (encodedTambolaList!.isNotEmpty && encodedTambolaList!.length == 15) {
      indexValueMap = compileEncodedArrayToMap();
      if (indexValueMap.isNotEmpty) {
        tambolaBoard = compileBoardMap();
        ticketsNumList = tambolaBoard!.expand((x) => x).toList();
        ticketsNumList.removeWhere((n) => n == 0);
        print("ticket: $ticketsNumList");
      } else {
        log("indexValueMap is empty");
      }
    } else {
      log('Invalid decomposition of boardCode: ${encodedTambolaList.toString()}');
    }

    return tambolaBoard;
  }

  String getTicketNumber() => id.split('-').last;

  // int get generatedDayCode {
  //   return DateTime.monday;

  // }
}

class TambolaValueObject {
  int _value = 0;
  int _index = 0;
  bool _valueInvalid = false;
  bool _indexInvalid = false;
  static const int INVALID = -1;

  TambolaValueObject(String val) {
    String intPart = val.replaceAll(RegExp('[^0-9]'), '');
    String charPart = val.replaceAll(intPart, '');
    //log.debug('Result: $char_part and $int_part');

    try {
      int bval = int.parse(intPart);
      if (bval < 1 || bval > 90) {
        _valueInvalid = true;
      } else {
        _value = bval;
      }
    } catch (e) {
      _valueInvalid = true;
    }

    if (charPart.length != 1) {
      _indexInvalid = true;
    } else {
      int bindex = charPart.codeUnitAt(0);
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
