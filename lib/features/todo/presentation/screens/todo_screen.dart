import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:serenote/core/services/supabase_service.dart';
import 'package:serenote/core/models/todo_item.dart';

class RoutineScreen extends StatefulWidget {
  const RoutineScreen({super.key});

  @override
  State<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> {
  final List<ToDoItem> _todos = [];
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadTodosForDate(_selectedDate);
  }

  Future<void> _loadTodosForDate(DateTime date) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final formattedDate = _formatDate(date);
      
      final response = await SupabaseService().client
          .from('todos')
          .select()
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
            decoration: const InputDecoration(
              hintText: 'Enter your task...',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (newTodo.trim().isNotEmpty) {
                  Navigator.of(context).pop(newTodo.trim());
                }
              },
              child: const Text('Add'),
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
    try {
      final newTodo = ToDoItem(
        title: title,
        isCompleted: false,
        taskDate: _selectedDate,
      );

      final response = await SupabaseService().client
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
    final todo = _todos[index];
    final updatedTodo = todo.copyWith(isCompleted: !todo.isCompleted);

    try {
      final response = await SupabaseService().client
          .from('todos')
          .update({'is_completed': updatedTodo.isCompleted})
          .eq('id', todo.id!)
          .select()
          .single();

      if (response != null) {
        setState(() {
          _todos[index] = ToDoItem.fromMap(response);
        });
      }
    } catch (e) {
      print('Error updating todo: $e');
      // Revert on error
      setState(() {
        _todos[index] = todo;
      });
    }
  }

  Future<void> _deleteTodo(int index) async {
    final todo = _todos[index];
    
    try {
      await SupabaseService().client
          .from('todos')
          .delete()
          .eq('id', todo.id!);

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
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[date.month - 1]} ${date.day}';
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  void _goToToday() {
    setState(() {
      _selectedDate = DateTime.now();
    });
    _loadTodosForDate(_selectedDate);
  }

  List<DateTime> _getWeekDates(DateTime centerDate) {
    final firstDayOfWeek = centerDate.subtract(Duration(days: centerDate.weekday % 7));
    
    return List.generate(7, (index) {
      return DateTime(
        firstDayOfWeek.year,
        firstDayOfWeek.month,
        firstDayOfWeek.day + index
      );
    });
  }

  void _navigateToDashboard() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final weekDates = _getWeekDates(_selectedDate);

    return Scaffold(
      backgroundColor: const Color(0xFFF5EFFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: _navigateToDashboard,
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
      ),
      body: Column(
        children: [
          // Calendar Week Row
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
                    _loadTodosForDate(date);
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
          
          // To Do Section Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "To Do",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  "${_todos.where((todo) => todo.isCompleted).length}/${_todos.length}",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          
          // To Do List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _todos.length,
                    itemBuilder: (context, index) {
                      final todo = _todos[index];
                      return _buildTodoItem(todo, index);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purpleAccent,
        onPressed: _addNewTodo,
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

  Widget _buildTodoItem(ToDoItem todo, int index) {
    return Dismissible(
      key: Key(todo.id ?? 'todo_$index'),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        _deleteTodo(index);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                todo.title,
                style: TextStyle(
                  fontSize: 16,
                  decoration: todo.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                  color: todo.isCompleted ? Colors.grey : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}