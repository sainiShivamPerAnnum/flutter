import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:felloapp/core/enums/connectivity_status_enum.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class ConnectivityService extends ChangeNotifier {
  ConnectivityService({ConnectivityStatus? connectivityStatus})
      : _connectivityStatus = connectivityStatus ?? ConnectivityStatus.Online,
        super() {
    Connectivity().onConnectivityChanged.distinct().listen((event) {
      final result = _getStatusFromResult(event);
      if (result != connectivityStatus) {
        _connectivityStatus = result;

        notifyListeners();
      }
    });
  }

  ConnectivityStatus _connectivityStatus;

  ConnectivityStatus get connectivityStatus => _connectivityStatus;

  ConnectivityStatus _getStatusFromResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.mobile:
      case ConnectivityResult.wifi:
        return ConnectivityStatus.Online;
      case ConnectivityResult.none:
        return ConnectivityStatus.Offline;
      default:
        return ConnectivityStatus.Offline;
    }
  }
}
