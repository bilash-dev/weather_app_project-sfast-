import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/bloc/weather_event.dart';
import 'package:weather_app/bloc/weather_state.dart';
import 'package:weather_app/models/current_weather_model.dart';

import '../repo/weather_repo.dart';


class CurrentWeatherBloc extends Bloc<CurrentWeatherEvent, CurrentWeatherState>{
  final WeatherRepo weatherRepo;
  CurrentWeatherBloc(this.weatherRepo) : super(CurrentWeatherLoading()){
    on<CurrentWeatherLoadEvent>((event, emit) async{
      emit(CurrentWeatherLoading());
      try{
        var response = await weatherRepo.getCurrentData();
        // print(response.runtimeType);
        // print(response!.dt);

        emit(CurrentWeatherLoaded(response!));

      }catch(e) {
        emit(CurrentWeatherError());
      }
    });

    on<FetchCurrentWeather>((event, emit) async{
      emit(CurrentWeatherLoading());
      try{
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high
        );
        CurrentWeatherModel weatherModel = await weatherRepo.searchWeatherData(position.latitude, position.longitude);

        emit(CurrentWeatherLoaded(weatherModel));
      }catch(e){
        emit(CurrentWeatherError());
      }
    });
  }
}
