import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static final String apiKey = dotenv.env['API_KEY']!;
  static const String baseUrl = 'http://api.weatherapi.com/v1';
  static const String currentWeatherData = '/forecast.json';
  static const String searchLocation = '/search.json';
}
