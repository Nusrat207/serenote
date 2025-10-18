import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:serenote/core/services/supabase_service.dart';
import 'package:serenote/core/models/todo_item.dart';
import 'package:serenote/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serenote/features/mood/presentation/providers/mood_provider.dart';
import 'package:serenote/l10n/app_localizations.dart';


class RoutineScreen extends ConsumerStatefulWidget {
  const RoutineScreen({super.key});

  @override
  ConsumerState<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends ConsumerState<RoutineScreen> {
  final List<ToDoItem> _todos = [];
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  final SupabaseClient _supabase = SupabaseService().client;
  User? _currentUser;

  // New variables for expandable calendar
  bool _isCalendarExpanded = false;
  bool _isDragging = false;
  double _dragStartY = 0.0;

 @override
void initState() {
  super.initState();
  _getCurrentUser();
  if (_supabase.auth.currentUser != null) {
    _loadTodosForDate(_selectedDate);
  }
}

void _getCurrentUser() {
  setState(() {
    _currentUser = _supabase.auth.currentUser;
  });
}


  void _redirectToLogin() {
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    }
  }

  Future<void> _loadTodosForDate(DateTime date) async {
    if (_currentUser == null) {
      //_redirectToLogin(); // Changed to _redirectToLogin
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final formattedDate = _formatDate(date);

      final response = await _supabase
          .from('todos')
          .select()
          .eq('user_id', _currentUser!.id)
          .eq('task_date', formattedDate)
          .order('created_at');

      if (response != null) {
        setState(() {
          _todos.clear();
          for (final item in response) {
            _todos.add(ToDoItem.fromMap(item));
          }
        });
      }
    } catch (e) {
      print('Error loading todos: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addNewTodo() async {
    if (_currentUser == null) {
      //_redirectToLogin(); // Changed to _redirectToLogin
      return;
    }

    final result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        String newTodo = '';
        return AlertDialog(
          title: const Text('Add New Task'),
          content: TextField(
            onChanged: (value) {
              newTodo = value;
            },
            decoration: InputDecoration(hintText: AppLocalizations.of(context)?.todo_add_hint ?? 'Enter your task...'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)?.journal_cancel ?? 'Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (newTodo.trim().isNotEmpty) {
                  Navigator.of(context).pop(newTodo.trim());
                }
              },
              child: Text(AppLocalizations.of(context)?.todo_add ?? 'Add'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      await _saveTodoToSupabase(result);
    }
  }

  Future<void> _saveTodoToSupabase(String title) async {
    if (_currentUser == null) {
      //_redirectToLogin(); // Changed to _redirectToLogin
      return;
    }

    try {
      final newTodo = ToDoItem(
        title: title,
        isCompleted: false,
        taskDate: _selectedDate,
        userId: _currentUser!.id,
      );

      final response = await _supabase
          .from('todos')
          .insert(newTodo.toMap())
          .select()
          .single();

      if (response != null) {
        setState(() {
          _todos.add(ToDoItem.fromMap(response));
        });
      }
    } catch (e) {
      print('Error saving todo: $e');
    }
  }

  Future<void> _toggleTodo(int index) async {
    if (_currentUser == null) {
      //_redirectToLogin(); // Changed to _redirectToLogin
      return;
    }

    final todo = _todos[index];
    final updatedTodo = todo.copyWith(isCompleted: !todo.isCompleted);

    try {
      final response = await _supabase
          .from('todos')
          .update({'is_completed': updatedTodo.isCompleted})
          .eq('id', todo.id!)
          .eq('user_id', _currentUser!.id)
          .select()
          .single();

      if (response != null) {
        setState(() {
          _todos[index] = ToDoItem.fromMap(response);
        });
      }
    } catch (e) {
      print('Error updating todo: $e');
      setState(() {
        _todos[index] = todo;
      });
    }
  }

  Future<void> _deleteTodo(int index) async {
    if (_currentUser == null) {
      //_redirectToLogin(); // Changed to _redirectToLogin
      return;
    }

    final todo = _todos[index];

    try {
      await _supabase
          .from('todos')
          .delete()
          .eq('id', todo.id!)
          .eq('user_id', _currentUser!.id);

      setState(() {
        _todos.removeAt(index);
      });
    } catch (e) {
      print('Error deleting todo: $e');
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _getDateTitle(DateTime date) {
    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));

    if (_isSameDay(date, today)) {
      return "Today";
    } else if (_isSameDay(date, tomorrow)) {
      return "Tomorrow";
    } else {
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[date.month - 1]} ${date.day}';
    }
  }

  String _getMonthYear(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void _goToToday() {
    setState(() {
      _selectedDate = DateTime.now();
    });
    _loadTodosForDate(_selectedDate);
  }

  List<DateTime> _getWeekDates(DateTime centerDate) {
    final firstDayOfWeek = centerDate.subtract(
      Duration(days: centerDate.weekday % 7),
    );

    return List.generate(7, (index) {
      return DateTime(
        firstDayOfWeek.year,
        firstDayOfWeek.month,
        firstDayOfWeek.day + index,
      );
    });
  }

  void _navigateToDashboard() {
    Navigator.of(context).pop();
  }

  // New method to toggle calendar expansion
  void _toggleCalendarExpansion() {
    setState(() {
      _isCalendarExpanded = !_isCalendarExpanded;
    });
  }

  // New method to generate month calendar dates
  List<DateTime> _getMonthDates(DateTime date) {
    final firstDayOfMonth = DateTime(date.year, date.month, 1);
    final firstDayOfCalendar = firstDayOfMonth.subtract(
      Duration(days: firstDayOfMonth.weekday % 7),
    );

    return List.generate(42, (index) {
      // 6 weeks
      return DateTime(
        firstDayOfCalendar.year,
        firstDayOfCalendar.month,
        firstDayOfCalendar.day + index,
      );
    });
  }

  // Handle drag gestures
  void _handleDragStart(DragStartDetails details) {
    _dragStartY = details.globalPosition.dy;
    setState(() {
      _isDragging = true;
    });
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    final double currentY = details.globalPosition.dy;
    final double deltaY = currentY - _dragStartY;

    // Expand when dragging down significantly
    if (deltaY > 50 && !_isCalendarExpanded) {
      _toggleCalendarExpansion();
      _isDragging = false;
    }
    // Collapse when dragging up significantly
    else if (deltaY < -50 && _isCalendarExpanded) {
      _toggleCalendarExpansion();
      _isDragging = false;
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    setState(() {
      _isDragging = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final moodColor = ref
        .watch(moodColorProvider)
        .maybeWhen(
          data: (c) => c,
          orElse: () => const Color(0xFF477D9E), // fallback
        );

    Color lighten(Color color, [double amount = 0.5]) {
      final hsl = HSLColor.fromColor(color);
      return hsl.withLightness((hsl.lightness + amount).clamp(0, 1)).toColor();
    }

    // In your build:
    final lightMood = lighten(moodColor, 0.2);

    final weekDates = _getWeekDates(_selectedDate);
    final monthDates = _getMonthDates(_selectedDate);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [lightMood, Theme.of(context).scaffoldBackgroundColor],
          stops: const [0.0, 0.5],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: moodColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: Colors.white,
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
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
              GestureDetector(
                onTap: _goToToday,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _isSameDay(_selectedDate, DateTime.now())
                        ? moodColor
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    AppLocalizations.of(context)?.today ?? "Today",
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
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Expandable Calendar Section with FIXED overflow
              GestureDetector(
                onVerticalDragStart: _handleDragStart,
                onVerticalDragUpdate: _handleDragUpdate,
                onVerticalDragEnd: _handleDragEnd,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: _isCalendarExpanded ? 350 : 140,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Month and Year Header
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Text(
                            _getMonthYear(_selectedDate),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        // Week Calendar (always visible)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:
                                [
                                  'Sun',
                                  'Mon',
                                  'Tue',
                                  'Wed',
                                  'Thu',
                                  'Fri',
                                  'Sat',
                                ].map((day) {
                                  return SizedBox(
                                    width: 36,
                                    child: Text(
                                      day,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: weekDates.map((date) {
                              final isSelected = _isSameDay(
                                date,
                                _selectedDate,
                              );
                              final isToday = _isSameDay(date, DateTime.now());
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedDate = date;
                                  });
                                  _loadTodosForDate(date);
                                },
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? moodColor
                                        : Colors.transparent,
                                    border: isToday && !isSelected
                                        ? Border.all(color: moodColor, width: 2)
                                        : null,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Center(
                                    child: Text(
                                      date.day.toString(),
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : isToday
                                            ? moodColor
                                            : Colors.black54,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),

                        // Expandable Month Calendar - FIXED overflow with proper constraints
                        if (_isCalendarExpanded) ...[
                          const SizedBox(height: 16),
                          Container(
                            height: 200, // Fixed height to prevent overflow
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: GridView.builder(
                              physics: const ClampingScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 7,
                                    childAspectRatio: 1.0,
                                  ),
                              itemCount: monthDates.length,
                              itemBuilder: (context, index) {
                                final date = monthDates[index];
                                final isCurrentMonth =
                                    date.month == _selectedDate.month;
                                final isSelected = _isSameDay(
                                  date,
                                  _selectedDate,
                                );
                                final isToday = _isSameDay(
                                  date,
                                  DateTime.now(),
                                );

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedDate = date;
                                      _isCalendarExpanded = false;
                                    });
                                    _loadTodosForDate(date);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? moodColor
                                          : Colors.transparent,
                                      border: isToday && !isSelected
                                          ? Border.all(
                                              color: moodColor,
                                              width: 2,
                                            )
                                          : null,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Center(
                                      child: Text(
                                        date.day.toString(),
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.white
                                              : isCurrentMonth
                                              ? Colors.black87
                                              : Colors.grey,
                                          fontWeight: isSelected || isToday
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],

                        // Drag indicator
                        if (!_isCalendarExpanded) // Only show when collapsed
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Icon(
                              _isCalendarExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              // To Do Section Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)?.todo_title ?? "To Do",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      "${_todos.where((todo) => todo.isCompleted).length}/${_todos.length}",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              // Single Card with all todos
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/todo2.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: _isLoading
                        ? const Padding(
                            padding: EdgeInsets.all(40.0),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : _currentUser == null
  ? Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock_outline, size: 70, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)?.todo_login_title ?? 'Login to manage your tasks',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)?.todo_login_desc ?? 'Sign in to add, edit, and view your daily routines.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _redirectToLogin,
            icon: const Icon(Icons.login, color: Colors.black),
            label: Text(AppLocalizations.of(context)?.journal_login_button ?? 'Login'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 216, 240, 245),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    )

                        : _todos.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.task_outlined,
                                  size: 60,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  AppLocalizations.of(context)?.todo_no_tasks ?? 'No tasks for today!',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Add a new task to get started',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                ..._todos.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final todo = entry.value;
                                  return _buildTodoListItem(todo, index);
                                }).toList(),
                              ],
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 100), // Extra space at bottom for FAB
            ],
          ),
        ),
        floatingActionButton: _currentUser != null
            ? FloatingActionButton(
                backgroundColor: moodColor,
                onPressed: _addNewTodo,
                child: const Icon(Icons.add, color: Colors.white),
              )
            : null,
      ),
    );
  }

  Widget _buildTodoListItem(ToDoItem todo, int index) {
    return Dismissible(
      key: Key(todo.id ?? 'todo_$index'),
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        _deleteTodo(index);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5), // subtle background
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.center, // Align checkbox & text vertically
          children: [
            Checkbox(
              value: todo.isCompleted,
              onChanged: (bool? value) {
                _toggleTodo(index);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                todo.title,
                style: TextStyle(
                  fontSize: 16,
                  decoration: todo.isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  color: todo.isCompleted ? Colors.grey : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
