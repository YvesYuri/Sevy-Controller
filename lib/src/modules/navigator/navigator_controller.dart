import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NavigatorController extends ChangeNotifier {
  int currentPage = 0;
  late StreamSubscription subscription;
  var isDeviceConnected = false;

  void getConnectivity() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      isDeviceConnected = await InternetConnectionChecker().hasConnection;
      notifyListeners();
    });
  }

  void changePage(int index) {
    currentPage = index;
    notifyListeners();
  }
}
