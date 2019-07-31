import 'package:flutter/material.dart';
import 'package:tasnet/bloc/authorization_bloc.dart';

import 'custom_map_page.dart';

class AuthorizationPage extends StatefulWidget {
  @override
  _AuthorizationPageState createState() => _AuthorizationPageState();
}

class _AuthorizationPageState extends State<AuthorizationPage> {
  var bloc = AuthorizationBloc();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  Future<bool> saveUserCredentials() async {
    var form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Opacity(
        opacity: 0.9,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              // Add one stop for each color. Stops should increase from 0 to 1
              stops: [0.09, 0.2, 0.3, 0.4, 0.5, 0.6, 0.9],
              colors: [
                // Colors are easy thanks to Flutter's Colors class.
                Color(0xFF4BA8AA),
                Color(0xFF52A9B3),
                //#52A9B3
                Color(0xFF5796AF),
                Color(0xFF5B8CAD),
                Color(0xFF6778AC),
                //#5B8CAD
                //#6778AC
                Color(0xFF675F8C),
                // #675F8C
                // Color(0xFF292E54),
                Color(0xFF292E54),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: ListView(
                // mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 20.0),
                    child: Icon(
                      Icons.add_circle_outline,
                      size: 100.0,
                      color: Colors.white30,
                    ),
                  ),
                  TextFormField(
                    style: Theme.of(context).textTheme.body2.copyWith(
                        color: Colors.white, decorationColor: Colors.white),
                    autofocus: false,
                    autovalidate: false,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Name",
                      labelStyle: TextStyle(color: Colors.white30),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please fill name field";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (val) {
                      bloc.userNumber.add(val);
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    style: Theme.of(context).textTheme.body2.copyWith(
                        color: Colors.white, decorationColor: Colors.white),
                    autofocus: false,
                    autovalidate: false,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Age",
                      labelStyle: TextStyle(color: Colors.white30),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please fill age field";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (val) {
                      bloc.userAge.add(val);
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    style: Theme.of(context).textTheme.body2.copyWith(
                        color: Colors.white, decorationColor: Colors.white),
                    autofocus: false,
                    autovalidate: false,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Number",
                      labelStyle: TextStyle(color: Colors.white30),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please fill number field";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (val) {
                      bloc.userNumber.add(val);
                    },
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 12.0),
                    child: RaisedButton(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      color: Theme.of(context).accentColor,
                      elevation: 8.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(100.0)),
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        // bloc.getMacAddree();
                        saveUserCredentials().then((resp) {
                          resp
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => CustomMapPage()))
                              : null;
                        });
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (_) => CustomMapPage()));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
