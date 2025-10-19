import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../providers/mood_provider.dart';
import 'mood_screen.dart';
import 'package:serenote/l10n/app_localizations.dart';

class QuickMoodEntryScreen extends ConsumerStatefulWidget {
  const QuickMoodEntryScreen({super.key});

  @override
  ConsumerState<QuickMoodEntryScreen> createState() =>
      _QuickMoodEntryScreenState();
}

class _QuickMoodEntryScreenState extends ConsumerState<QuickMoodEntryScreen> {
  String? _selectedMood;
  bool _isSaving = false;

  final List<Map<String, dynamic>> _moods = [
    {
      'name': 'joy',
      'label': 'happy', // Use localization key
      'icon': 'assets/images/happy.png',
      'color': Color.fromARGB(255, 178, 140, 3),
    },
    {
      'name': 'neutral',
      'label': 'neutral', // Use localization key
      'icon': 'assets/images/neutral.png',
      'color': Color.fromARGB(255, 36, 169, 101),
    },
    {
      'name': 'sad',
      'label': 'sad', // Use localization key
      'icon': 'assets/images/sadd.png',
      'color': Color.fromARGB(255, 6, 115, 204),
    },
    {
      'name': 'anxious',
      'label': 'anxious', // Use localization key
      'icon': 'assets/images/anxious.png',
      'color': Color.fromARGB(255, 116, 27, 179),
    },
    {
      'name': 'angry',
      'label': 'angry', // Use localization key
      'icon': 'assets/images/angry.png',
      'color': Color.fromARGB(255, 204, 6, 6),
    },
  ];

  Future<void> _saveMood() async {
    if (_selectedMood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.please_select_mood),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw Exception(AppLocalizations.of(context)!.user_not_logged_in);
      }

      await Supabase.instance.client.from('moods').insert({
        'text': null,
        'detected_mood': _selectedMood,
        'confidence': null,
        'timestamp': DateTime.now().toIso8601String(),
        'is_voice_input': null,
        'user_id': user.id,
      });

      // Refresh mood entries
      await ref.read(moodEntriesProvider.notifier).refreshEntries();
      ref.refresh(todaysMoodProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.mood_saved_successfully,
            ),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppLocalizations.of(context)!.error_saving_mood}$e',
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final moodColor = ref
        .watch(moodColorProvider)
        .maybeWhen(
          data: (c) => c,
          orElse: () => const Color(0xFF477D9E), // fallback
        );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                loc.how_are_you_feeling,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                loc.select_your_mood,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Mood Selection Grid
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _moods.length,
                  itemBuilder: (context, index) {
                    final mood = _moods[index];
                    final isSelected = _selectedMood == mood['name'];

                    // Get localized label
                    final localizedLabel = _getLocalizedMoodLabel(
                      mood['label'],
                      loc,
                    );

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedMood = mood['name'];
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? mood['color'].withOpacity(0.1)
                              : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? mood['color']
                                : Colors.grey.shade200,
                            width: isSelected ? 3 : 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(mood['icon'], width: 60, height: 60),
                            const SizedBox(height: 12),
                            Text(
                              localizedLabel,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: isSelected
                                    ? mood['color']
                                    : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Save Button
              ElevatedButton(
                onPressed: _isSaving ? null : _saveMood,
                style: ElevatedButton.styleFrom(
                  backgroundColor: moodColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Text(
                        loc.save_mood,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),

              const SizedBox(height: 16),

              // Divider with OR
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'OR',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                ],
              ),

              const SizedBox(height: 16),

              // Text/Voice Entry Option
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MoodScreen()),
                  );
                },
                icon: const Icon(Icons.edit_outlined),
                label: Text(loc.say_or_type_feeling),
                style: OutlinedButton.styleFrom(
                  foregroundColor: moodColor,
                  side: BorderSide(color: moodColor, width: 2),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  String _getLocalizedMoodLabel(String moodKey, AppLocalizations loc) {
    switch (moodKey) {
      case 'happy':
        return loc.happy;
      case 'neutral':
        return loc.neutral;
      case 'sad':
        return loc.sad;
      case 'anxious':
        return loc.anxious;
      case 'angry':
        return loc.angry;
      default:
        return moodKey;
    }
  }
}
