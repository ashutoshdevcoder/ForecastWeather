import 'package:weather_forecast/core/api/api_constants.dart';
import 'package:weather_forecast/core/api/api_service.dart';
import 'package:weather_forecast/features/weather/data/models/search_model.dart';
import 'package:weather_forecast/features/weather/data/models/weather_model.dart';

class WeatherRepository {
  final ApiService _apiService;

  WeatherRepository(this._apiService);

  Future<WeatherForecast> getCurrentWeather(String location) async {
    final response = await _apiService.getData(
      ApiConstants.currentWeatherData,
      queryParameters: {
        'key': ApiConstants.apiKey,
        'q': location,
        'days': 3,
        'aqi': 'yes',
        'alerts': 'no',
      },
    );

    return WeatherForecast.fromJson(response.data);
  }

  Future<SearchResult> searchLocation(String query) async {
    final response = await _apiService.getData(
      ApiConstants.searchLocation,
      queryParameters: {
        'key': ApiConstants.apiKey,
        'q': query,
      },
    );

    return SearchResult.fromJson(response.data);
  }
}
