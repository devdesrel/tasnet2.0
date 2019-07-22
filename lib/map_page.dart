import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tasnet/helpers/custom_bottomsheet.dart';
import 'bloc/map_bloc.dart';
import 'models/place.dart';
import 'package:swipedetector/swipedetector.dart';
import 'dart:math';

class MapPage extends StatelessWidget {
  final List<Place> testList = [
    Place(
        name: "Central Park",
        description: "Парк развлечений",
        distance: "12 км"),
    Place(
        name: "KFC",
        description: "Ресторан быстрого питания",
        distance: "2 км"),
    Place(name: "Level", description: "Something", distance: "9 км"),
    Place(
        name: "Central Park",
        description: "Парк развлечений",
        distance: "12 лм"),
    Place(
        name: "Central Park",
        description: "Парк развлечений",
        distance: "12 лм"),
    Place(
        name: "Central Park",
        description: "Парк развлечений",
        distance: "12 лм"),
    Place(
        name: "Central Park",
        description: "Парк развлечений",
        distance: "12 лм"),
    Place(
        name: "Central Park",
        description: "Парк развлечений",
        distance: "12 лм"),
    Place(
        name: "Central Park",
        description: "Парк развлечений",
        distance: "12 лм"),
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final double bottomSheetNormalHeight = 245.0;
    final double bottomSheetExpandedHeight = screenHeight - 110.0;
    var bloc = MapBloc();
    return Scaffold(
      body: SafeArea(
        child: Container(
          // color: Colors.red,
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Positioned(
                top: 35.0,
                left: 35.0,
                child: Image.asset(
                  'assets/logo.png',
                  height: 32.0,
                  width: 106.0,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SwipeDetector(
                  onSwipeUp: () {
                    bloc.isBottomSheetDraggedUp.add(true);
                  },
                  onSwipeDown: () {
                    bloc.isBottomSheetDraggedUp.add(false);
                  },
                  child: StreamBuilder(
                      stream: bloc.isBottomSheetDraggedUpStream,
                      initialData: false,
                      builder: (context, snapshot) {
                        return AnimatedContainer(
                          duration: Duration(seconds: 1),
                          height: snapshot.data
                              ? bottomSheetExpandedHeight
                              : bottomSheetNormalHeight,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Color(0xFF5252FF),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(60.0))),
                          child: Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              Positioned(
                                top: 10.0,
                                right: screenWidth / 2 - 15.0,
                                child: RotatedBox(
                                  quarterTurns: snapshot.data ? 90 : 0,
                                  child: InkWell(
                                    onTap: () {
                                      snapshot.data
                                          ? bloc.isBottomSheetDraggedUp
                                              .add(false)
                                          : bloc.isBottomSheetDraggedUp
                                              .add(true);
                                    },
                                    child: Icon(Icons.arrow_drop_up,
                                        size: 30.0, color: Colors.white),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 40.0, left: 40.0, right: 40.0),
                                child: ListView.builder(
                                  // physics: snapshot.data
                                  //     ? null
                                  //     : const NeverScrollableScrollPhysics(),
                                  itemCount: testList.length,
                                  itemBuilder: (context, index) => Padding(
                                        padding: EdgeInsets.only(bottom: 18.0),
                                        child: ListTile(
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
      ),
    );
  }
}
