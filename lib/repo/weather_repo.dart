import 'dart:convert';

import '../models/current_weather_model.dart';
import 'package:http/http.dart' as Http;

import '../models/forecast_weather_model.dart';
import '../utils/constants.dart';
import '../utils/helper_function.dart';

class WeatherRepo{
  double latitude = 0.0;
  double longitude = 0.0;
  CurrentWeatherModel? _currentModel;
  String? city;
  bool status = false;
  String tempUnit = 'metric';

  CurrentWeatherModel? get currentModel => _currentModel;

  void setNewPosition(double lat, double lon) {
    latitude = lat;
    longitude = lon;
  }

  void setStatus(bool status){
    this.status = status;
    tempUnit = status? 'imperial' : 'metric';
  }

  void getStatus() async{
    status = await getTempStatus();
    tempUnit = status ? 'imperial' : 'metric';
  }
  void getData() {
    getCurrentData();
    getForecastData();
    // searchWeatherData(city!);
  }

  Future<CurrentWeatherModel?> getCurrentData() async{
    final url  = 'https://api.openweathermap.org/data/2.5/weather?lat=23.8041&lon=90.4152&units=$tempUnit&appid=$weatherApiKey';
    try{
      final response = await Http.get(Uri.parse(url));
      final map = json.decode(response.body);
      // print(map.runtimeType);
      // print(map);
      if(response.statusCode ==200){
         return CurrentWeatherModel.fromJson(map);
      }else{
        print(map['message']);
      }
    }catch(error){
      throw error;
    }
  }

  //search city
  Future<dynamic> searchWeatherData(double latitude, double longitude) async{
    final url  = 'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&units=$tempUnit&appid=$weatherApiKey';
    try{
      final response = await Http.get(Uri.parse(url));
      // final map = json.decode(response.body);
      // print(map.runtimeType);
      // print(map);
      if(response.statusCode ==200){
        // return CurrentWeatherModel.fromJson(map);
        return json.decode(response.body);
      }else{
        print(['message']);
      }
    }catch(error){
      throw error;
    }
  }

  Future<ForecastWeatherModel?> getForecastData() async{
    final url  = 'https://api.openweathermap.org/data/2.5/forecast?lat=23.8041&lon=90.4152&units=$tempUnit&appid=$weatherApiKey';
    try{
      final response = await Http.get(Uri.parse(url));
      final map = json.decode(response.body);
      if(response.statusCode ==200){
        return ForecastWeatherModel.fromJson(map);
      }else{
        print(map['message']);
      }
    }catch(error){
      throw error;
    }

  }
}