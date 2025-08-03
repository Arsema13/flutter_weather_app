import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_api_service.dart';
import '../services/location_service.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';
import '../app/constants.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherApiService _weatherService = WeatherApiService();

  Weather? _currentWeather;
  Weather? get currentWeather => _currentWeather;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isDarkMode = StorageService.getBool(AppConstants.themePrefKey) ?? false;
  bool get isDarkMode => _isDarkMode;

  String _unit = StorageService.getString(
    AppConstants.unitPrefKey,
    defaultValue: AppConstants.defaultUnit,
  );
  String get unit => _unit;

  bool _notificationsEnabled =
      StorageService.getBool(AppConstants.notificationPrefKey) ?? false;
  bool get notificationsEnabled => _notificationsEnabled;

  final List<String> _favoriteCities = List<String>.from(
    StorageService.getStringList(AppConstants.favoriteCitiesKey) ?? [],
  );
  List<String> get favoriteCities => _favoriteCities;

  /// Fetch weather by city name and return the Weather object
  Future<Weather?> fetchWeatherByCity(String cityName) async {
    _isLoading = true;
    notifyListeners();

    final weather = await _weatherService.fetchWeatherByCity(cityName, _unit);
    if (weather != null) {
      _currentWeather = weather;
    }

    _isLoading = false;
    notifyListeners();

    return weather;
  }

  /// Fetch weather using GPS location
  Future<void> fetchWeatherByLocation() async {
    _isLoading = true;
    notifyListeners();

    final location = await LocationService.getCurrentLocation();
    if (location != null) {
      final weather = await _weatherService.fetchWeatherByLocation(
        location.latitude!,
        location.longitude!,
        _unit,
      );
      if (weather != null) {
        _currentWeather = weather;
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Toggle between light and dark themes
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    StorageService.setBool(AppConstants.themePrefKey, _isDarkMode);
    notifyListeners();
  }

  /// Toggle temperature unit between metric and imperial
  void toggleUnit() {
    _unit = _unit == 'metric' ? 'imperial' : 'metric';
    StorageService.setString(AppConstants.unitPrefKey, _unit);
    notifyListeners();
  }

  /// Add city to favorites and persist
  void addFavoriteCity(String city) {
    if (!_favoriteCities.contains(city)) {
      _favoriteCities.add(city);
      StorageService.setStringList(AppConstants.favoriteCitiesKey, _favoriteCities);
      notifyListeners();
    }
  }

  /// Remove city from favorites and persist
  void removeFavoriteCity(String city) {
    _favoriteCities.remove(city);
    StorageService.setStringList(AppConstants.favoriteCitiesKey, _favoriteCities);
    notifyListeners();
  }

  /// Toggle daily notifications
  void toggleNotifications() {
    _notificationsEnabled = !_notificationsEnabled;
    StorageService.setBool(AppConstants.notificationPrefKey, _notificationsEnabled);

    if (_notificationsEnabled) {
      NotificationService.scheduleDailyNotification(
        hour: 7,
        minute: 0,
        title: 'Daily Weather',
        body: 'Check today’s weather forecast 🌤️',
      );
    } else {
      NotificationService.cancelNotifications();
    }

    notifyListeners();
  }

  /// Check if a city is in favorites
  bool isCityFavorite(String city) => _favoriteCities.contains(city);
}
