import 'package:flutter/material.dart';
import '../../domain/entities/habit_entity.dart';

class HabitCardWidget extends StatefulWidget {
  final HabitEntity habit;
  final Function(DateTime) onToggle;
  final VoidCallback onDelete;
  final List<int>? assignedDays;

  const HabitCardWidget({
    Key? key,
    required this.habit,
    required this.onToggle,
    required this.onDelete,
    this.assignedDays,
  }) : super(key: key);

  @override
  State<HabitCardWidget> createState() => _HabitCardWidgetState();
}

class _HabitCardWidgetState extends State<HabitCardWidget> {
  int streak = 0;
  final Set<int> selectedDays = {};

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final startOfWeek = today.subtract(Duration(days: today.weekday % 7));

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------- TOP ROW ----------------
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.habit.icon, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 12),

                // Habit details and day selector
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Habit name
                      Text(
                        widget.habit.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),

                      if (widget.habit.description != null &&
                          widget.habit.description!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          widget.habit.description!,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],

                      const SizedBox(height: 12),

                      // Weekday selector evenly spaced
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(7, (index) {
                          final dayDate = startOfWeek.add(
                            Duration(days: index),
                          );
                          final dayName = _getDayAbbreviation(index);
                          final isAssigned = _isDayAssigned(index);
                          final isSelected = selectedDays.contains(index);

                          return GestureDetector(
                            onTap: isAssigned
                                ? () {
                                    setState(() {
                                      if (isSelected) {
                                        selectedDays.remove(index);
                                        streak--;
                                      } else {
                                        selectedDays.add(index);
                                        streak++;
                                      }
                                    });
                                    widget.onToggle(dayDate);
                                  }
                                : null,
                            child: Opacity(
                              opacity: isAssigned ? 1.0 : 0.35,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    dayName,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: isAssigned
                                          ? Colors.grey.shade600
                                          : Colors.grey.shade400,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelected
                                          ? _parseColor(widget.habit.color)
                                          : Colors.grey.shade200,
                                      border: Border.all(
                                        color: isSelected
                                            ? _parseColor(widget.habit.color)
                                            : Colors.grey.shade400,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: isSelected
                                        ? const Center(
                                            child: Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: 15,
                                            ),
                                          )
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // ---------------- STREAK + MENU ----------------
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.local_fire_department,
                            size: 14,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$streak',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'days',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    PopupMenuButton(
                      icon: const Icon(Icons.more_vert, size: 18),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: const Text('Delete'),
                          onTap: widget.onDelete,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- Helper Methods ----------------
  bool _isDayAssigned(int weekdayIndex) {
    if (widget.assignedDays == null || widget.assignedDays!.isEmpty)
      return true;
    final weekday = weekdayIndex == 6 ? 7 : weekdayIndex + 1;
    return widget.assignedDays!.contains(weekday);
  }

  String _getDayAbbreviation(int index) {
    switch (index) {
      case 0:
        return 'Mo';
      case 1:
        return 'Tu';
      case 2:
        return 'We';
      case 3:
        return 'Th';
      case 4:
        return 'Fr';
      case 5:
        return 'Sa';
      case 6:
        return 'Su';
      default:
        return '';
    }
  }

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
}
