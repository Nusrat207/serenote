// lib/features/habits/presentation/screens/habits_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../habits/presentation/widgets/habit_card_widget.dart';
import '../providers/habit_provider.dart';
import 'package:serenote/features/mood/presentation/providers/mood_provider.dart'; // ADD THIS IMPORT
import 'package:serenote/l10n/app_localizations.dart';

class HabitsScreen extends ConsumerStatefulWidget {
  const HabitsScreen({super.key});

  @override
  ConsumerState<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends ConsumerState<HabitsScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Load habits initially
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadHabitsIfAuthenticated();
    });

    // Listen to auth state changes
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      if (event == AuthChangeEvent.signedIn ||
          event == AuthChangeEvent.tokenRefreshed) {
        // User just logged in or token refreshed, reload habits
        if (mounted) {
          ref.read(habitNotifierProvider.notifier).clearError();
          ref.read(habitNotifierProvider.notifier).loadHabits();
        }
      } else if (event == AuthChangeEvent.signedOut) {
        // User logged out, clear habits
        if (mounted) {
          ref.read(habitNotifierProvider.notifier).clearError();
        }
      }
    });
  }

  void _loadHabitsIfAuthenticated() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      ref.read(habitNotifierProvider.notifier).clearError();
      ref.read(habitNotifierProvider.notifier).loadHabits();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Clear error and reload habits when app resumes
      _loadHabitsIfAuthenticated();
    }
  }

  bool _isAuthError(String? error) {
    if (error == null) return false;
    return error.contains('Unexpected null value') ||
        error.toLowerCase().contains('not logged in') ||
        error.toLowerCase().contains('authentication') ||
        error.toLowerCase().contains('user not found');
  }

  Color lighten(Color color, [double amount = 0.5]) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness + amount).clamp(0, 1)).toColor();
  }

  @override
  Widget build(BuildContext context) {
    final habitState = ref.watch(habitNotifierProvider);
    final user = Supabase.instance.client.auth.currentUser;
    final isAuthenticated = user != null;

    // WATCH THE MOOD COLOR PROVIDER
    final moodColor = ref
        .watch(moodColorProvider)
        .maybeWhen(
          data: (c) => c,
          orElse: () => const Color(0xFF477D9E), // fallback
        );

    final lightMood = lighten(moodColor, 0.01);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.habits_title ?? 'Habits'),
        backgroundColor:
            Colors.transparent, // CHANGED: Use mood color instead of white
        elevation: 0,
        foregroundColor:
            Colors.white, // CHANGED: Text/icons in white for contrast
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: moodColor, shape: BoxShape.circle),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: Colors.white,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Scrollable background image with low opacity
          Positioned.fill(
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                'assets/images/habit_bg.png',
                fit: BoxFit.cover,
                repeat: ImageRepeat.repeat,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback gradient if image not found
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.purple.withValues(alpha: 0.05),
                          Colors.blue.withValues(alpha: 0.05),
                          Colors.cyan.withValues(alpha: 0.05),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // Main scrollable content
          !isAuthenticated
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.login,
                        size: 64,
                        color: const Color.fromARGB(255, 11, 107, 102),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context)?.please_log_in ??
                            'Please log in',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          AppLocalizations.of(context)?.need_login_habits ??
                              'You need to be logged in to view and manage your habits',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                )
              : habitState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : habitState.error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isAuthError(habitState.error)
                            ? Icons.login
                            : Icons.error_outline,
                        size: 64,
                        color: _isAuthError(habitState.error)
                            ? Colors.blue
                            : Colors.red.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _isAuthError(habitState.error)
                            ? (AppLocalizations.of(context)?.please_log_in ??
                                  'Please log in')
                            : 'Error',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          _isAuthError(habitState.error)
                              ? (AppLocalizations.of(
                                      context,
                                    )?.need_login_habits ??
                                    'You need to be logged in to view and manage your habits')
                              : 'Error: ${habitState.error}',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Clear error and retry loading
                          ref.read(habitNotifierProvider.notifier).clearError();
                          ref.read(habitNotifierProvider.notifier).loadHabits();
                        },
                        icon: const Icon(Icons.refresh),
                        label: Text(
                          AppLocalizations.of(context)?.retry ?? 'Retry',
                        ),
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
                        AppLocalizations.of(context)?.no_habits_yet ??
                            'No habits yet',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context)?.create_first_habit ??
                            'Create your first habit to get started',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => _showAddHabitDialog(context),
                        icon: const Icon(Icons.add),
                        label: Text(
                          AppLocalizations.of(context)?.add_habit ??
                              'Add Habit',
                        ),
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
        ],
      ),
      floatingActionButton:
          isAuthenticated &&
              !habitState.isLoading &&
              habitState.error == null &&
              !_isAuthError(habitState.error)
          ? FloatingActionButton(
              onPressed: () => _showAddHabitDialog(context),
              backgroundColor: moodColor, // use mood color
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
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

    // Get localized day names
    final dayNames = [
      AppLocalizations.of(context)?.monday_short ?? 'Mon',
      AppLocalizations.of(context)?.tuesday_short ?? 'Tue',
      AppLocalizations.of(context)?.wednesday_short ?? 'Wed',
      AppLocalizations.of(context)?.thursday_short ?? 'Thu',
      AppLocalizations.of(context)?.friday_short ?? 'Fri',
      AppLocalizations.of(context)?.saturday_short ?? 'Sat',
      AppLocalizations.of(context)?.sunday_short ?? 'Sun',
    ];
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(
            AppLocalizations.of(context)?.add_new_habit ?? 'Add New Habit',
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon selector
                Text(
                  AppLocalizations.of(context)?.select_icon ?? 'Select Icon:',
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
                  decoration: InputDecoration(
                    hintText:
                        AppLocalizations.of(context)?.habit_name_hint ??
                        'Habit name (e.g., Drink water)',
                    labelText:
                        AppLocalizations.of(context)?.name_label ?? 'Name',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    hintText:
                        AppLocalizations.of(context)?.description_hint ??
                        'Description (optional)',
                    labelText:
                        AppLocalizations.of(context)?.description_label ??
                        'Description',
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context)?.select_days ?? 'Select Days:',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
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
                  (AppLocalizations.of(
                        context,
                      )?.days_selected(selectedDays.length) ??
                      '${selectedDays.length} days selected'),
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                AppLocalizations.of(context)?.journal_cancel ?? 'Cancel',
              ),
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
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context)?.create ?? 'Create',
                        ),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppLocalizations.of(context)?.habit_name_hint ??
                            'Please enter a habit name',
                      ),
                    ),
                  );
                }
              },
              child: Text(AppLocalizations.of(context)?.create ?? 'Create'),
            ),
          ],
        ),
      ),
    );
  }
}
