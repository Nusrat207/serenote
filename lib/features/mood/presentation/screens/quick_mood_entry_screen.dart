import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../providers/mood_provider.dart';
import 'mood_screen.dart';

class QuickMoodEntryScreen extends ConsumerStatefulWidget {
  const QuickMoodEntryScreen({super.key});

  @override
  ConsumerState<QuickMoodEntryScreen> createState() => _QuickMoodEntryScreenState();
}

class _QuickMoodEntryScreenState extends ConsumerState<QuickMoodEntryScreen> {
  String? _selectedMood;
  bool _isSaving = false;

  final List<Map<String, dynamic>> _moods = [
    {
      'name': 'joy',
      'label': 'Happy',
      'icon': 'assets/images/happy.png',
      'color': Color.fromARGB(255, 178, 140, 3),
    },
    {
      'name': 'neutral',
      'label': 'Neutral',
      'icon': 'assets/images/neutral.png',
      'color': Color.fromARGB(255, 36, 169, 101),
    },
    {
      'name': 'sad',
      'label': 'Sad',
      'icon': 'assets/images/sadd.png',
      'color': Color.fromARGB(255, 6, 115, 204),
    },
    {
      'name': 'anxious',
      'label': 'Anxious',
      'icon': 'assets/images/anxious.png',
      'color': Color.fromARGB(255, 116, 27, 179),
    },
    {
      'name': 'angry',
      'label': 'Angry',
      'icon': 'assets/images/angry.png',
      'color': Color.fromARGB(255, 204, 6, 6),
    },
  ];

  Future<void> _saveMood() async {
    if (_selectedMood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a mood')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
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
          const SnackBar(content: Text('Mood saved successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving mood: $e')),
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
     final moodColor = ref.watch(moodColorProvider).maybeWhen(
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
              const Text(
                'How are you feeling?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Select your mood',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
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
                            Image.asset(
                              mood['icon'],
                              width: 60,
                              height: 60,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              mood['label'],
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
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Save Mood',
                        style: TextStyle(
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
                label: const Text('Say or type how you\'re feeling'),
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
}