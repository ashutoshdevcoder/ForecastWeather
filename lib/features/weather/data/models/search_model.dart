import 'package:json_annotation/json_annotation.dart';

part 'search_model.g.dart';

// This class is a wrapper for the search results list.
// We are implementing the fromJson manually because the API returns a root-level list,
// which json_serializable doesn't handle automatically for a wrapper class.
class SearchResult {
  final List<LocationResult> locations;

  SearchResult({required this.locations});

  factory SearchResult.fromJson(List<dynamic> json) {
    return SearchResult(
      locations: json
          .map((e) => LocationResult.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

@JsonSerializable()
class LocationResult {
  final int id;
  final String name;
  final String region;
  final String country;
  final double lat;
  final double lon;
  final String url;

  LocationResult({
    required this.id,
    required this.name,
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
    required this.url,
  });

  factory LocationResult.fromJson(Map<String, dynamic> json) =>
      _$LocationResultFromJson(json);

  Map<String, dynamic> toJson() => _$LocationResultToJson(this);
}
