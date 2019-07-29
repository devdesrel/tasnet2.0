import 'dart:async';

import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tasnet/models/place.dart';

class MapBloc {
  MapBloc() {
    _setBottomSheetExpandedController.stream.listen((val) {
      _isBottomSheetExpandedSubject.add(val);
    });
    _getSelectedPlaceController.stream.listen((val) {
      _mapCenterLatLngSubject.add(val.latlng);
    });
  }

  ///Sinks
  Sink<Place> get getSelectedPlace => _getSelectedPlaceController.sink;

  final _getSelectedPlaceController = StreamController<Place>();

  Sink<bool> get setBottomSheetExpanded =>
      _setBottomSheetExpandedController.sink;

  final _setBottomSheetExpandedController = StreamController<bool>();

  ///Streams
  Stream<LatLng> get mapCenterLatLng => _mapCenterLatLngSubject.stream;

  final _mapCenterLatLngSubject = BehaviorSubject<LatLng>();
  Stream<bool> get isBottomSheetExpanded =>
      _isBottomSheetExpandedSubject.stream;

  final _isBottomSheetExpandedSubject = BehaviorSubject<bool>();

  dispose() {
    _getSelectedPlaceController.close();
    _mapCenterLatLngSubject.close();
    _isBottomSheetExpandedSubject.close();
    _setBottomSheetExpandedController.close();
  }
}
