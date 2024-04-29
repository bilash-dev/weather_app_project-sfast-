import 'package:equatable/equatable.dart';

abstract class ForecastWeatherEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ForecastWeatherLoadEvent extends ForecastWeatherEvent{
  @override
  List<Object?> get props => [];
}

class FetchForecastWeather extends ForecastWeatherEvent {
  final String cityName;
  FetchForecastWeather(this.cityName);
}