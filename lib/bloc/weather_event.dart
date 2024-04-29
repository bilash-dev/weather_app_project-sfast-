import 'package:equatable/equatable.dart';

// Event
abstract class CurrentWeatherEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CurrentWeatherLoadEvent extends CurrentWeatherEvent{
  @override
  List<Object?> get props => [];
}

class FetchCurrentWeather extends CurrentWeatherEvent {
  final String cityName;
  FetchCurrentWeather(this.cityName);
}