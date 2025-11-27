import 'package:json_annotation/json_annotation.dart';

part 'weather_model.g.dart';

@JsonSerializable()
class WeatherForecast {
  final Location location;
  final Current current;
  final Forecast forecast;

  WeatherForecast({
    required this.location,
    required this.current,
    required this.forecast,
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) =>
      _$WeatherForecastFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherForecastToJson(this);
}

@JsonSerializable()
class Location {
  final String name;
  final String region;
  final String country;
  final double lat;
  final double lon;
  @JsonKey(name: 'tz_id')
  final String tzId;
  @JsonKey(name: 'localtime_epoch')
  final int localtimeEpoch;
  final String localtime;

  Location({
    required this.name,
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
    required this.tzId,
    required this.localtimeEpoch,
    required this.localtime,
  });

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}

@JsonSerializable()
class Current {
  @JsonKey(name: 'temp_c')
  final double tempC;
  final Condition condition;
  @JsonKey(name: 'wind_kph')
  final double windKph;
  @JsonKey(name: 'precip_mm')
  final double precipMm;
  final int humidity;
  @JsonKey(name: 'feelslike_c')
  final double feelslikeC;

  Current({
    required this.tempC,
    required this.condition,
    required this.windKph,
    required this.precipMm,
    required this.humidity,
    required this.feelslikeC,
  });

  factory Current.fromJson(Map<String, dynamic> json) => _$CurrentFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentToJson(this);
}

@JsonSerializable()
class Condition {
  final String text;
  final String icon;

  Condition({required this.text, required this.icon});

  factory Condition.fromJson(Map<String, dynamic> json) =>
      _$ConditionFromJson(json);

  Map<String, dynamic> toJson() => _$ConditionToJson(this);
}

@JsonSerializable()
class Forecast {
  final List<ForecastDay> forecastday;

  Forecast({required this.forecastday});

  factory Forecast.fromJson(Map<String, dynamic> json) =>
      _$ForecastFromJson(json);

  Map<String, dynamic> toJson() => _$ForecastToJson(this);
}

@JsonSerializable()
class ForecastDay {
  final String date;
  final Day day;
  final Astro astro;
  final List<Hour> hour;

  ForecastDay({
    required this.date,
    required this.day,
    required this.astro,
    required this.hour,
  });

  factory ForecastDay.fromJson(Map<String, dynamic> json) =>
      _$ForecastDayFromJson(json);

  Map<String, dynamic> toJson() => _$ForecastDayToJson(this);
}

@JsonSerializable()
class Day {
  @JsonKey(name: 'maxtemp_c')
  final double maxtempC;
  @JsonKey(name: 'mintemp_c')
  final double mintempC;
  @JsonKey(name: 'avgtemp_c')
  final double avgtempC;
  final Condition condition;
  @JsonKey(name: 'daily_chance_of_rain')
  final int dailyChanceOfRain;

  Day({
    required this.maxtempC,
    required this.mintempC,
    required this.avgtempC,
    required this.condition,
    required this.dailyChanceOfRain,
  });

  factory Day.fromJson(Map<String, dynamic> json) => _$DayFromJson(json);

  Map<String, dynamic> toJson() => _$DayToJson(this);
}

@JsonSerializable()
class Astro {
  final String sunrise;
  final String sunset;

  Astro({required this.sunrise, required this.sunset});

  factory Astro.fromJson(Map<String, dynamic> json) => _$AstroFromJson(json);

  Map<String, dynamic> toJson() => _$AstroToJson(this);
}

@JsonSerializable()
class Hour {
  final String time;
  @JsonKey(name: 'temp_c')
  final double tempC;
  final Condition condition;

  Hour({required this.time, required this.tempC, required this.condition});

  factory Hour.fromJson(Map<String, dynamic> json) => _$HourFromJson(json);

  Map<String, dynamic> toJson() => _$HourToJson(this);
}
