import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/provider/weather_provider.dart';
import 'package:weather_app/screens/settings_page.dart';
import 'package:weather_app/screens/weather_home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: ((context) => WeatherProvider()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          fontFamily: 'RobotoSlab',
          primarySwatch: Colors.blue,
          brightness: Brightness.dark
        ),
        home: WeatherHomeScreen(),
        routes: {
          WeatherHomeScreen.routeName: (context) => WeatherHomeScreen(),
          SettingsPage.routeName: (context) => SettingsPage(),
        },
      ),
    );
  }
}


