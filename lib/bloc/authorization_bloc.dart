import 'dart:async';

import 'package:dio/dio.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:tasnet/constants.dart';
import 'package:tasnet/helpers/funtion_helpers.dart';

class AuthorizationBloc {
  AuthorizationBloc() {
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

  ///make a request to get mac address of device
  Future<String> getMacAddree() async {
    String _macAddress = '';
    String url = "http://innovo.tasnet/";
    try {
      http.Response _response = await http.get(url);
      if (_response.statusCode == 200)
        _macAddress = await _parseMacAddress(_response);
      await login(_macAddress);

      //TODO: show flushbar with error
    } catch (e) {
      print(e);
      //TODO: show flushbar with error
    }

    return _macAddress;
  }

  Future<String> _parseMacAddress(http.Response apiResponse) async {
    String _macAddress = '';
    String name = "mac2";
    print(apiResponse.body.toString());
    var parsedElement = parse(apiResponse.body)
        .body
        .querySelector('input[name="$name"]')
        .outerHtml
        .toString();
    print(parsedElement);
    _macAddress = parsedElement
        .split(new RegExp('name="$name"'))
        .last
        .split(r'=')
        .last
        .replaceAll((r'>'), '')
        .replaceAll((r'"'), '')
        .trim();

    print(_macAddress);
    return _macAddress;
  }

  Future<void> loginDio() async {
    Dio dio = Dio();
    // Response _response = await dio.post("http://innovo.tasnet/login", data: {
    //   {"name": "username", "value": "5d12227ad8faaf2771f1ba7e"},
    //   {"name": "password", "value": "macaspassword"}
    // });
    String fields = "{\n" +
        "          \"fields\": [\n" +
        "            {\"name\": \"username\", \"value\": \"5d12227ad8faaf2771f1ba7e\"},\n" +
        "            {\"name\": \"password\", \"value\": \"macaspassword\"},\n" +
        "          ]\n" +
        "        }";
    FormData formData = new FormData.from({"body": fields});

    Response response =
        await dio.post("http://innovo.tasnet/login", data: formData);
    response.statusCode == 200 ? print("Success!") : print("Failed");
  }

  Future<void> login(String macAddress) async {
    //name=username value=5d12227ad8faaf2771f1ba7e
    //name=password value=macaspassword
    String _name = "5d12227ad8faaf2771f1ba7e";
    String _url = "http://innovo.tasnet/login";

    var uri = Uri.parse(_url);
    var request = new http.MultipartRequest("POST", uri);
    request.fields["username"] = _name;
    request.fields["password"] = macAddress;

    var response = await request.send();
    if (response.statusCode == 200) print('Uploaded!');
  }

  dispose() {
    _apiRequestValueSubject.close();
    _userAgeController.close();
    _userNameController.close();
    _userNumberController.close();
  }
}
