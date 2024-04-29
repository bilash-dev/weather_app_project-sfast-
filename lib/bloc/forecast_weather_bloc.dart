import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/bloc/forecast_weather_event.dart';
import 'package:weather_app/bloc/forecast_weather_state.dart';
import 'package:weather_app/repo/weather_repo.dart';

class ForecastWeatherBloc extends Bloc<ForecastWeatherEvent, ForecastWeatherState>{
  final WeatherRepo weatherRepo;
  ForecastWeatherBloc(this.weatherRepo) : super(ForecastWeatherLoading()){
    on<ForecastWeatherLoadEvent>((event, emit) async{
      emit(ForecastWeatherLoading());
      try{
        var forecastresponse = await weatherRepo.getForecastData();
        emit(ForecastWeatherLoaded(forecastresponse!));
      }catch(e){
        emit(ForecastWeatherError());
      }
    });
  }
}