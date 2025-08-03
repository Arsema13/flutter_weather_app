import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../wide/weather_card.dart';
import '../wide/favorite_city_chip.dart';
import '../app/constants.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _cityController = TextEditingController();
  bool _isLoadingLocation = false;

  // Sample cities to display on home screen
  final List<String> sampleCities = [
    'New York',
    'London',
    'Tokyo',
    'Paris',
    'Sydney',
    'Moscow',
    'Cairo',
    'Rio de Janeiro',
  ];

  // Map to store sample city weather info fetched
  Map<String, dynamic> sampleCityWeatherData = {};

  @override
  void initState() {
    super.initState();
    final provider = context.read<WeatherProvider>();
    // Fetch current location weather
    Future.microtask(() => provider.fetchWeatherByLocation());
    // Fetch weather for sample cities on init
    _fetchSampleCitiesWeather(provider);
  }

  Future<void> _fetchSampleCitiesWeather(WeatherProvider provider) async {
    for (var city in sampleCities) {
      final weather = await provider.fetchWeatherByCity(city);
      if (weather != null) {
        setState(() {
          sampleCityWeatherData[city] = weather;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();
    final currentCity = provider.currentWeather?.cityName ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weatherly'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            tooltip: 'Favorite Cities',
            onPressed: () => context.push('/favorites'),
          ),
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            tooltip: 'Settings',
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => provider.fetchWeatherByLocation(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppPadding.screen),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Field
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_city_outlined, color: Colors.grey),
                    const SizedBox(width: 6),
                    Expanded(
                      child: TextField(
                        controller: _cityController,
                        decoration: const InputDecoration(
                          hintText: 'Search city...',
                          border: InputBorder.none,
                        ),
                        onSubmitted: (value) {
                          final city = value.trim();
                          if (city.isNotEmpty) {
                            provider.fetchWeatherByCity(city);
                          }
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.blueAccent),
                      onPressed: () {
                        final city = _cityController.text.trim();
                        if (city.isNotEmpty) {
                          provider.fetchWeatherByCity(city);
                        }
                      },
                    ),
                    _isLoadingLocation
                        ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : IconButton(
                            icon: const Icon(Icons.my_location, color: Colors.blueAccent),
                            onPressed: () async {
                              setState(() => _isLoadingLocation = true);
                              await provider.fetchWeatherByLocation();
                              setState(() => _isLoadingLocation = false);
                            },
                            tooltip: 'Use My Location',
                          ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Sample cities with weather and favorite toggle
              SizedBox(
                height: 140,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: sampleCities.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final city = sampleCities[index];
                    final weather = sampleCityWeatherData[city];
                    final isFavorite = provider.favoriteCities.contains(city);

                    if (weather == null) {
                      // Show placeholder if no data yet
                      return Container(
                        width: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    }

                    return Container(
                      width: 140,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(city, style: const TextStyle(fontWeight: FontWeight.bold)),
                          // Show temperature & weather icon
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${weather.temperature.toStringAsFixed(0)}°${provider.unit == 'metric' ? 'C' : 'F'}',
                                style: const TextStyle(fontSize: 20),
                              ),
                              const SizedBox(width: 8),
                              Image.network(
                                'https://openweathermap.org/img/wn/${weather.iconCode}@2x.png',
                                width: 40,
                                height: 40,
                              ),
                            ],
                          ),
                          // Favorite toggle
                          IconButton(
                            icon: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.redAccent : Colors.grey,
                            ),
                            onPressed: () {
                              if (isFavorite) {
                                provider.removeFavoriteCity(city);
                              } else {
                                provider.addFavoriteCity(city);
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),

              // Current Weather Card with favorite toggle button
              if (provider.currentWeather != null)
                Stack(
                  children: [
                    WeatherCard(weather: provider.currentWeather!),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        iconSize: 30,
                        icon: Icon(
                          provider.favoriteCities.contains(currentCity)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.redAccent,
                        ),
                        onPressed: () {
                          if (provider.favoriteCities.contains(currentCity)) {
                            provider.removeFavoriteCity(currentCity);
                          } else {
                            provider.addFavoriteCity(currentCity);
                          }
                        },
                      ),
                    ),
                  ],
                )
              else
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: CircularProgressIndicator(),
                  ),
                ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Favorite Cities',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(Icons.favorite, color: Colors.redAccent),
                ],
              ),
              const SizedBox(height: 12),

              provider.favoriteCities.isNotEmpty
                  ? Wrap(
                      spacing: 8,
                      children: provider.favoriteCities.map((city) {
                        return FavoriteCityChip(
                          cityName: city,
                          onTap: () => provider.fetchWeatherByCity(city),
                        );
                      }).toList(),
                    )
                  : const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        'No favorites added yet.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF1F5F9), // modern soft background
    );
  }
}
