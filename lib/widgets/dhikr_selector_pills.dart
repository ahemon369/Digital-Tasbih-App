import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/dhikr.dart';
import '../providers/theme_provider.dart';
import '../services/dhikr_service.dart';

class DhikrSelectorPills extends StatefulWidget {
  final Dhikr? selectedDhikr;
  final Function(Dhikr) onDhikrSelected;

  const DhikrSelectorPills({
    super.key,
    this.selectedDhikr,
    required this.onDhikrSelected,
  });

  @override
  State<DhikrSelectorPills> createState() => _DhikrSelectorPillsState();
}

class _DhikrSelectorPillsState extends State<DhikrSelectorPills> {
  final List<Dhikr> _dhikrs = DhikrService.getDhikrs();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _dhikrs.length,
        itemBuilder: (context, index) {
          final dhikr = _dhikrs[index];
          final isSelected = widget.selectedDhikr?.id == dhikr.id;
          
          return GestureDetector(
            onTap: () => widget.onDhikrSelected(dhikr),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: [
                          themeProvider.primaryColor,
                          themeProvider.primaryColor.withOpacity(0.8),
                        ],
                      )
                    : LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.1),
                          Colors.white.withOpacity(0.05),
                        ],
                      ),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected
                      ? themeProvider.primaryColor
                      : Colors.white.withOpacity(0.3),
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: themeProvider.primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: Text(
                  dhikr.transliteration,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
