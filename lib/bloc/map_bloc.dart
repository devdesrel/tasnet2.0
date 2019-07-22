import 'dart:async';

import 'package:rxdart/rxdart.dart';

class MapBloc {
  MapBloc() {
    _isBottomSheetDraggedUpController.stream.listen((val) {
      isBottomSheetDraggedUpStreamSubject.add(val);
    });
  }

  ///Sinks
  Sink<bool> get isBottomSheetDraggedUp =>
      _isBottomSheetDraggedUpController.sink;

  final _isBottomSheetDraggedUpController = StreamController<bool>();

  ///Streams
  Stream<bool> get isBottomSheetDraggedUpStream =>
      isBottomSheetDraggedUpStreamSubject.stream;

  final isBottomSheetDraggedUpStreamSubject = BehaviorSubject<bool>();

  dispose() {
    isBottomSheetDraggedUpStreamSubject.close();
    _isBottomSheetDraggedUpController.close();
  }
}
