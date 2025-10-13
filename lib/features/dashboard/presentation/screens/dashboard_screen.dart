import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../journal/presentation/screens/journal_screen.dart';
import '../../../todo/presentation/screens/todo_screen.dart';
import '../../../mood/presentation/screens/mood_screen.dart';
import '../../../mood/presentation/providers/mood_provider.dart';
import 'package:serenote/core/theme/mood_colors.dart';
import '../../../mood/data/models/mood_entry.dart';
import '../widgets/sidebar.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final allMoods = ref.watch(moodEntriesProvider);
    final recentMoods =
        ref.read(moodEntriesProvider.notifier).getRecentEntries(days: 7);

    return FutureBuilder<MoodEntry?>(
      future: ref.read(moodEntriesProvider.notifier).getTodaysMood(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
            bottomNavigationBar: SizedBox(height: 60),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
            bottomNavigationBar: _buildBottomNavBar(),
          );
        }

        final todaysMood = snapshot.data;

        return Scaffold(
          drawer: const Sidebar(),
          body: Container(
            decoration: todaysMood != null
                ? BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        MoodColors.getColorForMood(
                          todaysMood.detectedMood,
                        ).withOpacity(0.3),
                        Theme.of(context).scaffoldBackgroundColor,
                      ],
                      stops: const [0.0, 0.4],
                    ),
                  )
                : null,
            child: SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 120,
                    floating: false,
                    pinned: true,
                    backgroundColor: Colors.transparent,
                    leading: Builder(
                      builder: (context) => IconButton(
                        icon:
                            const Icon(Icons.menu, color: Colors.black87),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      title: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getGreeting(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            DateFormat('EEEE, MMM dd')
                                .format(DateTime.now()),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                      titlePadding:
                          const EdgeInsets.only(left: 20, bottom: 16),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(20),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _buildTodaysMoodCard(todaysMood),
                        const SizedBox(height: 20),
                        _buildStatsOverview(allMoods, recentMoods),
                        const SizedBox(height: 20),
                        _buildRecentMoods(recentMoods),
                        const SizedBox(height: 100),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: _buildBottomNavBar(),
        );
      },
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  // ---------------- TODAY'S MOOD ----------------
  Widget _buildTodaysMoodCard(MoodEntry? mood) {
    if (mood == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(Icons.mood_outlined,
                  size: 48, color: Colors.grey.shade400),
              const SizedBox(height: 12),
              Text(
                'How are you feeling today?',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          gradient: MoodColors.getGradientForMood(mood.detectedMood),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.mood,
                      color: Colors.white, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Today\'s Mood',
                        style: TextStyle(
                            color: Colors.white70, fontSize: 14),
                      ),
                      Text(
                        mood.detectedMood.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${(mood.confidence * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (mood.text.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.format_quote,
                        color: Colors.white70, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        mood.text,
                        style: const TextStyle(
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ---------------- STATS ----------------
  Widget _buildStatsOverview(
    List<MoodEntry> allMoods,
    List<MoodEntry> recentMoods,
  ) {
    final moodTodayCount = allMoods
        .where((m) =>
            m.timestamp.year == DateTime.now().year &&
            m.timestamp.month == DateTime.now().month &&
            m.timestamp.day == DateTime.now().day)
        .length;

    final streak = _calculateStreak(allMoods);

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.mood,
            value: moodTodayCount.toString(),
            label: 'Moods Tracked Today',
            color: Colors.purple,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.local_fire_department,
            value: streak.toString(),
            label: 'Day Streak',
            color: Colors.orange,
          ),
        ),
      ],
    );
  }

  int _calculateStreak(List<MoodEntry> moods) {
    if (moods.isEmpty) return 0;
    int streak = 0;
    DateTime checkDate = DateTime.now();
    for (int i = 0; i < 30; i++) {
      final hasEntry = moods.any(
        (mood) =>
            mood.timestamp.year == checkDate.year &&
            mood.timestamp.month == checkDate.month &&
            mood.timestamp.day == checkDate.day,
      );
      if (hasEntry) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }

  // ---------------- RECENT MOODS ----------------
  Widget _buildRecentMoods(List<MoodEntry> recentMoods) {
    if (recentMoods.isEmpty) {
      return const Text('No recent moods',
          style: TextStyle(color: Colors.grey));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Moods',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recentMoods.take(7).length,
            itemBuilder: (context, index) {
              final mood = recentMoods[index];
              final date = DateFormat('EEE').format(mood.timestamp);
              return Container(
                width: 80,
                margin: const EdgeInsets.only(right: 12),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: MoodColors.getColorForMood(
                              mood.detectedMood,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            mood.detectedMood[0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          date,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ---------------- BOTTOM NAV ----------------
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
                    MaterialPageRoute(
                        builder: (_) => const RoutineScreen()),
                  );
                },
              ),
              _buildNavItem(
                icon: Icons.mood,
                label: 'Mood',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const MoodScreen()),
                  );
                },
              ),
              _buildNavItem(
                icon: Icons.book,
                label: 'Journal',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const JournalScreen()),
                  );
                },
              ),
              _buildNavItem(
                icon: Icons.lightbulb_outline,
                label: 'Inspire',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Inspiration - Coming Soon')),
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
        padding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  } 
}
