import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/enums/cache_type_enum.dart';
import 'package:felloapp/core/model/golden_ticket_model.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/cache_manager.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';

class GoldenTicketsViewModel extends BaseModel {
  //Dependencies
  final _userService = locator<UserService>();
  final _logger = locator<CustomLogger>();
  final _apiPaths = locator<ApiPath>();

  //Local Variables
  List<GoldenTicket> _goldenTicketList;
  List<GoldenTicket> _arrangedGoldenTicketList;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  StreamController<List<DocumentSnapshot>> streamController =
      StreamController<List<DocumentSnapshot>>();
  List<DocumentSnapshot> _goldenTicketDocs = [];
  Query _query;
  bool _isRequesting = false;
  bool _isFinish = false;

  //Getters and Setters
  List<GoldenTicket> get arrangedGoldenTicketList =>
      this._arrangedGoldenTicketList;

  List<GoldenTicket> get goldenTicketList => this._goldenTicketList;

  set goldenTicketList(List<GoldenTicket> value) =>
      this._goldenTicketList = value;

  set arrangedGoldenTicketList(List<GoldenTicket> value) =>
      this._arrangedGoldenTicketList = value;

// Core Methods
  void init() {
    _query = _db
        .collection(Constants.COLN_USERS)
        .doc(_userService.baseUser.uid)
        .collection(Constants.SUBCOLN_USER_REWARDS)
        .orderBy('timestamp', descending: true);
    getGoldenTickets();
  }

  void finish() {
    streamController.close();
  }

  Future refresh() async {
    _isFinish = false;
    _goldenTicketDocs = [];
    getGoldenTickets();
  }

  //Local Methods
  Future<void> getGoldenTickets() async {
    _query.snapshots().listen((data) => onChangeData(data.docChanges),
        onError: (error, stacktrace) => onError(error, stacktrace));
    requestMoreData();
  }

  void onError(Object error, StackTrace stacktrace) {
    _logger.e(error, stacktrace);
  }

  Future<bool> redeemTicket(String gtId) async {
    Map<String, dynamic> _body = {
      "uid": _userService.baseUser.uid,
      "gtId": gtId
    };
    try {
      final String _bearer = await _getBearerToken();
      final _apiResponse = await APIService.instance
          .postData(_apiPaths.kRedeemGtReward, token: _bearer, body: _body);
      _logger.d(_apiResponse.toString());
      return true;
    } catch (e) {
      _logger.e(e);
      return false;
    }
  }

//Stream Methods
  void onChangeData(List<DocumentChange> documentChanges) {
    _logger.d("Data Updated");
    var isChange = false;
    documentChanges.forEach((productChange) {
      if (productChange.type == DocumentChangeType.removed) {
        _goldenTicketDocs.removeWhere((product) {
          return productChange.doc.id == product.id;
        });
        isChange = true;
      } else if (productChange.type == DocumentChangeType.added) {
        DocumentSnapshot newDoc = _goldenTicketDocs.firstWhere(
            (e) => e.id == productChange.doc.id,
            orElse: () => null);
        if (newDoc == null) {
          _logger.d("New document detected, adding to list");
          _goldenTicketDocs.add(productChange.doc);
          isChange = true;
        }
      } else {
        if (productChange.type == DocumentChangeType.modified) {
          int indexWhere = _goldenTicketDocs.indexWhere((product) {
            return productChange.doc.id == product.id;
          });

          if (indexWhere >= 0) {
            _goldenTicketDocs[indexWhere] = productChange.doc;
          }
          isChange = true;
        }
      }
    });

    if (isChange && !streamController.isClosed) {
      streamController.add(_goldenTicketDocs);
    }
  }

  Future<void> requestMoreData() async {
    if (!_isRequesting && !_isFinish) {
      QuerySnapshot querySnapshot;
      _isRequesting = true;
      if (_goldenTicketDocs.isEmpty) {
        querySnapshot = await _query.limit(20).get();
      } else {
        querySnapshot = await _query
            .startAfterDocument(_goldenTicketDocs[_goldenTicketDocs.length - 1])
            .limit(20)
            .get();
      }
      if (querySnapshot != null) {
        int oldSize = _goldenTicketDocs.length;
        _goldenTicketDocs.addAll(querySnapshot.docs);
        int newSize = _goldenTicketDocs.length;
        streamController.add(_goldenTicketDocs);
        if (oldSize == 0) {
          //first fetch
          //cache the latest Golden Ticket
          int timestamp = GoldenTicket.fromJson(
                  _goldenTicketDocs[0].data(), _goldenTicketDocs[0].id)
              .timestamp
              .millisecondsSinceEpoch;
          CacheManager.writeCache(
              key: CacheManager.CACHE_LATEST_GOLDEN_TICKET_TIME,
              value: timestamp,
              type: CacheType.int);
        }
        if (oldSize != newSize) {
          _logger.d("New data loaded");
        } else {
          _isFinish = true;
        }
      }

      _isRequesting = false;
    }
  }

//Helper methods
  Future<String> _getBearerToken() async {
    String token = await _userService.firebaseUser.getIdToken();
    _logger.d(token);

    return token;
  }

  arrangeGoldenTickets(List<DocumentSnapshot> data) {
    goldenTicketList =
        data.map((e) => GoldenTicket.fromJson(e.data(), e.id)).toList();
    arrangedGoldenTicketList = [];
    goldenTicketList.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    goldenTicketList.forEach((e) {
      if (e.redeemedTimestamp == null) {
        arrangedGoldenTicketList.add(e);
      }
    });
    goldenTicketList.forEach((e) {
      if (e.redeemedTimestamp != null && e.isRewarding) {
        arrangedGoldenTicketList.add(e);
      }
    });
  }
}
