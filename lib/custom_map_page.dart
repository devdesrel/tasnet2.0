import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:tasnet/bloc/main_provider.dart';
import 'package:tasnet/bloc/map_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tasnet/bloc/nearest_location_bloc.dart';
import 'package:geolocator/geolocator.dart' show Position;

import 'models/place.dart';

class CustomMapPage extends StatefulWidget {
  final bool isBottomSheetVisible;
  final double initialLat;
  final double initialLong;

  CustomMapPage(
      {@required this.isBottomSheetVisible,
      @required this.initialLat,
      @required this.initialLong});
  @override
  _CustomMapPageState createState() => _CustomMapPageState();
}
// void _onMapCreated(MapboxMapController controller) {
//     mapController = controller;
//   }

class _CustomMapPageState extends State<CustomMapPage> {
  var _bloc = MapBloc();

  MapboxMapController _controller;
  Position currentLocation;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _bloc.dispose();
    super.dispose();
  }

  addSymbol() {
    _controller.addSymbol(
      SymbolOptions(
          geometry: LatLng(
            widget.initialLat,
            widget.initialLong,
          ),
          iconImage: "airport-15"),
    );
  }

  @override
  Widget build(BuildContext context) {
    _updateSelectedPosition(Symbol symbol) {
      final locationBloc = BlocProvider.of<NearestPlaceBloc>(context);
      locationBloc.selectedPositionLatSink
          .add(symbol.options.geometry.latitude);

      locationBloc.selectedPositionLat = symbol.options.geometry.latitude;
      locationBloc.selectedPositionLong = symbol.options.geometry.longitude;
      // Future.delayed(Duration(seconds: 1), () {
      Navigator.pop(context);
      // });
      print(locationBloc.selectedPositionLat);
      print(locationBloc.selectedPositionLong);
    }

    double screenHeight = MediaQuery.of(context).size.height;
    final List<Place> testList = [
      Place(
          name: "Central Park",
          description: "Парк развлечений",
          distance: "12 лм",
          latlng: LatLng(39.6526886, 66.9542053)),
      Place(
          name: "KFC ганга",
          description: "Парк развлечений",
          distance: "3 км",
          latlng: LatLng(41.3147556, 69.2218199)),
      Place(
          name: "KFC максим горький",
          description: "Ресторан быстрого питания",
          distance: "2 км",
          latlng: LatLng(40.428393, 63.292690)),
    ];

    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              child: MapboxMap(
                  myLocationEnabled: false,
                  myLocationTrackingMode: MyLocationTrackingMode.None,
                  onMapCreated: (val) {
                    _controller = val;
                    _controller.addSymbol(
                      SymbolOptions(
                          geometry: LatLng(
                            widget.initialLat,
                            widget.initialLong,
                          ),
                          iconImage: "airport-15",
                          // iconImage: "grocery-15",
                          // iconColor: 'red',
                          iconSize: 4.0),
                    );
                    _controller.addSymbol(
                      SymbolOptions(
                          geometry: LatLng(
                              // 41.3394287,
                              // 69.3360039,
                              40.428393,
                              63.292690),
                          iconImage: "airport-15",
                          // iconImage: "grocery-15",
                          // iconColor: 'red',
                          iconSize: 4.0),
                    );
                    _controller.addSymbol(
                      SymbolOptions(
                          geometry: LatLng(
                              // 41.3394287,
                              // 69.3360039,
                              41.3147556,
                              69.2218199),
                          iconImage: "airport-15",
                          // iconImage: "grocery-15",
                          // iconColor: 'red',
                          iconSize: 4.0),
                    );
                    _controller.addSymbol(
                      SymbolOptions(
                          geometry: LatLng(
                              // 41.3394287,
                              // 69.3360039,
                              39.6526886,
                              66.9542053),
                          iconImage: "airport-15",
                          // iconImage: "grocery-15",
                          // iconColor: 'red',
                          iconSize: 4.0),
                    );
                    _controller.onSymbolTapped.add(_updateSelectedPosition);
                    // addSymbol();
                  },
                  initialCameraPosition: CameraPosition(
                    target: LatLng(widget.initialLat, widget.initialLong),
                    // target: LatLng(51.528308, -0.3817909),
                    // target: LatLng(
                    //     currentLocation.latitude, currentLocation.longitude),
                    zoom: 15.0,
                  ),
                  gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                    Factory<OneSequenceGestureRecognizer>(
                      () => EagerGestureRecognizer(),
                    ),
                  ].toSet(),
                  styleString:
                      'mapbox://styles/imfavourite/cjxognsw12gbd1cnyasan9juw?optimize=true'),
            ),

            // PlaceSymbolBody(),
            // AnimateCamera(),
            // StreamBuilder<LatLng>(
            //     stream: _bloc.mapCenterLatLng,
            //     builder: (context, snapshot) {
            //       return ScrollingMapBody(
            //           center: snapshot.hasData
            //               ? snapshot.data
            //               : LatLng(69.297837, 41.31327));
            //     }),
            Visibility(
              visible: widget.isBottomSheetVisible ?? true,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: StreamBuilder<bool>(
                    stream: _bloc.isBottomSheetExpanded,
                    initialData: false,
                    builder: (context, snapshot) {
                      return AnimatedContainer(
                        duration: Duration(seconds: 1),
                        curve: Curves.easeInCirc,
                        height: snapshot.hasData
                            ? snapshot.data ? screenHeight - 200.0 : 200
                            : 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(60.0),
                            ),
                            color: Color(0xFF5252FF)),
                        child: Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            ListView.builder(
                              //TODO: use Listview.separated
                              itemCount: testList.length,
                              itemBuilder: (context, index) => Material(
                                type: MaterialType.transparency,
                                child: InkWell(
                                  onTap: () {
                                    _bloc.getSelectedPlace.add(testList[index]);
                                    print(testList[index].latlng.latitude);
                                    print(testList[index].latlng.longitude);
                                    _controller.animateCamera(
                                      CameraUpdate.newCameraPosition(
                                        CameraPosition(
                                          // bearing: 270.0,
                                          target: testList[index].latlng,
                                          tilt: 30.0,
                                          zoom: 15.0,
                                        ),
                                      ),
                                    );
                                    // _controller.clearCircles(); //TODO
                                    //TODO: add circle or icon
                                    // _controller.addCircle(CircleOptions.defaultOptions.circleRadius=)
                                  },
                                  // child: Padding(
                                  //   padding: EdgeInsets.only(
                                  //       bottom: 12.0,
                                  //       top: index == 0 ? 12.0 : 0.0,
                                  //       left: 18.0,
                                  //       right: 18.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 12.0,
                                            top: index == 0 ? 30.0 : 0.0,
                                            left: 18.0,
                                            right: 18.0),
                                        child: ListTile(
                                          // onTap: () {
                                          //   _bloc.getSelectedPlace
                                          //       .add(testList[index]);
                                          //   print(testList[index]);
                                          // },
                                          leading: Opacity(
                                            opacity: 0.2,
                                            child: Container(
                                              height: 60.0,
                                              width: 60.0,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color(0xFFFFFFFF)),
                                            ),
                                          ),
                                          title: Text(
                                            testList[index].name,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 17.0),
                                          ),
                                          subtitle: Text(
                                            testList[index].description,
                                            style: TextStyle(
                                                color: Colors.white54,
                                                fontSize: 12.0),
                                          ),
                                          trailing:
                                              // GestureDetector(
                                              //   onTap: () {
                                              //     final locationBloc = BlocProvider
                                              //         .of<NearestPlaceBloc>(
                                              //             context);
                                              //     locationBloc
                                              //         .selectedPositionLatSink
                                              //         .add(testList[index]
                                              //             .latlng
                                              //             .latitude);

                                              //     locationBloc.selectedPositionLat =
                                              //         testList[index]
                                              //             .latlng
                                              //             .latitude;
                                              //     locationBloc
                                              //             .selectedPositionLong =
                                              //         testList[index]
                                              //             .latlng
                                              //             .longitude;
                                              //     Future.delayed(
                                              //         Duration(seconds: 1), () {
                                              //       Navigator.pop(context);
                                              //     });
                                              //     print(locationBloc
                                              //         .selectedPositionLat);
                                              //     print(locationBloc
                                              //         .selectedPositionLong);
                                              //   },
                                              // child:
                                              Text(
                                            testList[index].distance,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12.0),
                                          ),
                                          // ),
                                        ),
                                      ),
                                      index == testList.length - 1
                                          ? Container(
                                              height: 0.0,
                                              width: 0.0,
                                            )
                                          : Divider(
                                              color: Colors.white24,
                                              indent: 30.0,
                                              endIndent: 30.0,
                                            )
                                    ],
                                  ),
                                ),
                                // ),
                              ),
                            ),
                            //   ),
                            // ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: GestureDetector(
                                onTap: () {
                                  snapshot.data
                                      ? _bloc.setBottomSheetExpanded.add(false)
                                      : _bloc.setBottomSheetExpanded.add(true);
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  height: 40.0,
                                  width: 40.0,
                                  child: Transform.rotate(
                                      angle: snapshot.data ? -pi / 2 : pi / 2,
                                      child: Icon(
                                        Icons.chevron_left,
                                        color: Colors.white,
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
