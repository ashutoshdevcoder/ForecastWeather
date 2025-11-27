import 'dart:async';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_forecast/features/weather/data/models/search_model.dart';
import 'package:weather_forecast/features/weather/data/models/weather_model.dart';
import 'package:weather_forecast/features/weather/domain/services/weather_service.dart';
import 'package:weather_forecast/service_locator.dart';

abstract class WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final WeatherForecast weatherForecast;

  WeatherLoaded(this.weatherForecast);
}

class WeatherError extends WeatherState {
  final String message;

  WeatherError(this.message);
}

class SearchResultState extends WeatherState {
  final SearchResult searchResult;

  SearchResultState(this.searchResult);
}

class LocationPermissionRequired extends WeatherState {
  final String message;
  final bool isPermanentlyDenied;

  LocationPermissionRequired(this.message, {required this.isPermanentlyDenied});
}

class WeatherBloc {
  final WeatherService _weatherService = getIt<WeatherService>();
  final SharedPreferences _prefs = getIt<SharedPreferences>();

  final _weatherSubject = BehaviorSubject<WeatherState>();
  Stream<WeatherState> get weatherStream => _weatherSubject.stream;

  final _searchQuerySubject = PublishSubject<String>();
  Sink<String> get searchQuerySink => _searchQuerySubject.sink;

  static const String _lastCityKey = 'last_city';

  WeatherBloc() {
    _searchQuerySubject
        .debounceTime(const Duration(milliseconds: 500))
        .switchMap((query) async* {
      if (query.isNotEmpty) {
        yield* _searchLocations(query);
      } else {
        yield WeatherInitial();
      }
    }).listen((state) {
      _weatherSubject.add(state);
    });
  }

  Stream<WeatherState> _searchLocations(String query) async* {
    try {
      final results = await _weatherService.searchLocation(query);
      yield SearchResultState(results);
    } catch (e) {
      yield WeatherError('Failed to search for locations.');
    }
  }

  void loadInitialWeather() async {
    final lastCity = _prefs.getString(_lastCityKey);
    if (lastCity != null) {
      fetchWeather(lastCity);
    } else {
      fetchWeatherForCurrentLocation();
    }
  }

  void fetchWeatherForCurrentLocation() async {
    _weatherSubject.add(WeatherLoading());
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _weatherSubject.add(WeatherError('Location services are disabled.'));
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        _weatherSubject.add(LocationPermissionRequired(
          'This app needs location access to show weather for your current location. You can grant permission in settings or search for a city manually.',
          isPermanentlyDenied: permission == LocationPermission.deniedForever,
        ));
        return;
      }

      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      final city = placemarks.first.locality;
      if (city != null) {
        fetchWeather(city);
      } else {
        _weatherSubject.add(WeatherError('Could not determine your city.'));
      }
    } catch (e) {
      _weatherSubject.add(WeatherError('Failed to get current location.'));
    }
  }

  void fetchWeather(String location) async {
    _weatherSubject.add(WeatherLoading());
    try {
      final weather = await _weatherService.getCurrentWeather(location);
      _weatherSubject.add(WeatherLoaded(weather));
      await _prefs.setString(_lastCityKey, location);
    } catch (e) {
      _weatherSubject.add(WeatherError('Failed to fetch weather data.'));
    }
  }

  void dispose() {
    _weatherSubject.close();
    _searchQuerySubject.close();
  }
}
