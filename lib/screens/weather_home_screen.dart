import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/provider/weather_provider.dart';
import 'package:weather_app/screens/settings_page.dart';
import 'package:weather_app/utils/constants.dart';
import 'package:weather_app/utils/helper_function.dart';

class WeatherHomeScreen extends StatefulWidget {
  const WeatherHomeScreen({Key? key}) : super(key: key);
  static const routeName ='/home';

  @override
  State<WeatherHomeScreen> createState() => _WeatherHomeScreenState();
}

class _WeatherHomeScreenState extends State<WeatherHomeScreen> {
  late WeatherProvider _provider;
  bool _isInit = true;
  @override
  void didChangeDependencies() {
    if(_isInit){
      _provider = Provider.of<WeatherProvider>(context);
      determinePosition().then((position) {
        _provider.setPosition(position);
        _provider.getCurrentData();
        _provider.getForecastData();
        print('lat: ${position.latitude}, log: ${position.longitude}');
        _isInit = false;
      });
    }
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Weather App'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: (){

            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){

            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: (){
              Navigator.pushNamed(context, SettingsPage.routeName);
            },
          )
        ],
      ),
      body: _provider.currentModel != null && _provider.forecastModel != null ? Stack(
        children: [
          Image.asset('images/sunset.jpg', width: double.infinity,height: double.infinity,fit: BoxFit.cover,),
          Center(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const SizedBox(height: 80,),
                Column(
                  children: [
                    Text(getFormattedDate(_provider.currentModel!.dt!, 'EEE MMM, YYYY'), style: TextStyle(fontSize: 16),),
                    Text('${_provider.currentModel!.name}, ${_provider.currentModel!.sys!.country!}', style:  TextStyle(fontSize: 22),),
                    Text('${_provider.currentModel!.main!.temp!.toStringAsFixed(2)}\u00B0',style:  TextStyle(fontSize: 80),),
                    Text('feels like ${_provider.currentModel!.main!.feelsLike!.round()}\u00B0', style: TextStyle(fontSize: 20),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network('$icon_prefix${_provider.currentModel!.weather![0].icon}$icon_suffix', width: 50, height: 50, fit: BoxFit.cover,),
                        Text('${_provider.currentModel!.weather![0].description}')
                      ],
                    )
                  ],
                ),
                SizedBox(height: 20,),
                SizedBox(
                  width: double.maxFinite,
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _provider.forecastModel!.list!.length,
                    itemBuilder: (context, i){
                      final item = _provider.forecastModel!.list![i];
                      return Card(
                        color: Colors.black.withOpacity(0.3),
                        margin: EdgeInsets.all(4),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(getFormattedDate(item.dt!, 'EEE HH:mm')),
                                Image.network('$icon_prefix${item.weather![0].icon}$icon_suffix', width: 50, height: 50, fit: BoxFit.cover,),
                                Text('${item.main!.tempMax!.round()}/${item.main!.tempMin!.round()}\u00B0'),
                                Text(item.weather![0].description!)
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ) : Center(child: const Text('Please wait...'),),
    );
  }
}
