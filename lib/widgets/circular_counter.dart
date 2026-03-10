import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class CircularCounter extends StatelessWidget {
  final int current;
  final int target;
  final bool isCompleted;

  const CircularCounter({
    super.key,
    required this.current,
    required this.target,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final progress = target > 0 ? (current / target).clamp(0.0, 1.0) : 0.0;
    
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        border: Border.all(
          color: isCompleted 
              ? themeProvider.accentColor.withOpacity(0.8)
              : themeProvider.primaryColor.withOpacity(0.6),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Progress ring
          SizedBox(
            width: 180,
            height: 180,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 8,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                isCompleted 
                    ? themeProvider.accentColor
                    : themeProvider.primaryColor,
              ),
            ),
          ),
          
          // Center content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$current',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: isCompleted 
                      ? themeProvider.accentColor
                      : Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '/ $target',
                style: TextStyle(
                  fontSize: 20,
                  color: isCompleted 
                      ? themeProvider.accentColor.withOpacity(0.8)
                      : Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
