import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:tasnet/helpers/constants.dart';
import 'package:tasnet/helpers/constants.dart' as cons;
import 'package:tasnet/helpers/function_helpers.dart';
import 'package:wifi/wifi.dart';
import 'package:wifi_iot/wifi_iot.dart';

class AuthorizationBloc {
  AuthorizationBloc() {
    Platform.isAndroid
        ? mainAndroidWiFiControlMethod()
        : mainiOSWiFiControlMethod();
    _userNameController.stream.listen((name) {
      saveCredentials(namePrefName, name);
    });
    _userAgeController.stream.listen((age) {
      saveCredentials(namePrefName, age);
    });
    _userNumberController.stream.listen((number) {
      saveCredentials(namePrefName, number);
    });
  }

  ///Variables to save Cache
  String mac = '';
  String loginLink = '';
  String lastSsid = '';

  ///Sink
  Sink<String> get userName => _userNameController.sink;

  final _userNameController = StreamController<String>();

  Sink<String> get userAge => _userAgeController.sink;

  final _userAgeController = StreamController<String>();

  Sink<String> get userNumber => _userNumberController.sink;

  final _userNumberController = StreamController<String>();

  ///Stream
  Stream<String> get apiRequestValue => _apiRequestValueSubject.stream;

  final _apiRequestValueSubject = BehaviorSubject<String>();

  Stream<bool> get showSnackBar => _showSnackBarSubject.stream;

  final _showSnackBarSubject = BehaviorSubject<bool>();

  Future<void> mainiOSWiFiControlMethod() async {
    await wifiStatusCheck().then((val) {});
  }

  Future<void> mainAndroidWiFiControlMethod() async {
    // http.Response res;
    await initialAndroidConnection().then((val) {
      initialServerRequest()
        ..then((res) {
          _parsedResponse(res, cons.loginLink).then((val) {
            loginLink = val;
            login(val).then((val) {
              print("Login done");
              _showSnackBarSubject.add(true);
            });
          });
        })
        ..then((res) {
          _parsedResponse(res, cons.mac).then((val) => mac = val);
        });
    });
  }

  Future<bool> initialAndroidConnection() async {
    bool _isSuccess;
    try {
      await WiFiForIoTPlugin.setEnabled(false);
      await WiFiForIoTPlugin.setEnabled(true);
      _isSuccess = await WiFiForIoTPlugin.connect("TASNET 2.0");
    } on PlatformException catch (e) {
      print("Platform exception");
      print(e);
      _isSuccess = false;
    } catch (e) {
      print("exception");
      print(e);
      _isSuccess = false;
    } finally {
      print("Finally is executed");
    }
    return _isSuccess;
  }

  ///intial request
  Future<http.Response> initialServerRequest() async {
    String url = "http://innovo.tasnet/";
    http.Response _result;
    try {
      http.Response _response = await http.get(url);
      if (_response.statusCode == 200) _result = _response;
    } catch (e) {
      print(e);
    }
    return _result;
  }

  /// parse LoginLink and MacAddressfrom inital request response
  Future<String> _parsedResponse(
      http.Response apiResponse, String searchInputName) async {
    print(apiResponse.body);
    String _result = '';
    if (apiResponse != null || apiResponse.contentLength > 0) {
      print(apiResponse.body.toString());

      var parsedLinkElement = parse(apiResponse.body)
          .body
          .querySelector('input[name="$searchInputName"]')
          .outerHtml
          .toString();
      print(parsedLinkElement);

      _result = parsedLinkElement
          .split(new RegExp('name="$searchInputName"'))
          .last
          .split(r'=')
          .last
          .replaceAll((r'>'), '')
          .replaceAll((r'"'), '')
          .trim();

      print(_result);
    }
    return _result;
  }

  Future<void> login(String loginLink) async {
    Map<String, String> _fields = {
      "username": "$wifiLoginUsername",
      "password": "$wifiLoginPassword"
    };

    try {
      http.Response _response = await http.post(loginLink, body: _fields);

      if (_response.statusCode == 200) {
        //TODO: show snackbar
      } else {
        //TODO: Try again
      }
    } catch (e) {
      print(e);
    }
  }

  dispose() async {
    await saveCredentials(cons.mac, mac);
    await saveCredentials(cons.loginLink, loginLink);
    _apiRequestValueSubject.close();
    _userAgeController.close();
    _userNameController.close();
    _userNumberController.close();
    _showSnackBarSubject.close();
  }
}
