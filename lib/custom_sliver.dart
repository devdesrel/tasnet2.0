import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'map_test.dart';
import 'models/place.dart';

class CustomSliver extends StatefulWidget {
  @override
  _CustomSliverState createState() => _CustomSliverState();
}

class _CustomSliverState extends State<CustomSliver> {
  @override
  Widget build(BuildContext context) {
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
    return Scaffold(
      // navigationBar: CupertinoNavigationBar(
      //   leading: Image.asset(
      //     'assets/logo.png',
      //     height: 32.0,
      //     width: 106.0,
      //   ),
      // ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            pinned: true,
            expandedHeight: 350.0,
            snap: true,
            bottom: PreferredSize(
              preferredSize: Size(100.0, 100.0),
              child: Container(
                color: Colors.white,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: SafeArea(
                child: Container(
                  color: Colors.red,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      LineBody(),
                      // FlutterMap(
                      //   options: MapOptions(
                      //     center: LatLng(51.5, -0.09),
                      //     zoom: 13.0,
                      //   ),
                      //   layers: [
                      //     new TileLayerOptions(
                      //       urlTemplate: "https://api.tiles.mapbox.com/v4/"
                      //           "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
                      //       additionalOptions: {
                      //         'accessToken': '<PUT_ACCESS_TOKEN_HERE>',
                      //         'id': 'mapbox.streets',
                      //       },
                      //     ),
                      //     new MarkerLayerOptions(
                      //       markers: [
                      //         new Marker(
                      //           width: 80.0,
                      //           height: 80.0,
                      //           point: new LatLng(51.5, -0.09),
                      //           builder: (ctx) => new Container(
                      //             child: new FlutterLogo(),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ],
                      // ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(39.0),
                          child: Image.asset(
                            'assets/logo.png',
                            height: 32.0,
                            width: 102.0,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              return Material(
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xFF5252FF),
                      borderRadius: index == 0
                          ? BorderRadius.only(topLeft: Radius.circular(60.0))
                          : null),
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: 18.0, top: index == 0 ? 18.0 : 0.0),
                    child: ListTile(
                      leading: Opacity(
                        opacity: 0.2,
                        child: Container(
                          height: 60.0,
                          width: 60.0,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Color(0xFFFFFFFF)),
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
                        style: TextStyle(color: Colors.white54, fontSize: 12.0),
                      ),
                      trailing: Text(
                        testList[index].distance,
                        style: TextStyle(color: Colors.white, fontSize: 12.0),
                      ),
                    ),
                  ),
                ),
              );
            }, childCount: testList.length),
          )
        ],
      ),
    );
  }
}
