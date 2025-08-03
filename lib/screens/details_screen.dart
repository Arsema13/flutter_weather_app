import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // In a full implementation, you'd pass detailed weather data via GoRouter or Provider
    return Scaffold(
      appBar: AppBar(title: const Text('Forecast Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: const [
            Text('Hourly Forecast (Coming Soon)'),
            SizedBox(height: 20),
            Text('Daily Forecast (Coming Soon)'),
            SizedBox(height: 20),
            Text('Humidity, UV, Sunrise, Sunset (Coming Soon)'),
          ],
        ),
      ),
    );
  }
}
