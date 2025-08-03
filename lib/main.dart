import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app/themes.dart';
import 'app/routes.dart';
import 'providers/weather_provider.dart';
import 'services/notification_service.dart';
import 'services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env (only for mobile/desktop, not web)
  if (!kIsWeb) {
    await dotenv.load(fileName: ".env");
  }

  // Initialize local storage (SharedPreferences or Hive, etc.)
  await StorageService.init();

  // Initialize notifications with timezone setup
  await NotificationService.initialize();

  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WeatherProvider(),
      child: Consumer<WeatherProvider>(
        builder: (context, provider, _) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Weather App',
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: provider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
