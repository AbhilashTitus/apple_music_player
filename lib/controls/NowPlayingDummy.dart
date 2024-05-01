// import 'package:flutter/material.dart';

// class NowPlayingDummy extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'N O W  P L A Y I N G',
//           textAlign: TextAlign.center,
//         ),
//         centerTitle: true,
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Card(
//               color: Colors.grey[200],
//               elevation: 10.0,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15.0),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(80.0),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Container(
//                       height: 200,
//                       width: 200,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20),
//                         image: DecorationImage(
//                           image: AssetImage('assets/newlogo.png'),
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 1),
//                     Text(
//                       "No song selected",
//                       overflow: TextOverflow.ellipsis,
//                       maxLines: 1,
//                       style: const TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 1),
//                     Text(
//                       "",
//                       overflow: TextOverflow.ellipsis,
//                       maxLines: 1,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   IconButton(
//                     onPressed: null,
//                     icon: Icon(
//                       Icons.shuffle,
//                       color: Colors.grey,
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: null,
//                     icon: Icon(
//                       Icons.repeat,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 1),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 24.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text("00:00"),
//                     Text("00:00"),
//                   ],
//                 ),
//               ),
//               Slider(
//                 value: 0.0,
//                 min: 0.0,
//                 max: 1.0,
//                 onChanged: null,
//                 activeColor: Colors.black,
//               ),
//               const SizedBox(height: 1),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   IconButton(
//                     onPressed: null,
//                     icon: const Icon(Icons.skip_previous),
//                   ),
//                   ElevatedButton(
//                     onPressed: null,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color.fromARGB(255, 255, 255, 255),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Icon(
//                         Icons.play_arrow,
//                         size: 60.0,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: null,
//                     icon: const Icon(Icons.skip_next),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
