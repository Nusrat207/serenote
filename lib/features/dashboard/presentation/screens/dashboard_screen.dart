import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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
  int _selectedIndex = 0;

  static const List<String> _tabTitles = [
    'Dashboard',
    'Mood',
    'Journal',
    'Habits',
    'More'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _buildTabContent(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.mood), label: 'Mood'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Journal'),
          BottomNavigationBarItem(icon: Icon(Icons.check_box), label: 'Habits'),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'More'),
        ],
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }

  Widget _buildTabContent(int index) {
    switch (index) {
      case 0:
        return _buildDashboard();
      case 1:
        return Center(child: Text('Mood Screen', style: TextStyle(fontSize: 24)));
      case 2:
        return Center(child: Text('Journal Screen', style: TextStyle(fontSize: 24)));
      case 3:
        return Center(child: Text('Habits Screen', style: TextStyle(fontSize: 24)));
      case 4:
        return Center(child: Text('More Options', style: TextStyle(fontSize: 24)));
      default:
        return Center(child: Text('Unknown Tab'));
    }
  }

  Widget _buildDashboard() {
    final todaysMood = null;
    final recentMoods = <MoodEntry>[];

    return CustomScrollView(
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
            ]),
          ),
        ),
      ],
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
}
