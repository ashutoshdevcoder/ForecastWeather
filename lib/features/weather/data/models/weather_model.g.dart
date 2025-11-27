// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherForecast _$WeatherForecastFromJson(Map<String, dynamic> json) =>
    WeatherForecast(
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
      current: Current.fromJson(json['current'] as Map<String, dynamic>),
      forecast: Forecast.fromJson(json['forecast'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WeatherForecastToJson(WeatherForecast instance) =>
    <String, dynamic>{
      'location': instance.location,
      'current': instance.current,
      'forecast': instance.forecast,
    };

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
  name: json['name'] as String,
  region: json['region'] as String,
  country: json['country'] as String,
  lat: (json['lat'] as num).toDouble(),
  lon: (json['lon'] as num).toDouble(),
  tzId: json['tz_id'] as String,
  localtimeEpoch: (json['localtime_epoch'] as num).toInt(),
  localtime: json['localtime'] as String,
);

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
  'name': instance.name,
  'region': instance.region,
  'country': instance.country,
  'lat': instance.lat,
  'lon': instance.lon,
  'tz_id': instance.tzId,
  'localtime_epoch': instance.localtimeEpoch,
  'localtime': instance.localtime,
};

Current _$CurrentFromJson(Map<String, dynamic> json) => Current(
  tempC: (json['temp_c'] as num).toDouble(),
  condition: Condition.fromJson(json['condition'] as Map<String, dynamic>),
  windKph: (json['wind_kph'] as num).toDouble(),
  precipMm: (json['precip_mm'] as num).toDouble(),
  humidity: (json['humidity'] as num).toInt(),
  feelslikeC: (json['feelslike_c'] as num).toDouble(),
);

Map<String, dynamic> _$CurrentToJson(Current instance) => <String, dynamic>{
  'temp_c': instance.tempC,
  'condition': instance.condition,
  'wind_kph': instance.windKph,
  'precip_mm': instance.precipMm,
  'humidity': instance.humidity,
  'feelslike_c': instance.feelslikeC,
};

Condition _$ConditionFromJson(Map<String, dynamic> json) =>
    Condition(text: json['text'] as String, icon: json['icon'] as String);

Map<String, dynamic> _$ConditionToJson(Condition instance) => <String, dynamic>{
  'text': instance.text,
  'icon': instance.icon,
};

Forecast _$ForecastFromJson(Map<String, dynamic> json) => Forecast(
  forecastday: (json['forecastday'] as List<dynamic>)
      .map((e) => ForecastDay.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ForecastToJson(Forecast instance) => <String, dynamic>{
  'forecastday': instance.forecastday,
};

ForecastDay _$ForecastDayFromJson(Map<String, dynamic> json) => ForecastDay(
  date: json['date'] as String,
  day: Day.fromJson(json['day'] as Map<String, dynamic>),
  astro: Astro.fromJson(json['astro'] as Map<String, dynamic>),
  hour: (json['hour'] as List<dynamic>)
      .map((e) => Hour.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ForecastDayToJson(ForecastDay instance) =>
    <String, dynamic>{
      'date': instance.date,
      'day': instance.day,
      'astro': instance.astro,
      'hour': instance.hour,
    };

Day _$DayFromJson(Map<String, dynamic> json) => Day(
  maxtempC: (json['maxtemp_c'] as num).toDouble(),
  mintempC: (json['mintemp_c'] as num).toDouble(),
  avgtempC: (json['avgtemp_c'] as num).toDouble(),
  condition: Condition.fromJson(json['condition'] as Map<String, dynamic>),
  dailyChanceOfRain: (json['daily_chance_of_rain'] as num).toInt(),
);

Map<String, dynamic> _$DayToJson(Day instance) => <String, dynamic>{
  'maxtemp_c': instance.maxtempC,
  'mintemp_c': instance.mintempC,
  'avgtemp_c': instance.avgtempC,
  'condition': instance.condition,
  'daily_chance_of_rain': instance.dailyChanceOfRain,
};

Astro _$AstroFromJson(Map<String, dynamic> json) =>
    Astro(sunrise: json['sunrise'] as String, sunset: json['sunset'] as String);

Map<String, dynamic> _$AstroToJson(Astro instance) => <String, dynamic>{
  'sunrise': instance.sunrise,
  'sunset': instance.sunset,
};

Hour _$HourFromJson(Map<String, dynamic> json) => Hour(
  time: json['time'] as String,
  tempC: (json['temp_c'] as num).toDouble(),
  condition: Condition.fromJson(json['condition'] as Map<String, dynamic>),
);

Map<String, dynamic> _$HourToJson(Hour instance) => <String, dynamic>{
  'time': instance.time,
  'temp_c': instance.tempC,
  'condition': instance.condition,
};
