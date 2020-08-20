import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:tablet_tower_flutter/conectivity/connectivity_status.dart';

class ConnectivityServices {
  
  StreamController<ConnectivityStatus> connectionStatusController = StreamController<ConnectivityStatus>();

  ConnectivityServices() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      var connectionStatus = _getStatusFromResult(result);

      connectionStatusController.add(connectionStatus);
    });
  }

  ConnectivityStatus _getStatusFromResult(ConnectivityResult result) {
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
