import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:felloapp/core/enums/connectivity_status_enum.dart';
import 'package:flutter/foundation.dart';

class ConnectivityService extends ChangeNotifier {
  ConnectivityService() {
    Connectivity().onConnectivityChanged.distinct().listen((event) {
      log("Connectivity Service: $event");
      final result = _getStatusFromResult(event);
      if (result != connectivityStatus) {
        _connectivityStatus = result;
        notifyListeners();
      }
    });
  }

  ConnectivityStatus _connectivityStatus = ConnectivityStatus.None;

  ConnectivityStatus get connectivityStatus => _connectivityStatus;

  ConnectivityStatus _getStatusFromResult(List<ConnectivityResult> result) {
    if (result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.ethernet) ||
        result.contains(ConnectivityResult.vpn)) {
      return ConnectivityStatus.Online;
    }
    return ConnectivityStatus.Offline;
  }
}
