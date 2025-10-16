import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:collection/collection.dart';
import '../../../journal/presentation/screens/journal_screen.dart';
import '../../../todo/presentation/screens/todo_screen.dart';
import '../../../mood/presentation/screens/mood_screen.dart';
import '../../../mood/presentation/providers/mood_provider.dart';
import 'package:serenote/core/theme/mood_colors.dart';
import '../../../mood/data/models/mood_entry.dart';
import '../widgets/sidebar.dart';
import '../../../habits/presentation/screens/habits_screen.dart';
import '../widgets/quick_mood_entry_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/animated_app_bar.dart';
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  // Method to get the weekly moods data
  Map<DateTime, String> _getWeeklyMoods(List<MoodEntry> allMoods) {
    final now = DateTime.now();
    final weekMoods = <DateTime, String>{};

    // Get last 7 days including today
    for (int i = 6; i >= 0; i--) {
      final date = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: i));

      // Get all moods for this specific day
      final dayMoods = allMoods.where((mood) {
        final moodDate = DateTime(
          mood.timestamp.year,
          mood.timestamp.month,
          mood.timestamp.day,
        );
        return moodDate == date;
      }).toList();

      if (dayMoods.isNotEmpty) {
        // Count frequency of each mood
        final moodCounts = <String, int>{};
        for (final mood in dayMoods) {
          moodCounts[mood.detectedMood] =
              (moodCounts[mood.detectedMood] ?? 0) + 1;
        }

        // Find max count
        final maxCount = moodCounts.values.max;

        // Get moods with max count
        final mostFrequentMoods = moodCounts.entries
            .where((entry) => entry.value == maxCount)
            .map((entry) => entry.key)
            .toList();

        String selectedMood;
        if (mostFrequentMoods.length == 1) {
          // Only one most frequent mood
          selectedMood = mostFrequentMoods.first;
        } else {
          // Multiple moods with same count, take the last one
          final lastMood = dayMoods.last.detectedMood;
          selectedMood = lastMood;
        }

        weekMoods[date] = selectedMood;
      } else {
        // No moods for this day
        weekMoods[date] = 'none';
      }
    }

    return weekMoods;
  }

  // Helper method to get icon for mood
  IconData _getMoodIcon(String mood) {
    switch (mood.toLowerCase()) {
      case 'anxious':
        return Icons.sentiment_very_dissatisfied;
      case 'sad':
        return Icons.sentiment_dissatisfied;
      case 'neutral':
        return Icons.sentiment_neutral;
      case 'joy':
        return Icons.sentiment_very_satisfied;
      case 'angry':
        return FontAwesomeIcons.faceAngry;
      default:
        return Icons.circle_outlined;
    }
  }

  Widget _getMoodImageIcon(String mood) {
    switch (mood.toLowerCase()) {
      case 'anxious':
        return Image.asset('assets/images/anxious.png', width: 25, height: 25);
      case 'angry':
        return Image.asset('assets/images/angry.png', width: 25, height: 25);
      case 'sad':
        return Image.asset('assets/images/sadd.png', width: 25, height: 25);
      case 'neutral':
        return Image.asset('assets/images/neutral.png', width: 25, height: 25);
      case 'joy':
        return Image.asset('assets/images/happy.png', width: 25, height: 25);
      default:
        return const Icon(Icons.circle_outlined, size: 20, color: Colors.grey);
    }
  }

  // Helper method to get color for mood
  Color _getMoodColor(String mood) {
    switch (mood.toLowerCase()) {
      case 'anxious':
        return const Color.fromARGB(255, 116, 27, 179);
      case 'sad':
        return const Color.fromARGB(255, 6, 115, 204);
      case 'neutral':
        return const Color.fromARGB(255, 36, 169, 101);
      case 'joy':
        return const Color.fromARGB(255, 178, 140, 3);
      case 'angry':
        return const Color.fromARGB(255, 204, 6, 6);
      default:
        return Colors.grey.shade300;
    }
  }

  // Helper to get Y position for mood (0 = bottom, 3 = top)
  int _getMoodLevel(String mood) {
    switch (mood.toLowerCase()) {
      case 'anxious':
        return 0;
      case 'angry':
        return 1;
      case 'sad':
        return 2;
      case 'neutral':
        return 3;
      case 'joy':
        return 4;
      default:
        return -1; // no mood
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final userId = user?.id;

    // if user not logged in — fallback to empty lists
    final allMoods = userId != null
        ? ref.watch(moodEntriesProvider)
        : <MoodEntry>[];
    final recentMoods = userId != null
        ? ref.watch(moodEntriesProvider.notifier).getRecentEntries(days: 7)
        : <MoodEntry>[];

    // Get weekly moods data
    final weeklyMoods = _getWeeklyMoods(allMoods);

    return FutureBuilder<MoodEntry?>(
      future: userId != null
          ? ref.read(moodEntriesProvider.notifier).getTodaysMood()
          : Future.value(null),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            userId != null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
            bottomNavigationBar: SizedBox(height: 60),
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
                   AnimatedAppBar(),
                  SliverPadding(
                    padding: const EdgeInsets.all(20),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        const SizedBox(height: 16),
                        if (userId == null)
                          _buildLoginMessage()
                        else
                          _buildTodaysMoodCard(todaysMood),
                        if (userId != null) 
                        const QuickMoodEntryCard(),
                        const SizedBox(height: 20),
                      
                        _buildStatsOverview(allMoods, recentMoods, todaysMood),
                        const SizedBox(height: 20),
                        if (userId != null) _buildWeeklyMoodGraph(weeklyMoods),
                        const SizedBox(height: 20),
                        if (userId != null) _buildRecentMoods(recentMoods),
                        const SizedBox(height: 100),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: _buildBottomNavBar(todaysMood),
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

  // ---------------- LOGIN MESSAGE ----------------
  Widget _buildLoginMessage() {
    return Card(
      color: const Color.fromARGB(255, 221, 255, 245),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.sentiment_dissatisfied,
              size: 40,
              color: const Color.fromARGB(255, 108, 192, 206),
            ),
            const SizedBox(height: 12),
            const Text(
              "You're not logged in",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              "Sign in to start tracking your moods and progress.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- TODAY'S MOOD ----------------
  Widget _buildTodaysMoodCard(MoodEntry? mood) {
    if (mood == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(Icons.mood_outlined, size: 48, color: Colors.grey.shade400),
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
                  child: const Icon(Icons.mood, color: Colors.white, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Current Mood',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
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
                    const Icon(
                      Icons.format_quote,
                      color: Colors.white70,
                      size: 16,
                    ),
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
    MoodEntry? todaysMood,
  ) {
    final moodTodayCount = allMoods
        .where(
          (m) =>
              m.timestamp.year == DateTime.now().year &&
              m.timestamp.month == DateTime.now().month &&
              m.timestamp.day == DateTime.now().day,
        )
        .length;

    final streak = _calculateStreak(allMoods);

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.mood,
            value: moodTodayCount.toString(),
            label: 'Moods Tracked Today',
            color: const Color.fromARGB(255, 17, 38, 38),
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

  // ---------------- WEEKLY MOOD GRAPH ----------------
  Widget _buildWeeklyMoodGraph(Map<DateTime, String> weeklyMoods) {
    final days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    final moodOrder = ['anxious', 'angry', 'sad', 'neutral', 'joy'];
    final now = DateTime.now();
    const labelStyle = TextStyle(fontSize: 10, fontWeight: FontWeight.w500);

    final dates = List.generate(
      7,
      (index) => DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: 6 - index)),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Weekly Moods',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Fixed height container for the graph - increased height
              SizedBox(
                height: 240, // Increased from 180 to create more gaps
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Y-axis labels
                    SizedBox(
                      width: 70,
                      height: 300,
                      child: Column(
                        children: [
                          Text('JOY', style: labelStyle),
                          Spacer(flex: 2),
                          Text('NEUTRAL', style: labelStyle),
                          Spacer(flex: 2),
                          Text('SAD', style: labelStyle),
                          Spacer(flex: 2),
                          Text('ANGRY', style: labelStyle),
                          Spacer(flex: 2),
                          Text('ANXIOUS', style: labelStyle),
                        ],
                      ),
                    ),

                    // Graph area
                    Expanded(
                      child: CustomPaint(
                        painter: _MoodLinePainter(
                          dates: dates,
                          weeklyMoods: weeklyMoods,
                          getMoodLevel: _getMoodLevel,
                          getMoodColor: _getMoodColor,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: dates.map((date) {
                            final mood = weeklyMoods[date] ?? 'none';
                            final level = _getMoodLevel(mood);

                            if (level < 0)
                              return const Expanded(child: SizedBox());

                            return Expanded(
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  // Match the padding used in CustomPainter
                                  final verticalPadding = 12.0;
                                  final availableHeight =
                                      constraints.maxHeight -
                                      2 * verticalPadding;

                                  // Calculate Y position to match the line
                                  // level 4 (joy) should be at top, level 0 (anxious) at bottom
                                  final y =
                                      verticalPadding +
                                      availableHeight * (4 - level) / 4;

                                  return Stack(
                                    children: [
                                      Positioned(
                                        top: y - 12, // Center the 24px icon
                                        left: 0,
                                        right: 0,
                                        child: Center(
                                          child: Container(
                                            width: 24,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  blurRadius: 2,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: _getMoodImageIcon(mood),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // X-axis
              Row(
                children: [
                  const SizedBox(width: 70),
                  Expanded(
                    child: Row(
                      children: dates.map((date) {
                        return Expanded(
                          child: Column(
                            children: [
                              Text(
                                days[date.weekday - 1],
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: date.day == now.day
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: date.day == now.day
                                      ? Colors.purple
                                      : Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                date.day.toString(),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: date.day == now.day
                                      ? Colors.purple
                                      : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------- RECENT MOODS ----------------
  Widget _buildRecentMoods(List<MoodEntry> recentMoods) {
    if (recentMoods.isEmpty) {
      return const SizedBox(); // Return empty since using the graph instead
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Mood Entries',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            itemCount: recentMoods.take(7).length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final mood = recentMoods[index];
              final date = DateFormat('EEE').format(mood.timestamp);
              return Container(
                width: 74, // slightly reduced from 80
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(6), // slightly reduced
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: MoodColors.getColorForMood(
                              mood.detectedMood,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _getMoodIcon(mood.detectedMood),
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          date,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          DateFormat('HH:mm').format(mood.timestamp),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Colors.grey.shade600,
                                fontSize: 10,
                              ),
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
  Widget _buildBottomNavBar(MoodEntry? mood) {
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
                icon: Icons.mood,
                label: 'Mood',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MoodScreen()),
                ),
                mood: mood,
              ),
              _buildNavItem(
                icon: FontAwesomeIcons.book,
                label: 'Journal',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const JournalScreen()),
                  
                ),
                
                mood: mood,
              ),
              _buildNavItem(
                icon: Icons.check_box,
                label: 'Habit',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HabitsScreen()),
                ),
                mood: mood,
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
    MoodEntry? mood,
  }) {
    Color baseColor = MoodColors.getColorForMood(mood?.detectedMood ?? 'black');
Color darkerColor = Color.fromARGB(
  baseColor.alpha,
  (baseColor.red * 0.7).round(),
  (baseColor.green * 0.7).round(),
  (baseColor.blue * 0.7).round(),
);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 25, color: darkerColor),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: darkerColor,
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
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------- CUSTOM PAINTER -----------------
class _MoodLinePainter extends CustomPainter {
  final List<DateTime> dates;
  final Map<DateTime, String> weeklyMoods;
  final int Function(String) getMoodLevel;
  final Color Function(String) getMoodColor;

  _MoodLinePainter({
    required this.dates,
    required this.weeklyMoods,
    required this.getMoodLevel,
    required this.getMoodColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = const Color.fromARGB(255, 226, 121, 245).withOpacity(0.6)
      ..strokeCap = StrokeCap.round;

    final points = <Offset>[];
    final verticalPadding = 12.0;
    final availableHeight = size.height - 2 * verticalPadding;

    for (int i = 0; i < dates.length; i++) {
      final date = dates[i];
      final mood = weeklyMoods[date] ?? 'none';
      final level = getMoodLevel(mood);
      if (level >= 0) {
        final x = (i + 0.5) * (size.width / dates.length);
        // Match the icon positioning: level 4 at top, level 0 at bottom
        final y = verticalPadding + availableHeight * (4 - level) / 4;
        points.add(Offset(x, y));
      }
    }

    if (points.length < 2) return;

    final path = Path()..moveTo(points[0].dx, points[0].dy);
    for (int i = 0; i < points.length - 1; i++) {
      final midX = (points[i].dx + points[i + 1].dx) / 2;
      path.quadraticBezierTo(
        midX,
        points[i].dy,
        points[i + 1].dx,
        points[i + 1].dy,
      );
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
