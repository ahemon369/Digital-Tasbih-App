import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/theme_provider.dart';
import '../services/dhikr_service.dart';
import '../widgets/animated_background_v2.dart';

class StatisticsScreenV2 extends StatefulWidget {
  const StatisticsScreenV2({super.key});

  @override
  State<StatisticsScreenV2> createState() => _StatisticsScreenV2State();
}

class _StatisticsScreenV2State extends State<StatisticsScreenV2> {
  int _todayCount = 0;
  int _weekCount = 0;
  int _monthCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    setState(() => _isLoading = true);
    
    final today = await DhikrService.getTodayDhikrCount();
    final week = await DhikrService.getWeekDhikrCount();
    final month = await DhikrService.getMonthDhikrCount();
    
    setState(() {
      _todayCount = today;
      _weekCount = week;
      _monthCount = month;
      _isLoading = false;
    });
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
              if (_isLoading)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                )
              else
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _loadStatistics,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildStatsCards(themeProvider),
                          const SizedBox(height: 24),
                          _buildWeeklyChart(themeProvider),
                          const SizedBox(height: 24),
                          _buildRamadanStats(themeProvider),
                        ],
                      ),
                    ),
                  ),
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
                  'Dhikr Statistics',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: themeProvider.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Track your spiritual progress',
                  style: TextStyle(
                    color: themeProvider.accentColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _loadStatistics,
            icon: Icon(
              Icons.refresh,
              color: themeProvider.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(ThemeProvider themeProvider) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildStatCard('Today', _todayCount, Icons.today, themeProvider)),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard('This Week', _weekCount, Icons.date_range, themeProvider)),
          ],
        ),
        const SizedBox(height: 12),
        _buildStatCard('This Month', _monthCount, Icons.calendar_month, themeProvider),
      ],
    );
  }

  Widget _buildStatCard(String title, int count, IconData icon, ThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: 24),
              const Spacer(),
              Text(
                '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: count > 0 ? (count % 1000) / 1000 : 0,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            minHeight: 6,
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart(ThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: themeProvider.primaryColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bar_chart, color: themeProvider.primaryColor, size: 24),
              const SizedBox(width: 12),
              Text(
                'Weekly Progress',
                style: TextStyle(
                  color: themeProvider.primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 1000,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => themeProvider.primaryColor,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                      return BarTooltipItem(
                        '${days[group.x.toInt()]}: ${group.barRods[0].toY.toInt()}',
                        const TextStyle(color: Colors.white),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                        if (value.toInt() >= 0 && value.toInt() < days.length) {
                          return Text(
                            days[value.toInt()],
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(color: Colors.white70, fontSize: 10),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  _generateBarData(0, 150),
                  _generateBarData(1, 300),
                  _generateBarData(2, 200),
                  _generateBarData(3, 400),
                  _generateBarData(4, 350),
                  _generateBarData(5, 250),
                  _generateBarData(6, _todayCount.toDouble()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _generateBarData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: Provider.of<ThemeProvider>(context).primaryColor,
          width: 16,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
        ),
      ],
    );
  }

  Widget _buildRamadanStats(ThemeProvider themeProvider) {
    return FutureBuilder<Map<String, dynamic>>(
      future: DhikrService.getRamadanStats(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final stats = snapshot.data!;
        final ramadanDay = stats['ramadanDay'] ?? 1;
        final totalDhikr = stats['totalDhikr'] ?? 0;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                themeProvider.accentColor.withOpacity(0.8),
                themeProvider.accentColor.withOpacity(0.4),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: themeProvider.accentColor.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.nightlight_round, color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    'Ramadan Statistics',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildRamadanStatItem('Day', '$ramadanDay/30'),
                  _buildRamadanStatItem('Total Dhikr', '$totalDhikr'),
                ],
              ),
              const SizedBox(height: 20),
              LinearProgressIndicator(
                value: ramadanDay / 30,
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 8,
              ),
              const SizedBox(height: 8),
              Text(
                'Ramadan Progress: ${((ramadanDay / 30) * 100).toInt()}%',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRamadanStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
