import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/dhikr.dart';
import '../providers/theme_provider.dart';
import '../services/dhikr_service.dart';

class DhikrSelector extends StatefulWidget {
  final Dhikr? selectedDhikr;
  final Function(Dhikr) onDhikrSelected;

  const DhikrSelector({
    super.key,
    this.selectedDhikr,
    required this.onDhikrSelected,
  });

  @override
  State<DhikrSelector> createState() => _DhikrSelectorState();
}

class _DhikrSelectorState extends State<DhikrSelector> {
  final List<Dhikr> _dhikrs = DhikrService.getDhikrs();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      height: 90, // Further reduced
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
              margin: const EdgeInsets.symmetric(
                horizontal: 6,
              ), // Reduced from 8
              padding: const EdgeInsets.all(10), // Reduced from 12
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
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? themeProvider.primaryColor
                      : Colors.white.withOpacity(0.2),
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: themeProvider.primaryColor.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              width: 110, // Further reduced from 120
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dhikr.arabic,
                    style: TextStyle(
                      fontSize: 14, // Further reduced from 16
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.white70,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2), // Further reduced from 3
                  Text(
                    dhikr.transliteration,
                    style: TextStyle(
                      fontSize: 9, // Further reduced from 10
                      color: isSelected ? Colors.white70 : Colors.white54,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2), // Further reduced from 3
                  Text(
                    dhikr.meaning,
                    style: TextStyle(
                      fontSize: 8, // Further reduced from 9
                      color: isSelected ? Colors.white60 : Colors.white38,
                    ),
                    maxLines: 1, // Reduced from 2
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Target: ${dhikr.target}',
                        style: TextStyle(
                          fontSize: 8, // Further reduced from 9
                          color: isSelected ? Colors.white : Colors.white54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isSelected)
                        Icon(
                          Icons.check_circle,
                          size: 12, // Further reduced from 14
                          color: Colors.white,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
