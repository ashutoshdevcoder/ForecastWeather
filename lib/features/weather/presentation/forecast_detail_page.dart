import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_forecast/core/styles/text_styles.dart';
import 'package:weather_forecast/features/weather/data/models/weather_model.dart';

class ForecastDetailPage extends StatefulWidget {
  final List<ForecastDay> forecastDays;
  final int initialIndex;

  const ForecastDetailPage({
    super.key,
    required this.forecastDays,
    this.initialIndex = 0,
  });

  @override
  State<ForecastDetailPage> createState() => _ForecastDetailPageState();
}

class _ForecastDetailPageState extends State<ForecastDetailPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.forecastDays.length,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E213A),
      appBar: AppBar(
        title: const Text('3-Day Forecast',style: AppTextStyles.bodyMdBold),
        backgroundColor: const Color(0xFF2E334E),
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.blueGrey,
          tabs: widget.forecastDays.map((day) {
            return Tab(text: DateFormat.E().format(DateTime.parse(day.date)));
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: widget.forecastDays.map((day) {
          return _buildHourlyForecastList(day);
        }).toList(),
      ),
    );
  }

  Widget _buildHourlyForecastList(ForecastDay forecastDay) {
    final now = DateTime.now();
    final isToday = forecastDay.date == DateFormat('yyyy-MM-dd').format(now);
    final upcomingHours = isToday
        ? forecastDay.hour.where((hour) {
            final hourTime = DateTime.parse(hour.time);
            return hourTime.isAfter(now);
          }).toList()
        : forecastDay.hour;

    return ListView.builder(
      itemCount: upcomingHours.length,
      itemBuilder: (context, index) {
        final hour = upcomingHours[index];
        return _buildHourItem(hour);
      },
    );
  }

  Widget _buildHourItem(Hour hour) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          Text(
            DateFormat.j().format(DateTime.parse(hour.time)),
            style: AppTextStyles.bodyMdBold,
          ),
          Row(
            children: [
              Image.network(
                'https:${hour.condition.icon}',
                width: 40,
                height: 40,
              ),
              const SizedBox(width: 16),
              Text(
                '${hour.tempC.toStringAsFixed(0)}°',
                style: AppTextStyles.bodyLgBold,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
