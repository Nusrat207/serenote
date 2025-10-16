import 'package:flutter/material.dart';
import '../../domain/entities/habit_entity.dart';

class HabitCardWidget extends StatefulWidget {
  final HabitEntity habit;
  final Function(DateTime) onToggle;
  final VoidCallback onDelete;
  final List<int>? assignedDays;

  const HabitCardWidget({
    super.key,
    required this.habit,
    required this.onToggle,
    required this.onDelete,
    this.assignedDays,
  });

  @override
  State<HabitCardWidget> createState() => _HabitCardWidgetState();
}

class _HabitCardWidgetState extends State<HabitCardWidget> {
  late Color _habitColor;

  @override
  void initState() {
    super.initState();
    _habitColor = _parseColor(widget.habit.color);
  }

  // Get the week dates starting from Monday
  List<DateTime> _getWeekDates() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    return List.generate(7, (index) {
      return DateTime(monday.year, monday.month, monday.day + index);
    });
  }

  String _getDayLabel(int index) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[index];
  }

  String _getMonthName(int month) {
    const months = [
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
    return months[month - 1];
  }

  // Normalize date to remove time component
  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  // Check if a date is completed
  bool _isDateCompleted(DateTime date) {
    final normalizedDate = _normalizeDate(date);
    return widget.habit.completedDates.any(
      (d) => _normalizeDate(d).isAtSameMomentAs(normalizedDate),
    );
  }

  // Check if a date can be toggled (completed)
  bool _canToggleDate(DateTime date) {
    final today = _normalizeDate(DateTime.now());
    final normalizedDate = _normalizeDate(date);
    final normalizedCreatedAt = _normalizeDate(widget.habit.createdAt);

    // Can't complete dates before habit was created
    if (normalizedDate.isBefore(normalizedCreatedAt)) {
      return false;
    }

    // Can complete today and past dates, but NOT future dates
    if (normalizedDate.isAfter(today)) {
      return false;
    }

    return true;
  }

  // Check if date is assigned for this habit
  bool _isAssignedDay(DateTime date) {
    final weekday = date.weekday; // 1=Monday, 7=Sunday
    if (widget.assignedDays == null || widget.assignedDays!.isEmpty) {
      return true; // If no assigned days, all days are available
    }
    return widget.assignedDays!.contains(weekday);
  }

  // Parse color from hex string
  Color _parseColor(String colorString) {
    try {
      if (colorString.startsWith('#')) {
        return Color(int.parse('0xff${colorString.substring(1)}'));
      } else {
        return Color(int.parse('0xff$colorString'));
      }
    } catch (e) {
      return Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    final weekDates = _getWeekDates();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon, name, and delete button
              Row(
                children: [
                  Text(widget.habit.icon, style: const TextStyle(fontSize: 32)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.habit.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (widget.habit.description != null &&
                            widget.habit.description!.isNotEmpty)
                          Text(
                            widget.habit.description!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    color: Colors.red.shade300,
                    onPressed: widget.onDelete,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Week header with month display
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'This Week',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  Text(
                    '${_getMonthName(weekDates.first.month)} ${weekDates.first.year}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Week days tracker
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (index) {
                  final date = weekDates[index];
                  final dayLabel = _getDayLabel(index);
                  final isCompleted = _isDateCompleted(date);
                  final canToggle = _canToggleDate(date);
                  final isAssigned = _isAssignedDay(date);
                  final isToday =
                      DateTime.now().day == date.day &&
                      DateTime.now().month == date.month &&
                      DateTime.now().year == date.year;

                  return GestureDetector(
                    onTap: canToggle && isAssigned
                        ? () => widget.onToggle(date)
                        : null,
                    child: Column(
                      children: [
                        Text(
                          dayLabel,
                          style: TextStyle(
                            fontSize: 11,
                            color: isToday
                                ? _habitColor
                                : isAssigned
                                ? Colors.grey.shade600
                                : Colors.grey.shade400,
                            fontWeight: isToday
                                ? FontWeight.bold
                                : FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: isToday
                                ? _habitColor.withValues(alpha: 0.15)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${date.day}',
                            style: TextStyle(
                              fontSize: 10,
                              color: isToday
                                  ? _habitColor
                                  : Colors.grey.shade500,
                              fontWeight: isToday
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isCompleted
                                ? _habitColor.withValues(alpha: 0.2)
                                : Colors.grey.shade100,
                            border: Border.all(
                              color: isCompleted
                                  ? _habitColor
                                  : isToday
                                  ? _habitColor.withValues(alpha: 0.5)
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: isCompleted
                                ? Icon(
                                    Icons.check,
                                    color: _habitColor,
                                    size: 18,
                                  )
                                : !isAssigned
                                ? Icon(
                                    Icons.lock_outline,
                                    color: Colors.grey.shade400,
                                    size: 14,
                                  )
                                : isToday
                                ? Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _habitColor,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 12),

              // Stats row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    label: 'Current',
                    value: '${widget.habit.currentStreak}',
                  ),
                  _buildStatItem(
                    label: 'Longest',
                    value: '${widget.habit.longestStreak}',
                  ),
                  _buildStatItem(
                    label: 'Total',
                    value: '${widget.habit.totalCompletions}',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({required String label, required String value}) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: _habitColor,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
