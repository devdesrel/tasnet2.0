import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:tasnet/helpers/constants.dart';

class MainMenuBloc {
  double selectedLat;
  double seledtedLong;
  MainMenuBloc() {
    _isMenuButtonPressedController.stream.listen((val) {
      _isMenuButtonPressedStreamSubject.add(val);
    });
    _getSelectedMenuController.stream.listen((val) {
      _selectedMenuSubject.add(val);
    });
  }

  ///[Sinks]

  Sink<bool> get isMenuButtonPressed => _isMenuButtonPressedController.sink;

  final _isMenuButtonPressedController = StreamController<bool>();
  Sink<Menu> get getSelectedMenu => _getSelectedMenuController.sink;

  final _getSelectedMenuController = StreamController<Menu>();

  ///[Streams]

  Stream<bool> get isMenuButtonPressedStream =>
      _isMenuButtonPressedStreamSubject.stream;

  final _isMenuButtonPressedStreamSubject = BehaviorSubject<bool>();

  Stream<Menu> get selectedMenu => _selectedMenuSubject.stream;

  final _selectedMenuSubject = BehaviorSubject<Menu>();

  dispose() {
    _isMenuButtonPressedController.close();
    _isMenuButtonPressedStreamSubject.close();
    _getSelectedMenuController.close();
    _selectedMenuSubject.close();
  }
}
