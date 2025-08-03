import 'package:flutter/material.dart';

class DailyForecastCard extends StatelessWidget {
  final String day;
  final double highTemp;
  final double lowTemp;
  final IconData icon;

  const DailyForecastCard({
    super.key,
    required this.day,
    required this.highTemp,
    required this.lowTemp,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.orangeAccent),
        title: Text(day),
        subtitle: Text('High: ${highTemp.toStringAsFixed(1)}°, Low: ${lowTemp.toStringAsFixed(1)}°'),
      ),
    );
  }
}
