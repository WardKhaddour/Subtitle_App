// import 'package:flutter/material.dart';
// import 'loading_image.dart';
// import '../screens/settings_screen.dart';

// class MyDrawer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Drawer(
//         child: Column(
//           children: [
//             SizedBox(
//               height: 30,
//             ),
//             Expanded(
//               flex: 3,
//               child: Container(
//                 color: Colors.white,
//                 child: Column(
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.of(context)
//                             .pushNamed(SettingsScreen.routeName);
//                       },
//                       child: Container(
//                         color: Colors.green.shade800,
//                         child: ListTile(
//                           title: Text(
//                             'Settings',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 20,
//                             ),
//                           ),
//                           trailing: Icon(
//                             Icons.settings,
//                             color: Colors.white,
//                             size: 20,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 30),
//             Expanded(
//               flex: 1,
//               child: Container(
//                 color: Colors.white,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // Image(
//                     //   image: AssetImage(
//                     //     'assets/images/tasqment-logo.jpg',
//                     //   ),
//                     //   fit: BoxFit.fill,
//                     // ),
//                     LoadingImage(),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
