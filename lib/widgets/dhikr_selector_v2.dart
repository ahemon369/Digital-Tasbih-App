import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/dhikr.dart';
import '../providers/theme_provider.dart';
import '../services/dhikr_service.dart';

class DhikrSelectorV2 extends StatefulWidget {
  final Dhikr? selectedDhikr;
  final Function(Dhikr) onDhikrSelected;

  const DhikrSelectorV2({
    super.key,
    this.selectedDhikr,
    required this.onDhikrSelected,
  });

  @override
  State<DhikrSelectorV2> createState() => _DhikrSelectorV2State();
}

class _DhikrSelectorV2State extends State<DhikrSelectorV2> {
  final List<Dhikr> _dhikrs = DhikrService.getDhikrs();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return ListView.builder(
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
            padding: const EdgeInsets.all(16),
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
            width: 140,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Arabic text
                Text(
                  dhikr.arabic,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.white70,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                
                // Transliteration
                Text(
                  dhikr.transliteration,
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? Colors.white70 : Colors.white54,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                
                // Meaning
                Text(
                  dhikr.meaning,
                  style: TextStyle(
                    fontSize: 10,
                    color: isSelected ? Colors.white60 : Colors.white38,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                
                // Target and selection indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${dhikr.target}',
                        style: TextStyle(
                          fontSize: 10,
                          color: isSelected ? Colors.white : Colors.white54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check_circle,
                        size: 16,
                        color: Colors.white,
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
