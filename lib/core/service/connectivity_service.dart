import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:felloapp/core/enums/connectivity_status.dart';

class ConnectivityService {
  StreamController<ConnectivityStatus> connectionStatusController =
      StreamController<ConnectivityStatus>();

  ConnectivityService() {
     print("Inside connectivity constructor");
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      //Conversion of result into enum
      var connectivityStatus = _getStatusFromResult(result);

      //Emitting this over stream
      connectionStatusController.add(connectivityStatus);
    });
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
