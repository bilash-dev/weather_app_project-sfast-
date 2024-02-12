import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/models/current_weather_model.dart';
import 'package:weather_app/models/forecast_weather_model.dart';
import 'package:weather_app/utils/constants.dart';
import 'package:http/http.dart' as Http;


class WeatherProvider with ChangeNotifier {
  double latitude = 0.0;
  double longitude = 0.0;
  late Position position;
  CurrentWeatherModel? _currentModel;
  ForecastWeatherModel? _forecastModel;
  String? city;
  bool status = false;
  String tempUnit = 'metric';

  void setStatus(bool status){
    this.status = status;
    tempUnit = status? 'imperial' : 'metric';
    notifyListeners();
  }

  CurrentWeatherModel? get currentModel => _currentModel;
  ForecastWeatherModel? get forecastModel => _forecastModel;

  void setPosition(Position pos) {
    position = pos;
  }

  Future<void> getCurrentData() async{
    final url  = 'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&units=metric&appid=$weatherApiKey';
    try{
      final response = await Http.get(Uri.parse(url));
      final map = json.decode(response.body);
      if(response.statusCode ==200){
        _currentModel = CurrentWeatherModel.fromJson(map);
        notifyListeners();
      }else{
        print(map['message']);
      }
    }catch(error){
      throw error;
    }
  }

  Future<void> getForecastData() async{
    final url  = 'https://api.openweathermap.org/data/2.5/forecast?lat=${position.latitude}&lon=${position.longitude}&units=metric&appid=$weatherApiKey';
    try{
      final response = await Http.get(Uri.parse(url));
      final map = json.decode(response.body);
      if(response.statusCode ==200){
        _forecastModel = ForecastWeatherModel.fromJson(map);
        notifyListeners();
      }else{
        print(map['message']);
      }
    }catch(error){
      throw error;
    }

  }

}
