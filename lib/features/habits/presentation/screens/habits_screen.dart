// lib/features/habits/presentation/screens/habits_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../habits/presentation/widgets/habit_card_widget.dart';
import '../../domain/entities/habit_entity.dart';
import '../providers/habit_provider.dart';

class HabitsScreen extends ConsumerStatefulWidget {
  const HabitsScreen({super.key});

  @override
  ConsumerState<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends ConsumerState<HabitsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(habitNotifierProvider.notifier).loadHabits();
    });
  }

  @override
  Widget build(BuildContext context) {
    final habitState = ref.watch(habitNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Habits'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddHabitDialog(context),
          ),
        ],
      ),
      body: habitState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : habitState.error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${habitState.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(habitNotifierProvider.notifier).loadHabits();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : habitState.habits.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No habits yet',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create your first habit to get started',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _showAddHabitDialog(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Habit'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: habitState.habits.length,
              itemBuilder: (context, index) {
                final habit = habitState.habits[index];
                return HabitCardWidget(
                  habit: habit,
                  onToggle: (date) {
                    ref
                        .read(habitNotifierProvider.notifier)
                        .toggleHabitCompletion(habit.id, date);
                  },
                  onDelete: () {
                    ref
                        .read(habitNotifierProvider.notifier)
                        .deleteHabit(habit.id);
                  },
                  assignedDays: habit.assignedDays,
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddHabitDialog(context),
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddHabitDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    Set<int> selectedDays = {
      1,
      2,
      3,
      4,
      5,
      6,
      7,
    }; // All days selected by default
    String selectedIcon = '💧';
    Color selectedColor = Colors.cyan;

    final iconOptions = [
      ('💧', Colors.cyan),
      ('📔', Colors.purple),
      ('💪', Colors.red),
      ('📚', Colors.orange),
      ('🥗', Colors.green),
      ('✨', Colors.yellow),
      ('🐕', Colors.brown),
      ('👨‍🍳', Colors.amber),
      ('🧘', Colors.indigo),
      ('🚴', Colors.teal),
    ];

    final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add New Habit'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon selector
                const Text(
                  'Select Icon:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: iconOptions.map((option) {
                    final (icon, color) = option;
                    final isSelected = icon == selectedIcon;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIcon = icon;
                          selectedColor = color;
                        });
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected ? Colors.black : Colors.grey,
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          color: isSelected
                              ? color.withValues(alpha: 0.2)
                              : Colors.transparent,
                        ),
                        child: Center(
                          child: Text(
                            icon,
                            style: const TextStyle(fontSize: 28),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: 'Habit name (e.g., Drink water)',
                    labelText: 'Name',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    hintText: 'Description (optional)',
                    labelText: 'Description',
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Select Days:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(7, (index) {
                    final dayValue = index + 1; // 1=Monday, 7=Sunday
                    final isSelected = selectedDays.contains(dayValue);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            if (selectedDays.length > 1) {
                              selectedDays.remove(dayValue);
                            }
                          } else {
                            selectedDays.add(dayValue);
                          }
                        });
                      },
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? selectedColor.withValues(alpha: 0.2)
                              : Colors.grey.shade200,
                          border: Border.all(
                            color: isSelected
                                ? selectedColor
                                : Colors.grey.shade400,
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            dayNames[index],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? selectedColor
                                  : Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 8),
                Text(
                  '${selectedDays.length} day${selectedDays.length == 1 ? '' : 's'} selected',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  ref
                      .read(habitNotifierProvider.notifier)
                      .createHabit(
                        name: nameController.text,
                        description: descriptionController.text,
                        icon: selectedIcon,
                        color: selectedColor.value.toRadixString(16),
                        targetDaysPerWeek: selectedDays.length,
                        assignedDays: selectedDays.toList()..sort(),
                      );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Habit created successfully!'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a habit name')),
                  );
                }
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
