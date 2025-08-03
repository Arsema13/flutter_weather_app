import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';
import '../app/constants.dart';

class WeatherApiService {
  final String _apiKey = AppConstants.weatherApiKey;
  final String _baseUrl = AppConstants.baseUrl;

  Future<Weather?> fetchWeatherByCity(String city, String unit) async {
    final url = Uri.parse('$_baseUrl/weather?q=$city&units=$unit&appid=$_apiKey');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return Weather.fromJson(jsonDecode(response.body));
      } else {
        print(' Error fetching weather: ${response.body}');
        return null;
      }
    } catch (e) {
      print(' Exception fetching weather: $e');
      return null;
    }
  }

  Future<Weather?> fetchWeatherByLocation(double lat, double lon, String unit) async {
    final url = Uri.parse('$_baseUrl/weather?lat=$lat&lon=$lon&units=$unit&appid=$_apiKey');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return Weather.fromJson(jsonDecode(response.body));
      } else {
        print('Error fetching location weather: ${response.body}');
        return null;
      }
    } catch (e) {
      print(' Exception fetching location weather: $e');
      return null;
    }
  }
}
