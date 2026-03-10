import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class GlassmorphismCard extends StatelessWidget {
  final String arabicText;
  final String transliteration;
  final String meaning;
  final bool isCompleted;

  const GlassmorphismCard({
    super.key,
    required this.arabicText,
    required this.transliteration,
    required this.meaning,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isCompleted 
              ? themeProvider.accentColor.withOpacity(0.5)
              : Colors.white.withOpacity(0.2),
          width: isCompleted ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Arabic text
          Text(
            arabicText,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isCompleted 
                  ? themeProvider.accentColor 
                  : Colors.white,
              shadows: isCompleted ? [
                Shadow(
                  color: themeProvider.accentColor.withOpacity(0.5),
                  blurRadius: 10,
                ),
              ] : null,
            ),
          ),
          const SizedBox(height: 12),
          
          // Transliteration
          Text(
            transliteration,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: isCompleted 
                  ? themeProvider.accentColor.withOpacity(0.9)
                  : Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          
          // Meaning
          Text(
            meaning,
            style: TextStyle(
              fontSize: 14,
              color: isCompleted 
                  ? Colors.white.withOpacity(0.9)
                  : Colors.white60,
            ),
          ),
        ],
      ),
    );
  }
}
