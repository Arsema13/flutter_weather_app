import 'package:flutter/material.dart';

class FavoriteCityChip extends StatelessWidget {
  final String cityName;
  final VoidCallback onTap;

  const FavoriteCityChip({
    super.key,
    required this.cityName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(cityName),
      avatar: const Icon(Icons.location_city, size: 18),
      onPressed: onTap,
      backgroundColor: Colors.blue.shade100,
    );
  }
}
