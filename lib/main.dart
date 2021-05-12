import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/welcome_screen.dart';
import './providers/imdb_provider.dart';
import './screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => IMDBProvider(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark(),
          home: Scaffold(
            body: HomeScreen(),
          ),
          initialRoute: WelcomeScreen.routeName,
          routes: {
            WelcomeScreen.routeName: (context) => WelcomeScreen(),
            HomeScreen.routeName: (context) => HomeScreen(),
          }),
    );
  }
}
