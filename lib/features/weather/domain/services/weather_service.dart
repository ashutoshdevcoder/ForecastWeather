import 'package:weather_forecast/features/weather/data/models/search_model.dart';
import 'package:weather_forecast/features/weather/data/models/weather_model.dart';
import 'package:weather_forecast/features/weather/data/repositories/weather_repository.dart';

class WeatherService {
  final WeatherRepository _weatherRepository;

  WeatherService(this._weatherRepository);

  Future<WeatherForecast> getCurrentWeather(String location) {
    return _weatherRepository.getCurrentWeather(location);
  }

  Future<SearchResult> searchLocation(String query) {
    return _weatherRepository.searchLocation(query);
  }
}
