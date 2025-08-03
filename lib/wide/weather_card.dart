import 'package:flutter/material.dart';
import '../models/weather_model.dart';

class WeatherCard extends StatelessWidget {
  final Weather weather;

  const WeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      color: Colors.blueAccent.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              weather.cityName,
              style: const TextStyle(fontSize: 22, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Icon(
              weather.getWeatherIcon(),
              size: 64,
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            Text(
              '${weather.temperature.toStringAsFixed(1)}°',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              weather.description,
              style: const TextStyle(fontSize: 18, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
