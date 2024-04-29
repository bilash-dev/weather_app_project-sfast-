import 'package:equatable/equatable.dart';
import 'package:weather_app/models/current_weather_model.dart';

// State
abstract class CurrentWeatherState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CurrentWeatherLoading extends CurrentWeatherState {}

class CurrentWeatherLoaded extends CurrentWeatherState {
  final CurrentWeatherModel weatherData;
  CurrentWeatherLoaded(this.weatherData);

  @override
  List<Object?> get props => [weatherData];
}

class CurrentWeatherError extends CurrentWeatherState {}