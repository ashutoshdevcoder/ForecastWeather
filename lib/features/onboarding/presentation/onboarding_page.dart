import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_forecast/features/weather/presentation/weather_home_page.dart';
import 'package:weather_forecast/service_locator.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    const pageDecoration = PageDecoration(
      bodyTextStyle: TextStyle(color: Colors.white, fontSize: 18),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF1E213A),
      body: SafeArea(
        child: IntroductionScreen(
          globalBackgroundColor: Colors.transparent,
          pages: [
            PageViewModel(
              title: "Welcome to Weather Forecast",
              body: "Get the latest weather updates for your current location or search for any city.",
              image: const Center(child: Icon(Icons.wb_sunny, size: 100.0, color: Colors.amber)),
              decoration: pageDecoration,
            ),
            PageViewModel(
              title: "Stay Updated",
              body: "Get hourly and daily forecasts to plan your day with confidence.",
              image: const Center(child: Icon(Icons.access_time, size: 100.0, color: Colors.blue)),
              decoration: pageDecoration,
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
          skip: const Text("Skip", style: TextStyle(color: Colors.white)),
          next: const Icon(Icons.arrow_forward, color: Colors.white),
          done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
          dotsDecorator: const DotsDecorator(
            activeColor: Colors.white,
            color: Colors.white54,
          ),
        ),
      ),
    );
  }
}
