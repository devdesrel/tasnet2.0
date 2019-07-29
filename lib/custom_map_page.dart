import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:tasnet/bloc/map_bloc.dart';
import 'package:geolocator/geolocator.dart';

import 'models/place.dart';

class CustomMapPage extends StatefulWidget {
  @override
  _CustomMapPageState createState() => _CustomMapPageState();
}
// void _onMapCreated(MapboxMapController controller) {
//     mapController = controller;
//   }

class _CustomMapPageState extends State<CustomMapPage> {
  MapboxMapController _controller;
  Position currentLocation;
  Future<Position> getCurrentLocation() async {
    //TODo: Fix the "latitude called on null" bug
    var geolocator = Geolocator();
    Position currentPosition;
    GeolocationStatus geolocationStatus =
        await geolocator.checkGeolocationPermissionStatus();
    // if (geolocationStatus.value == 2) {
    //0 denied  1 disabled  2 granted  3 restricted  4 unknown
    currentPosition = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(currentPosition.latitude);
    print(currentPosition.longitude);
    // } else {
    //   //TODO: ask for permission
    // }
    return currentPosition;
  }

  @override
  void initState() {
    getCurrentLocation().then((val) {
      currentLocation = val;
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _bloc = MapBloc();
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
          latlng: LatLng(41.3010197, 69.1975976)),
      Place(
          name: "KFC максим горький",
          description: "Ресторан быстрого питания",
          distance: "2 км",
          latlng: LatLng(41.326824, 69.330721)),
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
                onMapCreated: (val) {
                  _controller = val;
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(51.528308, -0.3817909),
                  // target: LatLng(
                  //     currentLocation.latitude, currentLocation.longitude),
                  zoom: 15.0,
                ),
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                  Factory<OneSequenceGestureRecognizer>(
                    () => EagerGestureRecognizer(),
                  ),
                ].toSet(),
              ),
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
            Align(
              alignment: Alignment.bottomCenter,
              child: StreamBuilder<bool>(
                  stream: _bloc.isBottomSheetExpanded,
                  initialData: false,
                  builder: (context, snapshot) {
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 500),
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
                                        // tilt: 30.0,
                                        zoom: 15.0,
                                      ),
                                    ),
                                  );
                                  _controller.clearCircles();
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
                                        trailing: Text(
                                          testList[index].distance,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.0),
                                        ),
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
                                // ),
                              ),
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
            )
          ],
        ),
      ),
    );
  }
}
