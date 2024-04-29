import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/bloc/forecast_weather_bloc.dart';
import 'package:weather_app/bloc/weather_bloc.dart';
import 'package:weather_app/repo/weather_repo.dart';
import 'package:weather_app/screens/settings_page.dart';
import 'package:weather_app/screens/weather_home_screen.dart';

void main() {
  runApp(RepositoryProvider(
      create: (context) => WeatherRepo(),
  child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CurrentWeatherBloc(WeatherRepo()),
        ),
        BlocProvider(create: (context)=> ForecastWeatherBloc(WeatherRepo()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'RobotoSlab',
        primarySwatch: Colors.blue,
        // brightness: Brightness.dark
      ),
        home:
        // WeatherHomePage(),
        WeatherHomeScreen(),
        routes: {
          WeatherHomeScreen.routeName: (context) => WeatherHomeScreen(),
          // SettingsPage.routeName: (context) => SettingsPage(),
        },
      ),
    );
  }
}


