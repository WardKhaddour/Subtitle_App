import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/input_provider.dart';
import './providers/imdb_provider.dart';
import './screens/settings_screen.dart';
import './screens/welcome_screen.dart';
import './screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => IMDBProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => InputProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        // home: Scaffold(
        //   body: WelcomeScreen(),
        // ),
        initialRoute: WelcomeScreen.routeName,
        routes: {
          WelcomeScreen.routeName: (context) => WelcomeScreen(),
          HomeScreen.routeName: (context) => HomeScreen(),
          SettingsScreen.routeName: (context) => SettingsScreen(),
        },
      ),
    );
  }
}
