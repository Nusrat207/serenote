import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serenote/features/mood/presentation/providers/mood_provider.dart';
import 'package:serenote/l10n/app_localizations.dart';

class TimerThemeSheet extends ConsumerStatefulWidget {
  final String currentTheme;
  final Function(String) onThemeChanged;

  const TimerThemeSheet({
    super.key,
    required this.currentTheme,
    required this.onThemeChanged,
  });

  @override
  ConsumerState<TimerThemeSheet> createState() => _TimerThemeSheetState();
}

class _TimerThemeSheetState extends ConsumerState<TimerThemeSheet> {
  late String _selectedTheme;
  final TextEditingController _customThemeController = TextEditingController();

  //final List<String> _defaultThemes = [
  //  'Focus',
  //  'Read',
  //  'Study',
  //  'Workout',
  //  'Work',
  //  'Meditate',
  //  'Relax',
  //];

  final List<String> _customThemes = [];

  @override
  void initState() {
    super.initState();
    _selectedTheme = widget.currentTheme;
  }

  @override
  void dispose() {
    _customThemeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    final moodColor = ref.watch(moodColorProvider).maybeWhen(
          data: (c) => c,
          orElse: () => const Color(0xFF477D9E),
        );

    final double maxSheetHeight = MediaQuery.of(context).size.height * 0.9;

    return Container(
      constraints: BoxConstraints(maxHeight: maxSheetHeight),
      padding: const EdgeInsets.only(top: 20),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Image.asset(
                'assets/images/timeer.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Foreground content
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      loc.customGoalsTitle,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.black87),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Scrollable Content
              Flexible(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height * 0.5,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              loc.goalCount(_customThemes.length.toString()),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Default Goals
                            Text(
                              loc.defaultGoals,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: _defaultThemes
                                  .map((theme) => _buildThemeChip(theme))
                                  .toList(),
                            ),

                            const SizedBox(height: 20),

                            // Custom Goals Section
                            if (_customThemes.isNotEmpty) ...[
                              Text(
                                loc.customGoals,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                children: _customThemes
                                    .map((theme) => _buildThemeChip(theme))
                                    .toList(),
                              ),
                              const SizedBox(height: 20),
                            ],

                            // Custom Goal Input
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white.withOpacity(0.8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    loc.createCustomGoals,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  TextField(
                                    controller: _customThemeController,
                                    decoration: InputDecoration(
                                      hintText: loc.enterGoalHint,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      fillColor: Colors.white,
                                      filled: true,
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: _addCustomTheme,
                                      ),
                                    ),
                                    onSubmitted: (value) => _addCustomTheme(),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Apply Button
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onThemeChanged(_selectedTheme);
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: moodColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(loc.applyGoals),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThemeChip(String theme) {
    final moodColor = ref.watch(moodColorProvider).maybeWhen(
          data: (c) => c,
          orElse: () => const Color(0xFF477D9E),
        );

    final bool isSelected = _selectedTheme == theme;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTheme = theme;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? moodColor
              : Colors.grey.shade100.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? moodColor
                : Colors.grey.shade300.withOpacity(0.7),
          ),
        ),
        child: Text(
          theme,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
  List<String> get _defaultThemes {
  final loc = AppLocalizations.of(context)!;
  return [
    loc.focus,
    loc.read,
    loc.study,
    loc.workout,
    loc.work,
    loc.meditate,
    loc.relax,
  ];
}


  void _addCustomTheme() {
    
    final themeName = _customThemeController.text.trim();
    if (themeName.isNotEmpty &&
        _customThemes.length < 50 &&
        !_defaultThemes.contains(themeName) &&
        !_customThemes.contains(themeName)) {
      setState(() {
        _customThemes.add(themeName);
        _selectedTheme = themeName;
        _customThemeController.clear();
      });
    }
  }
}
