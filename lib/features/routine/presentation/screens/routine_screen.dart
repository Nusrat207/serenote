import 'package:flutter/material.dart';

class RoutineScreen extends StatefulWidget {
  const RoutineScreen({super.key});

  @override
  State<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> {
  final List<RoutineItem> _routines = [
    RoutineItem("Deep breath", "🫁", Colors.orange[100]!, false),
    RoutineItem("Brush teeth", "🪥", Colors.teal[100]!, false),
    RoutineItem("Wash face", "🧼", Colors.yellow[200]!, false),
    RoutineItem("Stretch", "🤸", Colors.teal[100]!, false),
  ];

  DateTime _selectedDate = DateTime.now();
  final Map<DateTime, List<String>> _completedRoutines = {};
  bool _showStreaksPage = false;

  String _getDateTitle(DateTime date) {
    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));
    
    if (_isSameDay(date, today)) {
      return "Today";
    } else if (_isSameDay(date, tomorrow)) {
      return "Tomorrow";
    } else {
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[date.month - 1]} ${date.day}';
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  void _addNewRoutine() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AddRoutineBottomSheet(
          onRoutineAdded: (newRoutine) {
            setState(() {
              _routines.add(newRoutine);
            });
          },
        );
      },
    );
  }

  void _goToToday() {
    setState(() {
      _selectedDate = DateTime.now();
    });
  }

  void _toggleStreaksPage() {
    setState(() {
      _showStreaksPage = !_showStreaksPage;
    });
  }

  List<DateTime> _getWeekDates(DateTime centerDate) {
    // Get the first day of the week (Sunday)
    final firstDayOfWeek = centerDate.subtract(Duration(days: centerDate.weekday % 7));
    
    // Generate 7 days starting from Sunday
    return List.generate(7, (index) {
      return DateTime(
        firstDayOfWeek.year,
        firstDayOfWeek.month,
        firstDayOfWeek.day + index
      );
    });
  }

  void _completeRoutine(String routineTitle) {
    setState(() {
      // Create a date key without time
      final dateKey = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
      
      if (!_completedRoutines.containsKey(dateKey)) {
        _completedRoutines[dateKey] = [];
      }
      
      if (_completedRoutines[dateKey]!.contains(routineTitle)) {
        _completedRoutines[dateKey]!.remove(routineTitle);
        if (_completedRoutines[dateKey]!.isEmpty) {
          _completedRoutines.remove(dateKey);
        }
      } else {
        _completedRoutines[dateKey]!.add(routineTitle);
      }
    });
  }

  bool _isRoutineCompleted(String routineTitle) {
    final dateKey = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    return _completedRoutines[dateKey]?.contains(routineTitle) ?? false;
  }

  int _getCurrentStreak() {
    final today = DateTime.now();
    var currentDate = today;
    int streak = 0;
    
    // Check if today has completed routines
    final todayKey = DateTime(today.year, today.month, today.day);
    final hasTodayCompleted = _completedRoutines[todayKey]?.isNotEmpty ?? false;
    
    if (hasTodayCompleted) {
      streak++;
      currentDate = today.subtract(const Duration(days: 1));
    } else {
      return 0; // No streak if today is not completed
    }
    
    // Check previous days
    while (true) {
      final dateKey = DateTime(currentDate.year, currentDate.month, currentDate.day);
      final hasCompleted = _completedRoutines[dateKey]?.isNotEmpty ?? false;
      
      if (hasCompleted) {
        streak++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    
    return streak;
  }

  int _getLongestStreak() {
    if (_completedRoutines.isEmpty) return 0;
    
    final sortedDates = _completedRoutines.keys.toList()..sort();
    int longestStreak = 0;
    int currentStreak = 1;
    
    for (int i = 1; i < sortedDates.length; i++) {
      final previousDate = sortedDates[i - 1];
      final currentDate = sortedDates[i];
      final difference = currentDate.difference(previousDate).inDays;
      
      if (difference == 1) {
        currentStreak++;
      } else {
        longestStreak = longestStreak > currentStreak ? longestStreak : currentStreak;
        currentStreak = 1;
      }
    }
    
    return longestStreak > currentStreak ? longestStreak : currentStreak;
  }

  Widget _buildStreaksPage() {
    final currentStreak = _getCurrentStreak();
    final longestStreak = _getLongestStreak();
    final today = DateTime.now();
    final todayKey = DateTime(today.year, today.month, today.day);
    final hasTodayCompleted = _completedRoutines[todayKey]?.isNotEmpty ?? false;

    return Scaffold(
      backgroundColor: const Color(0xFFF5EFFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Streaks",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: _toggleStreaksPage,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Streak Stats
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    "$currentStreak",
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.purpleAccent,
                    ),
                  ),
                  const Text(
                    "day streak",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (!hasTodayCompleted) ...[
                    const Text(
                      "Make today your Day 1. Let's get started!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _showStreaksPage = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purpleAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                      child: const Text(
                        "Complete Today's Routines",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ] else ...[
                    const Text(
                      "Keep going! You're doing great!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            "$longestStreak",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const Text(
                            "Longest Streak",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "${_completedRoutines.length}",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const Text(
                            "Total Days",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Streak Calendar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Streak Calendar",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildStreakCalendar(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakCalendar() {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday;
    
    List<DateTime?> calendarDays = [];
    
    // Add empty days for the beginning of the month
    for (int i = 1; i < firstWeekday; i++) {
      calendarDays.add(null);
    }
    
    // Add all days of the month
    for (int i = 1; i <= lastDayOfMonth.day; i++) {
      calendarDays.add(DateTime(now.year, now.month, i));
    }

    return Column(
      children: [
        // Month header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.chevron_left, color: Colors.grey),
            Text(
              "${_getMonthName(now.month)} ${now.year}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
        const SizedBox(height: 16),
        // Weekday headers
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("S", style: TextStyle(fontSize: 12, color: Colors.grey)),
            Text("M", style: TextStyle(fontSize: 12, color: Colors.grey)),
            Text("T", style: TextStyle(fontSize: 12, color: Colors.grey)),
            Text("W", style: TextStyle(fontSize: 12, color: Colors.grey)),
            Text("T", style: TextStyle(fontSize: 12, color: Colors.grey)),
            Text("F", style: TextStyle(fontSize: 12, color: Colors.grey)),
            Text("S", style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 8),
        // Calendar grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: calendarDays.length,
          itemBuilder: (context, index) {
            final day = calendarDays[index];
            if (day == null) {
              return const SizedBox();
            }
            
            final isToday = _isSameDay(day, DateTime.now());
            final isCompleted = _completedRoutines.containsKey(DateTime(day.year, day.month, day.day));
            
            return Container(
              decoration: BoxDecoration(
                color: isCompleted 
                    ? Colors.purpleAccent 
                    : isToday 
                        ? Colors.purpleAccent.withOpacity(0.1)
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: isToday 
                    ? Border.all(color: Colors.purpleAccent, width: 2)
                    : null,
              ),
              child: Center(
                child: Text(
                  day.day.toString(),
                  style: TextStyle(
                    color: isCompleted 
                        ? Colors.white 
                        : isToday 
                            ? Colors.purpleAccent 
                            : Colors.black87,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = ['January', 'February', 'March', 'April', 'May', 'June', 
                   'July', 'August', 'September', 'October', 'November', 'December'];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    if (_showStreaksPage) {
      return _buildStreaksPage();
    }

    final weekDates = _getWeekDates(_selectedDate);

    return Scaffold(
      backgroundColor: const Color(0xFFF5EFFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Column(
          children: [
            Text(
              _getDateTitle(_selectedDate),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            // Today button
            GestureDetector(
              onTap: _goToToday,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _isSameDay(_selectedDate, DateTime.now()) 
                      ? Colors.purpleAccent 
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Today",
                  style: TextStyle(
                    color: _isSameDay(_selectedDate, DateTime.now()) 
                        ? Colors.white 
                        : Colors.black87,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          // Streaks button
          IconButton(
            icon: const Icon(Icons.local_fire_department, color: Colors.orange),
            onPressed: _toggleStreaksPage,
          ),
        ],
      ),
      body: Column(
        children: [
          // Week row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: weekDates.map((date) {
                final isSelected = _isSameDay(date, _selectedDate);
                final isToday = _isSameDay(date, DateTime.now());
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        _getDayAbbreviation(date.weekday),
                        style: TextStyle(
                          color: isSelected ? Colors.black : Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.purpleAccent : Colors.transparent,
                          border: isToday && !isSelected
                              ? Border.all(color: Colors.purpleAccent, width: 2)
                              : null,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(
                            color: isSelected ? Colors.white : 
                                  isToday ? Colors.purpleAccent : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Removed the depression test banner card
                  const SizedBox(height: 12),
                  ..._routines.map((routine) => _buildRoutineCard(routine)).toList(),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purpleAccent,
        onPressed: _addNewRoutine,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  String _getDayAbbreviation(int weekday) {
    switch (weekday) {
      case 1: return 'Mon';
      case 2: return 'Tue';
      case 3: return 'Wed';
      case 4: return 'Thu';
      case 5: return 'Fri';
      case 6: return 'Sat';
      case 7: return 'Sun';
      default: return '';
    }
  }

  Widget _buildRoutineCard(RoutineItem routine) {
    final isCompleted = _isRoutineCompleted(routine.title);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: routine.color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Text(routine.emoji, style: const TextStyle(fontSize: 30)),
        title: Text(
          routine.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
        subtitle: const Text("Anytime"),
        trailing: IconButton(
          icon: Icon(
            isCompleted ? Icons.check_circle : Icons.circle_outlined,
            color: isCompleted ? Colors.green : Colors.grey,
          ),
          onPressed: () {
            _completeRoutine(routine.title);
          },
        ),
        onTap: () {
          _completeRoutine(routine.title);
        },
      ),
    );
  }
}

class AddRoutineBottomSheet extends StatefulWidget {
  final Function(RoutineItem) onRoutineAdded;

  const AddRoutineBottomSheet({super.key, required this.onRoutineAdded});

  @override
  State<AddRoutineBottomSheet> createState() => _AddRoutineBottomSheetState();
}

class _AddRoutineBottomSheetState extends State<AddRoutineBottomSheet> {
  final TextEditingController _routineController = TextEditingController();
  String _selectedEmoji = "⭐";
  Color _selectedColor = Colors.blue[100]!;

  final List<Map<String, dynamic>> _emojiOptions = [
    {"emoji": "🫁", "color": Colors.orange[100]!},
    {"emoji": "🪥", "color": Colors.teal[100]!},
    {"emoji": "🧼", "color": Colors.yellow[200]!},
    {"emoji": "🤸", "color": Colors.teal[100]!},
    {"emoji": "⭐", "color": Colors.blue[100]!},
    {"emoji": "🏃", "color": Colors.green[100]!},
    {"emoji": "📖", "color": Colors.purple[100]!},
    {"emoji": "💧", "color": Colors.blue[100]!},
    {"emoji": "☕", "color": Colors.brown[100]!},
    {"emoji": "🧘", "color": Colors.pink[100]!},
  ];

  void _addRoutine() {
    if (_routineController.text.trim().isNotEmpty) {
      final newRoutine = RoutineItem(
        _routineController.text.trim(),
        _selectedEmoji,
        _selectedColor,
        false,
      );
      
      widget.onRoutineAdded(newRoutine);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Add New Routine",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _routineController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Routine Name',
              hintText: 'e.g., Morning Meditation',
            ),
            onSubmitted: (_) => _addRoutine(),
          ),
          const SizedBox(height: 16),
          const Text(
            "Select Emoji:",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _emojiOptions.length,
              itemBuilder: (context, index) {
                final option = _emojiOptions[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedEmoji = option["emoji"];
                      _selectedColor = option["color"];
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _selectedEmoji == option["emoji"]
                          ? Colors.grey[300]
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      option["emoji"],
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purpleAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: _addRoutine,
              child: const Text(
                "Add Routine",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class RoutineItem {
  final String title;
  final String emoji;
  final Color color;
  bool isCompleted;

  RoutineItem(this.title, this.emoji, this.color, this.isCompleted);
}