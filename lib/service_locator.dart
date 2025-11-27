import 'dart:async';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_forecast/core/api/api_constants.dart';
import 'package:weather_forecast/core/api/api_interceptor.dart';
import 'package:weather_forecast/core/api/api_service.dart';
import 'package:weather_forecast/features/weather/data/repositories/weather_repository.dart';
import 'package:weather_forecast/features/weather/domain/services/weather_service.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  // Dio and ApiService
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );
  dio.interceptors.add(ApiInterceptor());

  getIt.registerLazySingleton<Dio>(() => dio);
  getIt.registerLazySingleton(() => ApiService(getIt()));

  // Weather Feature
  getIt.registerLazySingleton(() => WeatherRepository(getIt()));
  getIt.registerLazySingleton(() => WeatherService(getIt()));

  // Shared Preferences
  final prefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => prefs);
}
