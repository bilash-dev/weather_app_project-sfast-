// State
import 'package:equatable/equatable.dart';

import '../models/forecast_weather_model.dart';

abstract class ForecastWeatherState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ForecastWeatherLoading extends ForecastWeatherState {}

class ForecastWeatherLoaded extends ForecastWeatherState {
  final ForecastWeatherModel weatherData;
  ForecastWeatherLoaded(this.weatherData);

  @override
  List<Object?> get props => [weatherData];
}

class ForecastWeatherError extends ForecastWeatherState {}