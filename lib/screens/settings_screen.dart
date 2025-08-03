import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../app/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();
    

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppPadding.screen),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Preferences',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildSwitchTile(
                    context,
                    title: 'Dark Theme',
                    subtitle: 'Toggle between light and dark mode',
                    value: provider.isDarkMode,
                    onChanged: (_) => provider.toggleTheme(),
                  ),
                  const Divider(height: 1),
                  _buildSwitchTile(
                    context,
                    title: 'Use °F instead of °C',
                    subtitle: 'Switch temperature unit to Fahrenheit',
                    value: provider.unit == 'imperial',
                    onChanged: (_) => provider.toggleUnit(),
                  ),
                  const Divider(height: 1),
                  _buildSwitchTile(
                    context,
                    title: 'Enable Daily Notifications',
                    subtitle: 'Receive daily weather updates',
                    value: provider.notificationsEnabled,
                    onChanged: (_) => provider.toggleNotifications(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }
}