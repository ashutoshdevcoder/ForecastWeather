// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationResult _$LocationResultFromJson(Map<String, dynamic> json) =>
    LocationResult(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      region: json['region'] as String,
      country: json['country'] as String,
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      url: json['url'] as String,
    );

Map<String, dynamic> _$LocationResultToJson(LocationResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'region': instance.region,
      'country': instance.country,
      'lat': instance.lat,
      'lon': instance.lon,
      'url': instance.url,
    };
