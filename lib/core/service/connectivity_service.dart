import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:felloapp/core/enums/connectivity_status.dart';
import 'package:flutter/foundation.dart';

class ConnectivityService extends ChangeNotifier {
  StreamController<ConnectivityStatus> connectionStatusController =
      StreamController<ConnectivityStatus>();

  ConnectivityService() {
    print("Inside connectivity constructor");
    Connectivity connectivity = Connectivity();
    try {
      connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
        print("Inside connectivity onConnectivityChanged");
        //Conversion of result into enum
        var connectivityStatus = _getStatusFromResult(result);
        //Emitting this over stream
        connectionStatusController.add(connectivityStatus);
      });
    } catch (e) {
      print("Network connectivity error - $e");
    }
    notifyListeners();
  }

  ConnectivityStatus _getStatusFromResult(ConnectivityResult result) {
    print("Inside connectivity status");
    print(result);
    switch (result) {
      case ConnectivityResult.mobile:
        return ConnectivityStatus.Cellular;
      case ConnectivityResult.wifi:
        return ConnectivityStatus.Wifi;
      case ConnectivityResult.none:
        return ConnectivityStatus.Offline;
      default:
        return ConnectivityStatus.Offline;
    }
  }
}
