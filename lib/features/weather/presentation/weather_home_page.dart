import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
import 'package:weather_forecast/core/styles/text_styles.dart';
import 'package:weather_forecast/features/weather/bloc/weather_bloc.dart';
import 'package:weather_forecast/features/weather/data/models/search_model.dart';
import 'package:weather_forecast/features/weather/data/models/weather_model.dart';
import 'package:weather_forecast/features/weather/presentation/forecast_detail_page.dart';

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> with WidgetsBindingObserver {
  final WeatherBloc _weatherBloc = WeatherBloc();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _weatherBloc.loadInitialWeather();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _weatherBloc.weatherStream.first.then((currentState) {
        if (currentState is LocationPermissionRequired) {
          Permission.location.status.then((status) {
            if (status.isGranted) {
              _weatherBloc.fetchWeatherForCurrentLocation();
            }
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E213A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: _buildSearchField(),
      ),
      body: SafeArea(
        child: StreamBuilder<WeatherState>(
          stream: _weatherBloc.weatherStream,
          initialData: WeatherInitial(),
          builder: (context, snapshot) {
            final state = snapshot.data;
            if (state is WeatherLoading) {
              return _buildShimmerEffect();
            }
            if (state is WeatherError) {
              return Center(child: Text(state.message, style: AppTextStyles.errorText));
            }
            if (state is LocationPermissionRequired) {
              return _buildPermissionRequiredUI(state);
            }
            if (state is SearchResultState) {
              return _buildSearchResults(state.searchResult);
            }
            if (state is WeatherLoaded) {
              return _buildWeatherDisplay(state.weatherForecast);
            }
            return const Center(
                child: Text('Search for a location to see the weather forecast',
                    style: AppTextStyles.bodyLg));
          },
        ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF2E334E),
      highlightColor: const Color(0xFF4A4E69),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              color: const Color(0xFF2E334E),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 150, height: 24, color: Colors.white),
                    const SizedBox(height: 8),
                    Container(width: 100, height: 18, color: Colors.white),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(width: 150, height: 80, color: Colors.white),
                        Container(width: 100, height: 100, color: Colors.white),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(width: double.infinity, height: 18, color: Colors.white),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(3, (index) => Container(width: 80, height: 40, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) => Container(
                  width: 80,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionRequiredUI(LocationPermissionRequired state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.message,
              textAlign: TextAlign.center,
              style: AppTextStyles.heading2,
            ),
            const SizedBox(height: 24),
            if (state.isPermanentlyDenied)
              ElevatedButton(
                onPressed: () => openAppSettings(),
                child: const Text('Open Settings'),
              ),
            ElevatedButton(
              onPressed: () {
                _searchFocusNode.requestFocus();
              },
              child: const Text('Search for a city'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      focusNode: _searchFocusNode,
      style: AppTextStyles.bodyLg,
      decoration: InputDecoration(
        hintText: 'Search location...',
        hintStyle: AppTextStyles.bodyLg.copyWith(color: Colors.white.withOpacity(0.5)),
        border: InputBorder.none,
        suffixIcon: IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () {
            if (_searchController.text.isNotEmpty) {
              _weatherBloc.searchQuerySink.add(_searchController.text);
            }
          },
        ),
      ),
      onChanged: (query) {
        _weatherBloc.searchQuerySink.add(query);
      },
    );
  }

  Widget _buildSearchResults(SearchResult searchResult) {
    return ListView.builder(
      itemCount: searchResult.locations.length,
      itemBuilder: (context, index) {
        final location = searchResult.locations[index];
        return ListTile(
          title: Text(location.name, style: AppTextStyles.bodyMdBold),
          subtitle: Text('${location.region}, ${location.country}', style: AppTextStyles.bodyLg),
          onTap: () {
            _weatherBloc.fetchWeather('${location.lat},${location.lon}');
            _searchController.clear();
            FocusManager.instance.primaryFocus?.unfocus();
          },
        );
      },
    );
  }

  Widget _buildWeatherDisplay(WeatherForecast weatherForecast) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ForecastDetailPage(forecastDays: weatherForecast.forecast.forecastday),
                  ),
                );
              },
              child: Card(
                color: const Color(0xFF2E334E),
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(weatherForecast.location.name, style: AppTextStyles.heading1),
                      const SizedBox(height: 8),
                      Text(weatherForecast.current.condition.text, style: AppTextStyles.heading2),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${weatherForecast.current.tempC.toStringAsFixed(0)}°C',
                            style: AppTextStyles.temperatureDisplay.copyWith(fontSize: 60),
                          ),
                          Image.network(
                            'https:${weatherForecast.current.condition.icon}',
                            width: 100,
                            height: 100,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'H: ${weatherForecast.forecast.forecastday[0].day.maxtempC.toStringAsFixed(0)}°',
                                style: AppTextStyles.bodyLg,
                              ),
                              Text(
                                'L: ${weatherForecast.forecast.forecastday[0].day.mintempC.toStringAsFixed(0)}°',
                                style: AppTextStyles.bodyLg,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Sunrise: ${weatherForecast.forecast.forecastday[0].astro.sunrise}  |  Sunset: ${weatherForecast.forecast.forecastday[0].astro.sunset}',
                            style: AppTextStyles.bodyLg.copyWith(fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildWeatherStats(weatherForecast.current, weatherForecast.forecast.forecastday[0].day),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildHourlyForecast(weatherForecast.forecast.forecastday[0]),
            const SizedBox(height: 20),
            _buildDailyForecast(weatherForecast.forecast.forecastday),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherStats(Current current, Day day) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem('Wind', '${current.windKph} km/h'),
        _buildStatItem('Feels like', '${current.feelslikeC.toStringAsFixed(0)}°C'),
        _buildStatItem('Humidity', '${current.humidity}%'),
      ],
    );
  }

  Widget _buildStatItem(String title, String value) {
    return Column(
      children: [
        Text(title, style: AppTextStyles.bodyLg),
        const SizedBox(height: 8),
        Text(value, style: AppTextStyles.bodyLgBold),
      ],
    );
  }
  
  Widget _buildHourlyForecast(ForecastDay forecastDay) {
    final now = DateTime.now();
    final upcomingHours = forecastDay.hour.where((hour) {
      final hourTime = DateTime.parse(hour.time);
      return hourTime.isAfter(now);
    }).toList();

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: upcomingHours.length,
        itemBuilder: (context, index) {
          final hour = upcomingHours[index];
          return _buildHourItem(hour);
        },
      ),
    );
  }

  Widget _buildHourItem(Hour hour) {
    return Container(
      width: 80,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2E334E),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            DateFormat.j().format(DateTime.parse(hour.time)),
            style: AppTextStyles.bodyMd,
          ),
          const SizedBox(height: 8),
          Image.network(
            'https:${hour.condition.icon}',
            width: 40,
            height: 40,
          ),
          Text(
            '${hour.tempC.toStringAsFixed(0)}°',
            style: AppTextStyles.bodyLgBold,
          ),
        ],
      ),
    );
  }

  Widget _buildDailyForecast(List<ForecastDay> forecastDays) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: forecastDays.length,
      itemBuilder: (context, index) {
        final day = forecastDays[index];
        return InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ForecastDetailPage(
                  forecastDays: forecastDays,
                  initialIndex: index,
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF2E334E),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    DateFormat.EEEE().format(DateTime.parse(day.date)),
                    style: AppTextStyles.bodyMdBold,
                  ),
                ),
                Image.network(
                  'https:${day.day.condition.icon}',
                  width: 40,
                  height: 40,
                ),
                SizedBox(
                  width: 100,
                  child: Text(
                    'H: ${day.day.maxtempC.toStringAsFixed(0)}° L: ${day.day.mintempC.toStringAsFixed(0)}°',
                    textAlign: TextAlign.right,
                    style: AppTextStyles.bodyMd,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _weatherBloc.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }
}
