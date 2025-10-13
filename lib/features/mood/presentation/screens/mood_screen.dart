import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:audioplayers/audioplayers.dart';
import 'package:serenote/features/mood/presentation/providers/mood_provider.dart';
import 'package:serenote/features/mood/presentation/providers/inspiration_provider.dart';
import 'package:serenote/core/theme/mood_colors.dart';
import 'package:serenote/features/mood/data/models/mood_entry.dart';


final todaysMoodProvider = FutureProvider<MoodEntry?>(
  (ref) => ref.read(moodEntriesProvider.notifier).getTodaysMood(),
);

class MoodScreen extends ConsumerStatefulWidget {
  const MoodScreen({super.key});

  @override
  ConsumerState<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends ConsumerState<MoodScreen> {
  final TextEditingController _textController = TextEditingController();
  final stt.SpeechToText _speech = stt.SpeechToText();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isListening = false;
  bool _isAnalyzing = false;
  String? _currentPlayingUrl;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {});
      _isPlaying = state == PlayerState.playing;
    });
  }

  Future<void> _initSpeech() async => await _speech.initialize();

  Future<void> _startListening() async {
    if (!_isListening) {
      final available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) {
            setState(() => _textController.text = result.recognizedWords);
          },
        );
      }
    }
  }

  Future<void> _stopListening() async {
    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
    }
  }

  Future<void> _analyzeMood() async {
    final text = _textController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter or speak how you feel')),
      );
      return;
    }

    setState(() => _isAnalyzing = true);

    final result = await ref
        .read(moodEntriesProvider.notifier)
        .analyzeMood(text, isVoiceInput: _isListening);

    setState(() => _isAnalyzing = false);

    if (result['success']) {
      _textController.clear();
      // Refresh todaysMood and recent moods after insertion
      ref.refresh(todaysMoodProvider);
      ref.read(moodEntriesProvider.notifier).refreshEntries();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Mood detected: ${result['entry'].detectedMood.toUpperCase()}'),
          backgroundColor:
              MoodColors.getColorForMood(result['entry'].detectedMood),
        ),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: ${result['error']}')));
    }
  }

  Future<void> _playPreview(String url) async {
    if (_audioPlayer.state == PlayerState.playing && _currentPlayingUrl == url) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(url));
      _currentPlayingUrl = url;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _speech.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recentMoods = ref.watch(moodEntriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('MoodMirror')),
      body: Consumer(
        builder: (context, ref, _) {
          final todaysMoodAsync = ref.watch(todaysMoodProvider);

          return todaysMoodAsync.when(
            data: (todaysMood) => Container(
              decoration: BoxDecoration(
                gradient: todaysMood != null
                    ? MoodColors.getGradientForMood(todaysMood.detectedMood)
                    : null,
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (todaysMood != null) _buildTodaysMoodCard(todaysMood),
                      const SizedBox(height: 20),
                      _buildInputSection(),
                      if (todaysMood != null) ...[
                        const SizedBox(height: 20),
                        _buildInspirationSection(todaysMood.detectedMood),
                      ],
                      const SizedBox(height: 20),
                      if (recentMoods.isNotEmpty)
                        _buildRecentMoods(recentMoods.take(5).toList()),
                    ],
                  ),
                ),
              ),
            ),
            loading: () =>
                const Center(child: CircularProgressIndicator(strokeWidth: 2)),
            error: (err, _) => Center(child: Text('Error: $err')),
          );
        },
      ),
    );
  }

  Widget _buildTodaysMoodCard(MoodEntry mood) {
    return Card(
      color: Colors.white.withOpacity(0.95),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Today\'s Mood',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Text(
              mood.detectedMood.toUpperCase(),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: MoodColors.getColorForMood(mood.detectedMood),
                  ),
            ),
            const SizedBox(height: 4),
            Text('${(mood.confidence * 100).toStringAsFixed(0)}% confidence'),
            const SizedBox(height: 12),
            if (mood.text.isNotEmpty)
              Text(
                '"${mood.text}"',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('How are you feeling?',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextField(
              controller: _textController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Type or speak how you feel...',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
                filled: true,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed:
                        _isAnalyzing ? null : (_isListening ? _stopListening : _startListening),
                    icon: Icon(_isListening ? Icons.stop : Icons.mic),
                    label: Text(_isListening ? 'Stop' : 'Voice Input'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: _isListening ? Colors.red.shade300 : null),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isAnalyzing ? null : _analyzeMood,
                    icon: _isAnalyzing
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.psychology),
                    label: Text(_isAnalyzing ? 'Analyzing...' : 'Analyze'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInspirationSection(String mood) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('For You',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 12),
        _buildQuoteSection(mood),
        const SizedBox(height: 12),
        _buildMusicSection(mood),
      ],
    );
  }

  Widget _buildRecentMoods(List<MoodEntry> moods) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Moods', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        ...moods.map(_buildMoodCard),
      ],
    );
  }

  Widget _buildMoodCard(MoodEntry entry) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: MoodColors.getColorForMood(entry.detectedMood),
          child: Text(
            entry.detectedMood[0].toUpperCase(),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(entry.detectedMood),
        subtitle: Text(entry.text, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${entry.timestamp.hour}:${entry.timestamp.minute.toString().padLeft(2, '0')}'),
            if (entry.isVoiceInput) const Icon(Icons.mic, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildQuoteSection(String mood) {
    final quoteAsync = ref.watch(fetchQuoteForMoodProvider(mood));

    return quoteAsync.when(
      data: (quote) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.format_quote,
                      color: MoodColors.getColorForMood(mood),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Inspirational Quote',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '"${quote['content']}"',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 8),
                Text(
                  '— ${quote['author']}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (_, __) => const SizedBox(),
    );
  }

  Widget _buildMusicSection(String mood) {
    final musicAsync = ref.watch(fetchMusicForMoodProvider(mood));

    return musicAsync.when(
      data: (tracks) {
        if (tracks.isEmpty) return const SizedBox();

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.music_note,
                      color: MoodColors.getColorForMood(mood),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Recommended Music',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: tracks.take(5).length,
                    itemBuilder: (context, index) {
                      final track = tracks[index];
                      final isCurrentlyPlaying =
                          _currentPlayingUrl == track['preview'] && _isPlaying;

                      return Container(
                        width: 100,
                        margin: const EdgeInsets.only(right: 12),
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    track['cover'],
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 80,
                                        height: 80,
                                        color: Colors.grey.shade300,
                                        child: const Icon(Icons.music_note),
                                      );
                                    },
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.3),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      isCurrentlyPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      color: Colors.white,
                                    ),
                                    onPressed: () =>
                                        _playPreview(track['preview']),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              track['title'],
                              style: Theme.of(context).textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              track['artist'],
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Colors.grey.shade600,
                                    fontSize: 10,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (_, __) => const SizedBox(),
    );
  }

}
