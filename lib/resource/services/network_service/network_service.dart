import 'dart:async';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gov_statistics_investigation_economic/common/common.dart';

///
///https://pub.dev/packages/connectivity_plus
class NetworkService extends GetxController {
  //this variable none = No Internet, wifi = connected to WIFI ,mobile = connected to Mobile Data.
  static Network connectionType = Network.wifi;
  //Instance of Flutter Connectivity
  //final Connectivity _connectivity = Connectivity();
  //Stream to keep listening to network change state
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  // @override
  // void onInit() {
  //  Future.delayed(const Duration(seconds: 2), () {
  //     initConnectionType();

  //     _connectivitySubscription =
  //         _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  //   });
  // }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    Future.delayed(const Duration(seconds: 2), () {
      _connectivitySubscription =
          Connectivity()
              .onConnectivityChanged
              .listen((List<ConnectivityResult> result) {
        // Received changes in available connectivity types!
        _updateConnectionStatus(result);
      });
    });
  }

  // a method to get which connection result, if you we connected to internet or no if yes then which network
  // Future<void> initConnectionType() async {
  //   //late ConnectivityResult result;
  //   final List<ConnectivityResult> result;
  //   try {
  //     result = await (_connectivity.checkConnectivity());
  //   } on PlatformException catch (e) {
  //     log('$e');
  //     return;
  //   }
  //   return _updateConnectionStatus(result);
  // }

  // state update, of network, if you are connected to WIFI connectionType will get set to 1,
  // and update the state to the consumer of that variable.
  _updateConnectionStatus(List<ConnectivityResult> connectivityResult) {
    log('$connectivityResult');
    // This condition is for demo purposes only to explain every connection type.
    // Use conditions which work for your requirements.
    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      // Mobile network available.
      connectionType = Network.mobile;
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      // Wi-fi is available.
      // Note for Android:
      // When both mobile and Wi-Fi are turned on system will return Wi-Fi only as active network type
      connectionType = Network.wifi;
    } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
      // Ethernet connection available.
    } else if (connectivityResult.contains(ConnectivityResult.vpn)) {
      // Vpn connection active.
      // Note for iOS and macOS:
      // There is no separate network interface type for [vpn].
      // It returns [other] on any device (also simulator)
    } else if (connectivityResult.contains(ConnectivityResult.bluetooth)) {
      // Bluetooth connection available.
    } else if (connectivityResult.contains(ConnectivityResult.other)) {
      // Connected to a network which is not in the above mentioned networks.
    } else if (connectivityResult.contains(ConnectivityResult.none)) {
      // No available network types
      connectionType = Network.none;
    } else {
      Get.snackbar('Network Error', 'Failed to get Network Status');
    }

    update();
    if (connectionType == Network.none) {
      Get.snackbar('Network Error', 'No network connection',
          colorText: Colors.redAccent);
    }
  }

  // @override
  // void onClose() {
  //   //stop listening to network state when app is closed
  //   _connectivitySubscription.cancel();
  // }

  // Be sure to cancel subscription after you are done
  @override
  dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
}
