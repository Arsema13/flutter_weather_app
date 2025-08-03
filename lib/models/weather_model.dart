import 'package:flutter/material.dart';

class Weather {
  final String cityName;
  final double temperature;
  final String condition;
  final String iconCode;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final int sunrise;
  final int sunset;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.condition,
    required this.iconCode,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.sunrise,
    required this.sunset,
  });

  // Add a description getter from iconCode or condition
  String get description {
    switch (condition.toLowerCase()) {
      case 'clear':
        return 'Clear Sky';
      case 'clouds':
        return 'Cloudy';
      case 'rain':
        return 'Rainy';
      case 'snow':
        return 'Snowy';
      case 'thunderstorm':
        return 'Thunderstorm';
      case 'drizzle':
        return 'Drizzle';
      case 'mist':
      case 'fog':
        return 'Foggy';
      default:
        return condition;
    }
  }

  // Add icon based on weather condition
  IconData getWeatherIcon() {
    switch (condition.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      case 'rain':
        return Icons.beach_access;
      case 'snow':
        return Icons.ac_unit;
      case 'thunderstorm':
        return Icons.flash_on;
      case 'drizzle':
        return Icons.grain;
      case 'mist':
      case 'fog':
        return Icons.blur_on;
      default:
        return Icons.wb_cloudy;
    }
  }

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: (json['main']['temp'] as num).toDouble(),
      condition: json['weather'][0]['main'],
      iconCode: json['weather'][0]['icon'],
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      humidity: json['main']['humidity'],
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      sunrise: json['sys']['sunrise'],
      sunset: json['sys']['sunset'],
    );
  }
}
