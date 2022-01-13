import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/golden_ticket_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/api.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';

class GoldenTicketsViewModel extends BaseModel {
  final _userService = locator<UserService>();
  // final _api = locator<Api>();
  final _logger = locator<CustomLogger>();
  final _apiPaths = locator<ApiPath>();
  final _dbModel = locator<DBModel>();
  List<GoldenTicket> _goldenTicketList;
  List<GoldenTicket> _arrangedGoldenTicketList;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  StreamController<List<DocumentSnapshot>> streamController =
      StreamController<List<DocumentSnapshot>>();
  List<DocumentSnapshot> _goldenTicketDocs = [];

  bool _isRequesting = false;
  bool _isFinish = false;

  List<GoldenTicket> get arrangedGoldenTicketList =>
      this._arrangedGoldenTicketList;

  List<GoldenTicket> get goldenTicketList => this._goldenTicketList;

  set goldenTicketList(List<GoldenTicket> value) {
    this._goldenTicketList = value;
    //notifyListeners();
  }

  set arrangedGoldenTicketList(List<GoldenTicket> value) {
    this._arrangedGoldenTicketList = value;
    //notifyListeners();
  }

  void init() {
    getGoldenTickets();
  }

  void disp() {
    streamController.close();
  }

  Future<void> getGoldenTickets() async {
    _db
        .collection(Constants.COLN_USERS)
        .doc(_userService.baseUser.uid)
        .collection(Constants.SUBCOLN_USER_REWARDS)
        .orderBy('createdTimestamp', descending: true)
        .snapshots()
        .listen((data) => onChangeData(data.docChanges));
    requestNextPage();
  }

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
        DocumentSnapshot newDoc;

        if (_goldenTicketDocs.isEmpty)
          return;
        else {
          try {
            newDoc = _goldenTicketDocs
                .firstWhere((e) => e.id == productChange.doc.id);
          } catch (e) {
            _logger.d("New document detected, adding to list");
            _goldenTicketDocs.add(productChange.doc);
            isChange = true;
          }
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

  refresh() {
    _goldenTicketDocs = [];
    _goldenTicketList = [];
    _arrangedGoldenTicketList = [];
    requestNextPage();
  }

  Future<String> _getBearerToken() async {
    String token = await _userService.firebaseUser.getIdToken();
    _logger.d(token);

    return token;
  }

  arrangeGoldenTickets() {
    arrangedGoldenTicketList = [];
    goldenTicketList.sort((a, b) => b.createdOn.compareTo(a.createdOn));
    goldenTicketList.forEach((e) {
      if (e.redeemedTimestamp == null) {
        arrangedGoldenTicketList.add(e);
      }
    });
    goldenTicketList.forEach((e) {
      if (e.redeemedTimestamp != null &&
          e.rewards != null &&
          e.rewards.isNotEmpty) {
        arrangedGoldenTicketList.add(e);
      }
    });
  }

  redeemTicket(String gtId) async {
    Map<String, dynamic> _body = {
      "uid": _userService.baseUser.uid,
      "gtId": gtId
    };
    try {
      final String _bearer = await _getBearerToken();
      final _apiResponse = await APIService.instance
          .postData(_apiPaths.kRedeemGtReward, token: _bearer, body: _body);
      _logger.d(_apiResponse.toString());

      ///await getGoldenTickets();
    } catch (e) {
      _logger.e(e);
    }
  }

  void requestNextPage() async {
    if (!_isRequesting && !_isFinish) {
      QuerySnapshot querySnapshot;
      _isRequesting = true;
      if (_goldenTicketDocs.isEmpty) {
        querySnapshot = await _db
            .collection(Constants.COLN_USERS)
            .doc(_userService.baseUser.uid)
            .collection(Constants.SUBCOLN_USER_REWARDS)
            .orderBy('createdTimestamp', descending: true)
            .limit(20)
            .get();
      } else {
        querySnapshot = await _db
            .collection(Constants.COLN_USERS)
            .doc(_userService.baseUser.uid)
            .collection(Constants.SUBCOLN_USER_REWARDS)
            .orderBy('createdTimestamp', descending: true)
            .startAfterDocument(_goldenTicketDocs[_goldenTicketDocs.length - 1])
            .limit(20)
            .get();
      }

      if (querySnapshot != null) {
        int oldSize = _goldenTicketDocs.length;
        _goldenTicketDocs.addAll(querySnapshot.docs);
        int newSize = _goldenTicketDocs.length;
        if (oldSize != newSize) {
          streamController.add(_goldenTicketDocs);
          _logger.d("New data loaded");
        } else {
          _isFinish = true;
        }
      }
      _isRequesting = false;
    }
  }
}
