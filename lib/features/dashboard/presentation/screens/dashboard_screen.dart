// lib/features/dashboard/presentation/screens/dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../journal/presentation/screens/journal_screen.dart';
import '../../../routine/presentation/screens/routine_screen.dart';


class MoodEntry {
  final String detectedMood;
  final double confidence;
  final String text;
  final DateTime timestamp;
  final int id;

  MoodEntry({
    required this.detectedMood,
    this.confidence = 1.0,
    this.text = '',
    DateTime? timestamp,
    this.id = 0,
  }) : timestamp = timestamp ?? DateTime.now();
}

class MoodColors {
  static Color getColorForMood(String mood) => Colors.purple;
  static List<Color> getGradientForMood(String mood) =>
      [Colors.purple, Colors.purpleAccent];
}

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final todaysMood = null;
    final recentMoods = <MoodEntry>[];

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_getGreeting(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                    Text(DateFormat('EEEE, MMM dd').format(DateTime.now()),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300)),
                  ],
                ),
                titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildTodaysMoodCard(todaysMood),
                  const SizedBox(height: 20),
                  _buildRecentActivity(recentMoods),
                  const SizedBox(height: 100), // Space for bottom navbar
                ]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  Widget _buildTodaysMoodCard(MoodEntry? mood) {
    if (mood == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(Icons.mood_outlined, size: 48, color: Colors.grey.shade400),
              const SizedBox(height: 12),
              Text('How are you feeling today?',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text('Mood: ${mood.detectedMood}'),
      ),
    );
  }

  Widget _buildRecentActivity(List<MoodEntry> recentMoods) {
    if (recentMoods.isEmpty) {
      return const Text('No recent moods', style: TextStyle(color: Colors.grey));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: recentMoods.map((m) => Text('${m.detectedMood}')).toList(),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
  icon: Icons.access_time,
  label: 'Routine',
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RoutineScreen()),
    );
  },
),

              _buildNavItem(
                icon: Icons.mood,
                label: 'Mood',
                onTap: () {
                  // Navigate to Mood Tracker
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Mood Tracker - Coming Soon')),
                  );
                },
              ),
              _buildNavItem(
                icon: Icons.check_circle_outline,
                label: 'Habits',
                onTap: () {
                  // Navigate to Habit Tracker
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Habit Tracker - Coming Soon')),
                  );
                },
              ),
              _buildNavItem(
                icon: Icons.book,
                label: 'Journal',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const JournalScreen()),
                  );
                },
              ),
              _buildNavItem(
                icon: Icons.games_outlined,
                label: 'Games',
                onTap: () {
                  // Navigate to Games
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Mindful Games - Coming Soon')),
                  );
                },
              ),
              _buildNavItem(
                icon: Icons.lightbulb_outline,
                label: 'Inspire',
                onTap: () {
                  // Navigate to Inspiration
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Inspiration - Coming Soon')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 28, color: Colors.purple),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.purple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}