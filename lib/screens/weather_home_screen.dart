import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart' as Geo;
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/bloc/forecast_weather_bloc.dart';
import 'package:weather_app/bloc/forecast_weather_event.dart';
import 'package:weather_app/bloc/forecast_weather_state.dart';
import 'package:weather_app/repo/weather_repo.dart';
import 'package:weather_app/screens/settings_page.dart';
import 'package:weather_app/utils/constants.dart';
import 'package:weather_app/utils/helper_function.dart';

import '../bloc/weather_bloc.dart';
import '../bloc/weather_event.dart';
import '../bloc/weather_state.dart';

class WeatherHomeScreen extends StatefulWidget {
  const WeatherHomeScreen({Key? key}) : super(key: key);
  static const routeName ='/home';

  @override
  State<WeatherHomeScreen> createState() => _WeatherHomeScreenState();
}

class _WeatherHomeScreenState extends State<WeatherHomeScreen> {
  // late WeatherProvider _provider;
  bool _isInit = true;
 late WeatherRepo weatherRepo = WeatherRepo();
 final CurrentWeatherBloc currentWeatherBloc = CurrentWeatherBloc(WeatherRepo());
 final ForecastWeatherBloc forecastWeatherBloc = ForecastWeatherBloc(WeatherRepo());
 final TextEditingController _textEditingController = TextEditingController();



  @override
  void didChangeDependencies() {
    if(_isInit){

        context.read<CurrentWeatherBloc>().add(CurrentWeatherLoadEvent());
        context.read<ForecastWeatherBloc>().add(ForecastWeatherLoadEvent());
     _init();
    }
    super.didChangeDependencies();
  }

  void _init() {
    determinePosition().then((position) {
      currentWeatherBloc.weatherRepo.setNewPosition(position.latitude, position.longitude);
      // weatherRepo.getData();
      weatherRepo.getCurrentData();
      weatherRepo.getForecastData();
      print('lat: ${position.latitude}, log: ${position.longitude}');
      _isInit = false;
    });
  }

  void _position() {
    determinePosition().then((position) {
      currentWeatherBloc.weatherRepo.setNewPosition(position.latitude, position.longitude);
      // weatherRepo.getData();
      currentWeatherBloc.weatherRepo.getCurrentData();
      currentWeatherBloc.weatherRepo.getForecastData();
      print('lat: ${position.latitude}, log: ${position.longitude}');
      _isInit = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.lightBlue,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Weather App'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: (){
              _init();
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async{
              final city = await showSearch(context: context, delegate: _CitySearchDelegate());
              if(city != null && city.isNotEmpty) {

                try{
                  final locationList = await Geo.locationFromAddress(city);
                  if(locationList.isNotEmpty) {
                    final location = locationList.first;
                    weatherRepo.setNewPosition(location.latitude, location.longitude);
                    currentWeatherBloc.weatherRepo.getData();
                    // currentWeatherBloc.weatherRepo.searchWeatherData();
                  }
                }catch(error) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: const Text("Could not find any result for the supplied address"),
                    // duration: const Duration(seconds: 5),
                  ));
                }
              }
            },
          ),
          // IconButton(
          //   icon: Icon(Icons.settings),
          //   onPressed: (){
          //     // Navigator.pushNamed(context, SettingsPage.routeName);
          //   },
          // )
        ],
      ),
      body: Stack(

        children: [
          Image.asset('images/seabeach.jpg',height:double.maxFinite,fit: BoxFit.cover,),
           BlocBuilder<CurrentWeatherBloc, CurrentWeatherState>(
              // bloc: currentWeatherBloc,
              builder: (context, state){
                if(state is CurrentWeatherLoading){
                  return Center(child: CircularProgressIndicator.adaptive());
                }else if(state is CurrentWeatherLoaded){
                  final currentWeatherData = state.weatherData;
                  print(currentWeatherData.dt);
                  return Center(
                    child: ListView(
                            padding: const EdgeInsets.all(16),
                            children: [
                         const SizedBox(height: 80,),
                           Column(
                             children: [

                                Text(getFormattedDate(state.weatherData.dt!, 'EEE MMM, YYYY'), style: TextStyle(fontSize: 16),),
                                Text('${state.weatherData.name}, ${state.weatherData.sys!.country}', style:  TextStyle(fontSize: 22),),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Image.network('$icon_prefix${state.weatherData.weather![0].icon}$icon_suffix', width: 50, height: 50, fit: BoxFit.cover,),
                                    Text('${state.weatherData.main!.temp!.toStringAsFixed(2)}\u00B0',style:  TextStyle(fontSize: 80),),
                                  ],
                                ),
                                Text('feels like ${state.weatherData.main!.feelsLike!.round()}\u00B0', style: TextStyle(fontSize: 20),),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.network('$icon_prefix${state.weatherData.weather![0].icon}$icon_suffix', width: 50, height: 50, fit: BoxFit.cover,),
                                    Text('${state.weatherData.weather![0].description}')
                                  ],
                                ),
                              ],
                            )
                         ]
                    )
                  );
                  // print('Current Weather: $currentWeatherData');
                }else if(state is CurrentWeatherError){
                  return Text('Failed to load current weather data');
                }else{
                  return SizedBox();
                }
              },
            ),

           SizedBox(height: 20,),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocBuilder<ForecastWeatherBloc, ForecastWeatherState>(
                  builder: (context, state){
                    if(state is ForecastWeatherLoading){
                      return const SizedBox();
                    }else if(state is ForecastWeatherLoaded){

                      return SizedBox(
                        width: double.maxFinite,
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.weatherData.list!.length,
                          itemBuilder: (context, i){
                            final item = state.weatherData.list![i];
                            final forecastDate = state.weatherData.list![0].dt!.toInt();
                            return Card(
                              color: Colors.black12.withOpacity(0.3),
                              margin: EdgeInsets.all(4),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Text(formattedDate(item.dt)),

                                      Text(formattedDate(forecastDate),style: TextStyle(color: Colors.white),),
                                      Image.network('$icon_prefix${item.weather![0].icon}$icon_suffix', width: 50, height: 50, fit: BoxFit.cover,),
                                      Text('${item.main!.tempMax!.round()}/${item.main!.tempMin!.round()}\u00B0',style: TextStyle(color: Colors.white)),
                                      Text(item.weather![0].description!, style: TextStyle(color: Colors.white))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }else if(state is ForecastWeatherError){
                      return Text('Failed to load forecast weather data');
                    }else{
                      return Container();
                    }
                  },
                ),
            ),
          ),
        ],
      )
    );
  }
}


class _CitySearchDelegate extends SearchDelegate<String>{
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, "");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListTile(
      onTap: () {
        close(context, query);
      },
      leading: const Icon(Icons.search),
      title: Text(query),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final filteredList = query.isEmpty ? cities : cities.where((element) => element.toLowerCase().startsWith(query.toLowerCase())).toList();
    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        ListTile(
          onTap: () {
            query = filteredList[index];
            close(context, query);
          },
          title: Text(filteredList[index]),
        );
      },
    );
  }

}