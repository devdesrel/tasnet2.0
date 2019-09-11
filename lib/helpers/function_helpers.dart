import 'package:shared_preferences/shared_preferences.dart';
import 'package:wifi/wifi.dart';
import 'package:wifi_iot/wifi_iot.dart';

Future<void> saveCredentials(String key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}

Future<bool> wifiConnect(String ssid, String password) async {
  // var result = await Wifi.connection('eastwest', '45402520');
  var result = await Wifi.connection(ssid, password);
  if (result == WifiState.success || result == WifiState.already) {
    return true;
  } else {
    return false;
  }
}

Future<bool> wifiStatusCheck() async {
//TODO: test for iOS
  bool _isWiFiEnabled = await WiFiForIoTPlugin.isEnabled();
  return _isWiFiEnabled;
}
