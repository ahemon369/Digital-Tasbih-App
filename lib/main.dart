import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/dhikr.dart';
import 'providers/theme_provider.dart';
import 'screens/home_screen_modern.dart';
import 'screens/digital_tasbih_screen.dart';
import 'screens/tumare_bolci_amar_dewa_screen.dart';
import 'screens/allah_names_screen.dart';
import 'screens/dhikr_statistics_screen.dart';
import 'screens/ramadan_counter_screen.dart';
import 'screens/auto_tasbih_screen.dart';
import 'screens/statistics_screen_v2.dart';
import 'screens/settings_screen.dart';
import 'services/dhikr_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DhikrService.setTheme(AppTheme.nightSky);
  runApp(const TasbihApp());
}

class TasbihApp extends StatelessWidget {
  const TasbihApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider()..loadTheme(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Premium Digital Tasbih',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.themeData,
            home: const HomeScreenModern(),
            routes: {
              '/digital_tasbih': (context) => const DigitalTasbihScreen(),
              '/tumare_bolci_amar_dewa': (context) =>
                  const TumareBolciAmarDewaScreen(),
              '/allah_names': (context) => const AllahNamesScreen(),
              '/dhikr_statistics': (context) => const DhikrStatisticsScreen(),
              '/ramadan_counter': (context) => const RamadanCounterScreen(),
              '/auto_tasbih': (context) => const AutoTasbihScreen(),
              '/statistics': (context) => const StatisticsScreenV2(),
              '/settings': (context) => const SettingsScreen(),
            },
          );
        },
      ),
    );
  }
}
