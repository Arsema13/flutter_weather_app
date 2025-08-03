import 'package:flutter/material.dart';

class HourlyForecastChart extends StatelessWidget {
  const HourlyForecastChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      color: Colors.blueGrey.withOpacity(0.2),
      child: const Center(
        child: Text('Hourly Forecast Chart (Coming Soon)'),
      ),
    );
  }
}
