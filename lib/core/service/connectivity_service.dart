import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:felloapp/core/enums/connectivity_status_enum.dart';
import 'package:flutter/foundation.dart';

class ConnectivityService extends ChangeNotifier {
  Connectivity connectivity = Connectivity();
  StreamController<ConnectivityStatus> connectionStatusController =
      StreamController<ConnectivityStatus>();

  void initialLoad() async {
    ConnectivityResult connectivityResult =
        await (connectivity.checkConnectivity());
    var connectivityStatus = _getStatusFromResult(connectivityResult);
    connectionStatusController.add(connectivityStatus);
  }

  ConnectivityService() {
    try {
      connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
        var connectivityStatus = _getStatusFromResult(result);
        connectionStatusController.add(connectivityStatus);
      });
    } catch (e) {
      print("Network connectivity error - $e");
    }
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
