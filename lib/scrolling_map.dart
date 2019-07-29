// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class ScrollingMapBody extends StatelessWidget {
  ScrollingMapBody({@required this.center});

  // final LatLng center = const LatLng(41.339753, 69.2753499);
  final LatLng center;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: MapboxMap(
            onMapCreated: onMapCreated,
            initialCameraPosition: CameraPosition(
              target: center,
              zoom: 15.0,
            ),
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
              Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer(),
              ),
            ].toSet(),
          ),
        ),
      ),
    );
  }

  void onMapCreated(MapboxMapController controller) {
    controller.addSymbol(SymbolOptions(
        geometry: LatLng(
          center.latitude,
          center.longitude,
        ),
        iconImage: "airport-15"));
    controller
      // ..addLine(
      //   LineOptions(
      //     geometry: [
      //       // LatLng(-33.86711, 151.1947171),
      //       // LatLng(-33.86711, 151.1947171),
      //       // LatLng(-32.86711, 151.1947171),
      //       // LatLng(-33.86711, 152.1947171),
      //     ],
      //     lineColor: "#ff0000",
      //     lineWidth: 7.0,
      //     lineOpacity: 0.5,
      //   ),
      // )
      // ..addSymbol(SymbolOptions(
      //     geometry: LatLng(
      //       center.latitude,
      //       center.longitude,
      //     ),
      //     iconImage: "harbor_icon",
      //     iconSize: 25.0,
      //     iconColor: "red")
      // )

      // ..addSymbol(SymbolOptions(
      //     geometry: LatLng(
      //       69.287532, //Chitir Chicken
      //       41.311067,
      //     ),
      //     iconImage: "harbor_icon",
      //     iconSize: 25.0,
      //     iconColor: "red"))
      // ..addSymbol(SymbolOptions(
      //     geometry: LatLng(
      //       41.3201463, //Youth union
      //       69.2603403,
      //     ),
      //     iconImage: "harbor_icon",
      //     iconSize: 25.0,
      //     iconColor: "red"))
      // ..addSymbol(SymbolOptions(
      //     geometry: LatLng(
      //       41.3112912, //Assorti
      //       69.283862,
      //     ),
      //     iconImage: "harbor_icon",
      //     iconSize: 25.0,
      //     iconColor: "red"))
      ..addCircle(
        CircleOptions(
            circleColor: "red",
            circleRadius: 20.0,
            geometry: LatLng(center.latitude, center.longitude)),
      );
  }
}
