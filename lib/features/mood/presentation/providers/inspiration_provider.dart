import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serenote/features/mood/data/services/quotes_service.dart';
import 'package:serenote/features/mood/data/services/music_service.dart';

final quotesServiceProvider = Provider((ref) => QuotesService());
final musicServiceProvider = Provider((ref) => MusicService());

// Quote state - stores the current quote
final currentQuoteProvider = StateProvider<Map<String, dynamic>?>((ref) => null);

// Music recommendations state
final musicRecommendationsProvider = StateProvider<List<Map<String, dynamic>>>((ref) => []);

// Fetch quote for mood - ALWAYS returns a quote (API or fallback)
final fetchQuoteForMoodProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, mood) async {
  final quotesService = ref.read(quotesServiceProvider);
  
  try {
    final quote = await quotesService.getQuoteForMood(mood);
    
    // Cache it in state
    Future.microtask(() {
      ref.read(currentQuoteProvider.notifier).state = quote;
    });
    
    return quote;
  } catch (e) {
    print('Error in fetchQuoteForMoodProvider: $e');
    // This should never happen as getQuoteForMood always returns fallback
    return {
      'content': 'Take a moment to breathe and reflect on your feelings.',
      'author': 'SereNote Wisdom',
      'tags': ['wisdom']
    };
  }
});

// Fetch music for mood - ALWAYS returns tracks (API or fallback)
final fetchMusicForMoodProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, mood) async {
  final musicService = ref.read(musicServiceProvider);
  
  try {
    final tracks = await musicService.searchTracksByMood(mood);
    
    // Cache it in state
    Future.microtask(() {
      ref.read(musicRecommendationsProvider.notifier).state = tracks;
    });
    
    return tracks;
  } catch (e) {
    print('Error in fetchMusicForMoodProvider: $e');
    // Return calm tracks as ultimate fallback
    return [
      {
        'id': 999,
        'title': 'Peaceful Moment',
        'artist': 'Calm Collection',
        'album': 'Relaxation',
        'cover': 'https://via.placeholder.com/250/95D5B2/FFFFFF?text=Music',
        'preview': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
        'duration': 30,
      },
    ];
  }
});