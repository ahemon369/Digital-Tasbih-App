import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/dhikr.dart';
import '../providers/theme_provider.dart';
import '../services/dhikr_service.dart';
import '../widgets/animated_background_v2.dart';

class AllahNamesScreenV2 extends StatefulWidget {
  const AllahNamesScreenV2({super.key});

  @override
  State<AllahNamesScreenV2> createState() => _AllahNamesScreenV2State();
}

class _AllahNamesScreenV2State extends State<AllahNamesScreenV2> {
  final List<AllahName> _allahNames = DhikrService.getAllahNames();
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      body: AnimatedBackgroundV2(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(themeProvider),
              _buildSearchBar(themeProvider),
              Expanded(
                child: _buildNamesGrid(themeProvider),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              color: themeProvider.primaryColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '99 Names of Allah',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: themeProvider.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Asma-ul-Husna',
                  style: TextStyle(
                    color: themeProvider.accentColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: themeProvider.primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.favorite,
              color: themeProvider.primaryColor,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ThemeProvider themeProvider) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: themeProvider.primaryColor.withOpacity(0.3),
        ),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search names...',
          hintStyle: const TextStyle(color: Colors.white54),
          border: InputBorder.none,
          icon: Icon(Icons.search, color: themeProvider.primaryColor),
        ),
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }

  Widget _buildNamesGrid(ThemeProvider themeProvider) {
    final filteredNames = _allahNames.where((name) {
      final query = _searchController.text.toLowerCase();
      return name.arabic.contains(query) ||
          name.transliteration.toLowerCase().contains(query) ||
          name.meaning.toLowerCase().contains(query);
    }).toList();

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: filteredNames.length,
      itemBuilder: (context, index) {
        final name = filteredNames[index];
        return _buildNameCard(name, themeProvider);
      },
    );
  }

  Widget _buildNameCard(AllahName name, ThemeProvider themeProvider) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            themeProvider.primaryColor.withOpacity(0.8),
            themeProvider.primaryColor.withOpacity(0.4),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: themeProvider.primaryColor.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: themeProvider.primaryColor.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showNameDetails(name),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Number badge
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: themeProvider.accentColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${name.number}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
                // Arabic name
                Text(
                  name.arabic,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Transliteration
                Text(
                  name.transliteration,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                
                // Meaning
                Expanded(
                  child: Text(
                    name.meaning,
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 11,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                
                const Spacer(),
                
                // Recite button
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: themeProvider.accentColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.play_arrow,
                            color: themeProvider.accentColor,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Recite',
                            style: TextStyle(
                              color: themeProvider.accentColor,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showNameDetails(AllahName name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Provider.of<ThemeProvider>(context, listen: false)
            .scaffoldBackgroundColor,
        title: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Provider.of<ThemeProvider>(context, listen: false)
                    .primaryColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${name.number}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              name.arabic,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name.transliteration,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name.meaning,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white60,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _showRecitationDialog(name);
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start Dhikr with this Name'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Provider.of<ThemeProvider>(context, listen: false)
                      .primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showRecitationDialog(AllahName name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Provider.of<ThemeProvider>(context, listen: false)
            .scaffoldBackgroundColor,
        title: Text(
          'Dhikr with ${name.transliteration}',
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Recite: "${name.transliteration}"',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Meaning: ${name.meaning}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white60,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Repeat this name as many times as you wish for blessings and remembrance of Allah.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white54,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Provider.of<ThemeProvider>(context, listen: false)
                  .primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Go to Tasbih'),
          ),
        ],
      ),
    );
  }
}
