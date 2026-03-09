import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/dhikr.dart';
import 'providers/theme_provider.dart';
import 'screens/home_screen.dart';
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
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
