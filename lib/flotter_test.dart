// import 'package:flotter/flotter.dart';
// import 'package:flutter/material.dart';

// //TODO: iOS Test
// class FlotterTest extends StatefulWidget {
//   @override
//   _FlotterTestState createState() => _FlotterTestState();
// }

// class _FlotterTestState extends State<FlotterTest> {
//   static var controller = FlotterAnimationController(
//     'assets/test.json',
//     '123',
//     loopMode: FlotterLoopMode.loop, // FlotterLoopMode.playOnce by default
//   );
//   var animation = FlotterAnimation(controller);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         mainAxisSize: MainAxisSize.max,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: <Widget>[
//           Container(
//             color: Colors.red,
//             height: 500,
//             width: double.infinity,
//             child: Center(child: animation),
//           ),
//           RaisedButton(
//             onPressed: () {
//               controller.play();
//             },
//             child: Text('Play'),
//           ),
//         ],
//       ),
//     );
//   }
// }
