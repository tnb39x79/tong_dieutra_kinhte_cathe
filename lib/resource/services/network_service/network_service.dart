import 'dart:async';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '/common/common.dart';

class NetworkService extends GetxController {
  //this variable none = No Internet, wifi = connected to WIFI ,mobile = connected to Mobile Data.
  static Network connectionType = Network.wifi;

  // Reactive connection type for real-time updates
  final Rx<Network> _connectionTypeRx = Network.wifi.obs;

  //Instance of Flutter Connectivity
  final Connectivity _connectivity = Connectivity();
  //Stream to keep listening to network change state
  late final StreamSubscription<List<ConnectivityResult>>
      _connectivitySubscription;

  /// Get reactive connection type
  Network get connectionTypeRx => _connectionTypeRx.value;

  /// Get reactive connection type observable
  Rx<Network> get connectionTypeObservable => _connectionTypeRx;

  /// Check if device is connected to internet (reactive)
  bool get isConnected => _connectionTypeRx.value != Network.none;

  /// Get reactive stream of connection status
  Stream<bool> get connectionStream => _connectionTypeRx.map((type) => type != Network.none);

  @override
  void onInit() async {
    await initConnectionType();

    await Future.delayed(const Duration(seconds: 2));

    // _connectivitySubscription =
    //     _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((v) {
      _updateConnectionStatus(v.first);
    });

    super.onInit();
  }

  Future<void> initConnectionType() async {
    late ConnectivityResult result;
    try {
      result = (await _connectivity.checkConnectivity()).first;
    } on PlatformException catch (e) {
      log('$e');
      return;
    }
    return _updateConnectionStatus(result);
  }

  _updateConnectionStatus(ConnectivityResult result) async {
    log('$result');
    Network newConnectionType;
    switch (result) {
      case ConnectivityResult.wifi:
        newConnectionType = Network.wifi;
        break;
      case ConnectivityResult.mobile:
        newConnectionType = Network.mobile;
        break;
      case ConnectivityResult.none:
        newConnectionType = Network.none;
        break;
      default:
        newConnectionType = Network.none;
        // Get.snackbar('Network Error', 'Failed to get Network Status');
        break;
    }

    // Update both static and reactive variables
    connectionType = newConnectionType;
    _connectionTypeRx.value = newConnectionType;

    update();
    // if (connectionType == Network.none) {
    //   Get.snackbar('Network Error', 'No network connection',
    //       colorText: Colors.redAccent);
    // }
  }

  @override
  void onClose() {
    //stop listening to network state when app is closed
    _connectivitySubscription.cancel();
  }
}
