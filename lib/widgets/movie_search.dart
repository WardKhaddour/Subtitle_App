// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/imdb_provider.dart';

// import 'error_message.dart';

// class MovieSearch extends StatelessWidget {
//   MovieSearch({
//     @required this.name,
//   });

//   final String name;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.all(15),
//       padding: EdgeInsets.all(15),
//       width: 100,
//       height: 70,
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(30),
//           color: Colors.lightBlueAccent),
//       child: TextButton(
//         onPressed: () async {
//           print('searching');
//           // Provider.of<IMDBProvider>(context, listen: false).error != null?
//           await Provider.of<IMDBProvider>(context, listen: false)
//               .getData(name, '', '');
//           // : await showDialog(
//           //     context: context,
//           //     builder: (context) => ErrorMessage(),
//           // );
//           print('finish search');
//           print(Provider.of<IMDBProvider>(context, listen: false).error);
//         },
//         child: Text(
//           'Search',
//           style: TextStyle(
//             color: Colors.black,
//           ),
//         ),
//       ),
//     );
//   }
// }
