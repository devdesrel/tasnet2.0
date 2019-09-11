import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tasnet/custom_map_page.dart';
import 'package:tasnet/packages_page.dart';
import 'package:tasnet/settings_page.dart';
import 'package:tasnet/support_page.dart';

import 'bloc/main_menu_bloc.dart';
import 'helpers/constants.dart';

class MainMenuPage extends StatefulWidget {
  final double initialLat;
  final double initialLong;

  MainMenuPage({@required this.initialLat, @required this.initialLong});
  @override
  _MainMenuPageState createState() => _MainMenuPageState();
}

List<MenuItem> mainMenuItems = [
  MenuItem(
      icon: Icons.shopping_cart, item: Menu.INTERNETPACKAGES, name: 'Packages'),
  MenuItem(icon: Icons.my_location, item: Menu.MAP, name: 'Map'),
];
List<MenuItem> supportMenuItems = [
  MenuItem(icon: Icons.settings, item: Menu.SETTINGS, name: 'Settings'),
  MenuItem(icon: Icons.contact_phone, item: Menu.SUPPORT, name: 'Support'),
];
var bloc = MainMenuBloc();

class _MainMenuPageState extends State<MainMenuPage> {
  @override
  void dispose() {
    bloc.dispose(); //TODO: dispose the map BLOC
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double contentShrinkedWidth = 100;
    double contentShrinkedHeight = screenHeight / 1.5;

    return Scaffold(
      body: StreamBuilder<bool>(
          stream: bloc.isMenuButtonPressedStream,
          initialData: false,
          builder: (context, snapshot) {
            return Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Color(0xFF5252FF),
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Positioned(
                          top: screenHeight / 4,
                          left: 16.0,
                          child: Container(
                            height: screenHeight / 3,
                            width: screenWidth / 1.7,
                            // color: Colors.red,
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: mainMenuItems.length,
                              itemBuilder: (context, index) => ListTile(
                                onTap: () {
                                  bloc.getSelectedMenu.add(Menu.values[index]);
                                  bloc.isMenuButtonPressed.add(snapshot.hasData
                                      ? snapshot.data ? false : true
                                      : false);
                                },
                                leading: Icon(
                                  mainMenuItems[index].icon,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                title: Text(
                                  mainMenuItems[index].name,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            child: Container(
                              // color: Colors.yellow,
                              height: screenHeight / 4,
                              width: screenWidth / 1.7,
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: supportMenuItems.length,
                                itemBuilder: (context, index) => ListTile(
                                  onTap: () {
                                    bloc.getSelectedMenu
                                        .add(Menu.values[index + 2]);
                                    bloc.isMenuButtonPressed.add(
                                        snapshot.hasData
                                            ? snapshot.data ? false : true
                                            : false);
                                  },
                                  leading: Icon(
                                    supportMenuItems[index].icon,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  title: Text(
                                    supportMenuItems[index].name,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: snapshot.hasData
                            ? snapshot.data
                                ? Radius.circular(10.0)
                                : Radius.zero
                            : Radius.zero,
                        bottomLeft: snapshot.hasData
                            ? snapshot.data
                                ? Radius.circular(10.0)
                                : Radius.zero
                            : Radius.zero),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 700),
                      // curve: Curves.decelerate,
                      curve: Curves.easeInCubic,
                      decoration: BoxDecoration(
                          color: Colors.yellow, boxShadow: [BoxShadow()]),
                      height: snapshot.hasData
                          ? snapshot.data ? contentShrinkedHeight : screenHeight
                          : screenHeight,
                      width: snapshot.hasData
                          ? snapshot.data ? contentShrinkedWidth : screenWidth
                          : screenWidth,
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          StreamBuilder<Menu>(
                              stream: bloc.selectedMenu,
                              initialData: Menu.MAP,
                              builder: (context, shot) {
                                return getMenu(
                                    isBottomSheetVisible: snapshot.hasData
                                        ? snapshot.data ? false : true
                                        : true,
                                    menuItem:
                                        shot.hasData ? shot.data : Menu.MAP,
                                    initialLat: widget.initialLat,
                                    initialLong: widget.initialLong);
                              }),
                          Positioned(
                            top: -60,
                            left: -60,
                            child: SafeArea(
                              child: GestureDetector(
                                onTap: () {
                                  if (snapshot.hasData && snapshot.data) {
                                    bloc.isMenuButtonPressed.add(false);
                                  } else {
                                    bloc.isMenuButtonPressed.add(true);
                                  }
                                },
                                child: Transform.rotate(
                                  angle: pi,
                                  child: ClipPath(
                                    clipper: CustomHalfCircleClipper(),
                                    child: Container(
                                        height: 120.0,
                                        width: 120.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFF5252FF),
                                        ),
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: <Widget>[
                                            Positioned(
                                              top: 20,
                                              left: 20,
                                              child: Transform.rotate(
                                                angle: -pi / 4,
                                                child: Icon(
                                                  Icons.menu,
                                                  size: 30.0,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
                                          ],
                                        )),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                snapshot.hasData
                    ? snapshot.data
                        ? Positioned(
                            top: (screenHeight - contentShrinkedHeight) / 2,
                            right: 0.0,
                            child: InkWell(
                              onTap: () {
                                if (snapshot.hasData && snapshot.data) {
                                  bloc.isMenuButtonPressed.add(false);
                                } else {
                                  bloc.isMenuButtonPressed.add(true);
                                }
                              },
                              child: Container(
                                height: snapshot.hasData
                                    ? snapshot.data
                                        ? contentShrinkedHeight
                                        : screenHeight
                                    : screenHeight,
                                width: snapshot.hasData
                                    ? snapshot.data
                                        ? contentShrinkedWidth
                                        : contentShrinkedWidth
                                    : contentShrinkedWidth,
                              ),
                            ),
                          )
                        : Container(
                            height: 0.0,
                            width: 0.0,
                          )
                    : Container(
                        height: 0.0,
                        width: 0.0,
                      )
              ],
            );
          }),
    );
  }
}

getMenu(
    {Menu menuItem,
    bool isBottomSheetVisible,
    double initialLat,
    double initialLong}) {
  switch (menuItem) {
    case Menu.INTERNETPACKAGES:
      return PackagesPage();
      break;
    case Menu.MAP:
      return CustomMapPage(
        isBottomSheetVisible: isBottomSheetVisible,
        initialLat: initialLat,
        initialLong: initialLong,
      );
      break;
    case Menu.SETTINGS:
      return SettingsPage();
      break;
    case Menu.SUPPORT:
      return SupportPage();
      break;

    default:
      CustomMapPage(
        isBottomSheetVisible: isBottomSheetVisible,
        initialLat: initialLat,
        initialLong: initialLong,
      );
  }
}

class MenuItem {
  Menu item;
  IconData icon;
  String name;
  MenuItem({@required this.icon, @required this.item, @required this.name});
}

class CustomHalfCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = new Path();

    path.lineTo(0.0, size.height / 2);
    path.lineTo(size.width / 2, size.height / 2);
    path.lineTo(size.width / 2, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
