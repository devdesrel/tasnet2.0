import 'dart:async';
import 'dart:core';

import 'package:app_settings/app_settings.dart';
import 'package:geolocator/geolocator.dart' show Position;
import 'package:rxdart/rxdart.dart';
import 'package:tasnet/bloc/bloc.dart';
import 'package:tasnet/helpers/geolocator_service.dart';

class NearestPlaceBloc implements Bloc {
  StreamSubscription<Position> positionStream;
  Position currentPosition;
  double selectedPositionLat;
  double selectedPositionLong;
  NearestPlaceBloc() {
    positionStream = geolocatorService.geolocator
        .getPositionStream(geolocatorService.locationOptions)
        .listen((Position position) async {
      if (position != null) {
        _currentPositionsSubject.add(position);
        currentPosition = position;
        // getDistanceBetweenNearestLocation(position);
        if (selectedPositionLat == null && selectedPositionLong == null) {
          await geolocatorService
              .getDistance(
                  startLat: position.latitude,
                  startLong: position.longitude,
                  endLat: selectedPositionLat ?? 41.326824,
                  endLong: selectedPositionLong ?? 69.330721)
              .then((val) {
            _distanceDoubleSubject.add(val);
          });
        }

        print(position.latitude.toString() +
            ', ' +
            position.longitude.toString());
      } else {
        print('Unknown');
      }
    });

    _selectedPositionLatSinkController.stream.listen((lat) {
      test();
    });

    // lala();
  }
  test() async {
    await geolocatorService
        .getDistance(
            startLat: currentPosition.latitude,
            startLong: currentPosition.longitude,
            endLat: selectedPositionLat,
            endLong: selectedPositionLong)
        .then((val) {
      _distanceDoubleSubject.add(val);
    });
  }

  /// [Streams]

  Stream<Position> get currentPositions => _currentPositionsSubject.stream;

  final _currentPositionsSubject = BehaviorSubject<Position>();

  Stream<String> get currentPlace => _currentPlaceSubject.stream;

  final _currentPlaceSubject = BehaviorSubject<String>();

  Stream<double> get distanceDouble => _distanceDoubleSubject.stream;

  final _distanceDoubleSubject = BehaviorSubject<double>();

  /// [Sinks]
  Sink<Position> get selectedPosition => _selectedPositionController.sink;

  final _selectedPositionController = StreamController<Position>();

  Sink<double> get selectedPositionLatSink =>
      _selectedPositionLatSinkController.sink;

  final _selectedPositionLatSinkController = StreamController<double>();

  Sink<double> get selectedPositionLongSink =>
      _selectedPositionLongSinkController.sink;

  final _selectedPositionLongSinkController = StreamController<double>();

  GeolocatorService geolocatorService = new GeolocatorService();
  clearStreams() {
    _currentPlaceSubject.add('');
    _currentPositionsSubject.add(new Position());
  }

  // mainMethod() async {
  //   _isProgressIndicatorOnSubject.add(true);
  //   await geolocatorService.isLocationEnabled().then((isEnabled) {
  //     if (isEnabled) {
  //       geolocatorService.getCurrentLocation().then((loc) async {
  //         _currentPositionsSubject.add(loc);
  //       }).then((Position loc) async {
  //         print('CURRENT LOCATION');
  //         print(loc.latitude);
  //         print(loc.longitude);
  //         var distance = await geolocatorService.getDistance(
  //             startLat: loc.latitude,
  //             startLong: loc.longitude,
  //             endLat: 41.326824,
  //             endLong: 69.330721);

  //         var place = await geolocatorService.getPlace(loc);
  //         _currentPlaceSubject.add(place);
  //       });
  //       _isProgressIndicatorOnSubject.add(false);
  //     }
  //   });
  //   _isProgressIndicatorOnSubject.add(false);
  // }

  Future<void> openLocationSettings() async {
    try {
      await AppSettings.openLocationSettings();
    } catch (e) {
      print(e);
    }
  }

  // Future<void> getCurrentPosition() async {
  //   geolocatorService.getCurrentLocation().then((val) {
  //     currentPosition = val;
  //     _currentPositionsSubject.add(val);
  //   });
  // }

  // Future<double> bb() async {
  //   final double distance = await Geolocator()
  //       .distanceBetween(41.3395157, 69.3035727, 41.326824, 69.330721);
  //   _distanceDoubleSubject.add(distance);
  //   return distance;
  // }
  @override
  dispose() {
    _currentPositionsSubject.close();
    _currentPlaceSubject.close();
    _distanceDoubleSubject.close();
    positionStream.cancel();
    geolocatorService.dispose();
    _selectedPositionController.close();
    _selectedPositionLatSinkController.close();
    _selectedPositionLongSinkController.close();
  }
}
