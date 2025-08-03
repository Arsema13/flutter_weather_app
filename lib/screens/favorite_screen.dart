import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();
    final favorites = provider.favoriteCities;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Cities'),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black87,
        centerTitle: true,
      ),
      body: Container(
        color: const Color(0xFFF1F5F9), // soft light background
        child: favorites.isEmpty
            ? const Center(
                child: Text(
                  'No favorite cities yet!',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: favorites.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final city = favorites[index];
                  return Container(
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
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      leading: const Icon(Icons.location_city_rounded, color: Colors.blueAccent),
                      title: Text(
                        city,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          provider.removeFavoriteCity(city);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('$city removed from favorites'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.delete_forever,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                      onTap: () {
                        provider.fetchWeatherByCity(city);
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
