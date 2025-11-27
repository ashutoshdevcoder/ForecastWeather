import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_forecast/features/weather/presentation/weather_home_page.dart';
import 'package:weather_forecast/service_locator.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Welcome to Weather Forecast",
          body: "Get the latest weather updates for your current location or search for any city.",
          image: const Center(child: Icon(Icons.wb_sunny, size: 100.0, color: Colors.amber)),
          decoration: const PageDecoration(
            pageColor: Color(0xFF1E213A),
            bodyTextStyle: TextStyle(color: Colors.white, fontSize: 18),
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
        PageViewModel(
          title: "Stay Updated",
          body: "Get hourly and daily forecasts to plan your day with confidence.",
          image: const Center(child: Icon(Icons.access_time, size: 100.0, color: Colors.blue)),
          decoration: const PageDecoration(
            pageColor: Color(0xFF1E213A),
            bodyTextStyle: TextStyle(color: Colors.white, fontSize: 18),
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
      ],
      onDone: () async {
        final prefs = getIt<SharedPreferences>();
        await prefs.setBool('hasSeenOnboarding', true);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const WeatherHomePage()),
        );
      },
      showSkipButton: true,
      skip: const Text("Skip", style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blue)),
      next: const Icon(Icons.arrow_forward, color: Colors.blue),
      done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blue)),
    );
  }
}
