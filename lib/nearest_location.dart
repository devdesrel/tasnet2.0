import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' show Position;
import 'package:tasnet/bloc/main_provider.dart';
import 'package:tasnet/bloc/nearest_location_bloc.dart';
import 'package:tasnet/helpers/geolocator_service.dart';
import 'package:tasnet/main_menu.dart';

class NearestLocationsPage extends StatefulWidget {
  // final NearestPlaceBloc bloc;
  // NearestLocationsPage({this.bloc});

  @override
  NearestLocationsPageState createState() => NearestLocationsPageState();
}

// var bloc = NearestPlaceBloc();
class NearestLocationsPageState extends State<NearestLocationsPage> {
  GeolocatorService geolocatorService = new GeolocatorService();
  Future<void> turnOnLocation() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Location is Off'),
          content: SingleChildScrollView(
            child: Text('Please, enable your location'),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('No, thanks'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Ok'),
              onPressed: () async {
                await BlocProvider.of<NearestPlaceBloc>(context)
                    .openLocationSettings();
                Future.delayed(Duration(seconds: 5), () {
                  setState(() {});
                });
              },
            ),
          ],
        );
      },
    );
  }

  distanceMeasurement(double distance) {
    var res;
    if (distance != null) {
      distance > 1000
          ? res = (distance / 1000).toStringAsFixed(1) + " km"
          : res = distance.round().toString() + " m";
    }
    return res;
  }

  @override
  void initState() {
    geolocatorService.isLocationEnabled().then((val) {
      if (!val) {
        return showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Location is Off'),
              content: SingleChildScrollView(
                child: Text('Please, enable your location'),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('No, thanks'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await BlocProvider.of<NearestPlaceBloc>(context)
                        .openLocationSettings();
                    Future.delayed(Duration(seconds: 5), () {
                      setState(() {});
                    });
                  },
                ),
              ],
            );
          },
        );
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<NearestPlaceBloc>(context);

    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            // alignment: WrapAlignment.center,
            // crossAxisAlignment: WrapCrossAlignment.center,
            // direction: Axis.vertical,
            children: <Widget>[
              Container(
                height: 200,
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Color(0xFF5252FF),
                    borderRadius: BorderRadius.circular(30)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Your Location ',
                          // style: TextStyle(color: Colors.white),
                        ),
                        StreamBuilder<Position>(
                            stream: bloc.currentPositions,
                            builder: (context, shott) {
                              return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      shott.hasData
                                          ? shott.data.latitude.toString()
                                          : "NO DATA",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Text(
                                      shott.hasData
                                          ? shott.data.longitude.toString()
                                          : "NO DATA",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ]);
                            })
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('Distance between the nearest location '),
                        StreamBuilder<double>(
                            stream: bloc.distanceDouble,
                            builder: (context, shottt) {
                              return Text(
                                shottt.hasData
                                    ? distanceMeasurement(shottt.data) ??
                                        'NO DATA'
                                    : 'NO DATA',
                                style: TextStyle(color: Colors.white),
                              );

                              // Row(children: <Widget>[
                              //   Text(shottt.hasData
                              //       ? shottt.data.distance.toString()
                              //       : "Couldn't identified"),
                              //   Text(shottt.hasData
                              //       ? shottt.data.measurement
                              //       : "Couldn't identified"),
                              // ]);
                            })
                      ],
                    ),
                  ],
                ),
              ),
              RaisedButton(
                color: Color(0xFF5252FF),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => MainMenuPage(
                              initialLat: bloc.selectedPositionLat ??
                                  bloc.currentPosition.latitude,
                              initialLong: bloc.selectedPositionLong ??
                                  bloc.currentPosition.longitude)));
                },
                child: Icon(
                  Icons.map,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),

        // Align(
        //   child: IconButton(
        //     icon: Icon(Icons.refresh),
        //     onPressed: () {
        //       // bloc.lala();
        //     },
        //   ),
        //   alignment: Alignment.bottomCenter,
        // ),
        // Align(
        //   alignment: Alignment.center,
        //   child: snapshot.hasData
        //       ? snapshot.data
        //           ? CircularProgressIndicator()
        //           : Container(height: 0.0, width: 0.0)
        //       : Container(height: 0.0, width: 0.0),
        // )
      ],
    ));
  }
}
