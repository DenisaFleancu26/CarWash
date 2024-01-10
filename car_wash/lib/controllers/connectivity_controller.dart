import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConectivityController {
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  Future<void> checkInternetConnection({
    required Future<String?> Function() box,
    required Function() onAlert,
  }) async {
    isDeviceConnected = await InternetConnectionChecker().hasConnection;
    if (!isDeviceConnected && !isAlertSet) {
      box();
      onAlert;
    }
  }
}
