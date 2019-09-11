// import 'package:flutter/material.dart';
// import 'package:fluttie/fluttie.dart';

// class FluttieTest extends StatefulWidget {
//   @override
//   _FluttieTestState createState() => _FluttieTestState();
// }

// var emojiComposition;
// var emojiAnimation;
// initialmethod() async {
//   var instance = Fluttie();
//   emojiComposition = await instance.loadAnimationFromAsset(
//     "assets/test.json", //Replace this string with your actual file
//   );
//   emojiAnimation = await instance.prepareAnimation(emojiComposition);
// }

// class _FluttieTestState extends State<FluttieTest> {
//   @override
//   void initState() {
//     initialmethod();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         mainAxisSize: MainAxisSize.max,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: <Widget>[
//           Container(
//             height: 500.0,
//             width: double.infinity,
//             color: Colors.transparent,
//             child: Center(child: FluttieAnimation(emojiAnimation)),
//           ),
//           RaisedButton(
//             onPressed: () {
//               emojiAnimation.start();
//             },
//             child: Text('Play'),
//           )
//         ],
//       ),
//     );
//   }
// }
