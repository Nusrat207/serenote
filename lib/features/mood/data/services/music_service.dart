/*
import 'dart:convert';
import 'package:http/http.dart' as http;

class MusicService {
  static const String corsProxy = 'https://corsproxy.io/?';
  static const String baseUrl = 'https://api.deezer.com';

  // Search tracks by mood
  Future<List<Map<String, dynamic>>> searchTracksByMood(String mood) async {
    final moodQueryMap = {
      'joy': 'happy upbeat',
      'happy': 'feel good',
      'sad': 'calm acoustic',
      'stressed': 'relaxing peaceful',
      'anxious': 'calming meditation',
      'calm': 'ambient chill',
      'angry': 'calm meditation',
      'neutral': 'chill lofi',
    };

    final query = moodQueryMap[mood.toLowerCase()] ?? 'chill';
    return await searchTracks(query);
  }

  // Search tracks
  Future<List<Map<String, dynamic>>> searchTracks(String query) async {
    try {
      final url = '$corsProxy${Uri.encodeComponent('$baseUrl/search?q=$query&limit=10')}';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final tracks = data['data'] as List;

        return tracks.map((track) {
          return {
            'id': track['id'],
            'title': track['title'],
            'artist': track['artist']['name'],
            'album': track['album']['title'],
            'cover': track['album']['cover_medium'],
            'preview': track['preview'],
            'duration': track['duration'],
          };
        }).toList();
      }
      return _getFallbackTracks();
    } catch (e) {
      print('Error searching tracks: $e');
      return _getFallbackTracks();
    }
  }

  // Get track details
  Future<Map<String, dynamic>?> getTrack(int trackId) async {
    try {
      final url = '$corsProxy${Uri.encodeComponent('$baseUrl/track/$trackId')}';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final track = jsonDecode(response.body);
        return {
          'id': track['id'],
          'title': track['title'],
          'artist': track['artist']['name'],
          'album': track['album']['title'],
          'cover': track['album']['cover_medium'],
          'preview': track['preview'],
          'duration': track['duration'],
        };
      }
      return null;
    } catch (e) {
      print('Error fetching track: $e');
      return null;
    }
  }

  // Fallback tracks when API fails
  List<Map<String, dynamic>> _getFallbackTracks() {
    return [
      {
        'id': 1,
        'title': 'Calm Waves',
        'artist': 'Relaxation Sounds',
        'album': 'Nature Sounds',
        'cover': 'https://via.placeholder.com/250?text=Calm+Music',
        'preview': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
        'duration': 30,
      },
      {
        'id': 2,
        'title': 'Peaceful Mind',
        'artist': 'Meditation Masters',
        'album': 'Inner Peace',
        'cover': 'https://via.placeholder.com/250?text=Peaceful',
        'preview': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
        'duration': 30,
      },
    ];
  }
} */ 
import 'dart:convert';
import 'package:http/http.dart' as http;

class MusicService {
  static const List<String> corsProxies = [
    'https://api.allorigins.win/raw?url=',
    'https://corsproxy.io/?',
  ];
  
  static const String baseUrl = 'https://api.deezer.com';

  // Search tracks by mood
 // Update the searchTracksByMood method with better search terms
Future<List<Map<String, dynamic>>> searchTracksByMood(String mood) async {
  final moodQueryMap = {
    'joy': 'happy dance pop 2024',           // Energetic, upbeat
    'happy': 'feel good indie pop',           // Positive vibes
    'sad': 'acoustic sad emotional',          // Melancholic
    'stressed': 'ambient relaxation spa',     // Stress relief
    'anxious': 'meditation calm sleep',       // Anxiety relief
    'calm': 'lofi chill peaceful',           // Calming
    'angry': 'classical peaceful zen',        // Anger management
    'neutral': 'instrumental focus study',    // Neutral background
  };

  final query = moodQueryMap[mood.toLowerCase()] ?? 'chill lofi';
  return await searchTracks(query);
}

  // Search tracks
  Future<List<Map<String, dynamic>>> searchTracks(String query) async {
    // Try API with different proxies
    for (var proxy in corsProxies) {
      try {
        final url = '$proxy${Uri.encodeComponent('$baseUrl/search?q=$query&limit=10')}';
        final response = await http.get(Uri.parse(url)).timeout(
          const Duration(seconds: 5),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          
          if (data['data'] != null) {
            final tracks = data['data'] as List;

            if (tracks.isNotEmpty) {
              return tracks.map((track) {
                return {
                  'id': track['id'],
                  'title': track['title'],
                  'artist': track['artist']['name'],
                  'album': track['album']['title'],
                  'cover': track['album']['cover_medium'],
                  'preview': track['preview'],
                  'duration': track['duration'],
                };
              }).toList();
            }
          }
        }
      } catch (e) {
        print('Error with proxy $proxy: $e');
        continue;
      }
    }
    
    // Return fallback tracks if API fails
    return _getFallbackTracksForQuery(query);
  }

  // Fallback tracks based on query
  List<Map<String, dynamic>> _getFallbackTracksForQuery(String query) {
    final queryLower = query.toLowerCase();
    
    if (queryLower.contains('happy') || queryLower.contains('cheerful')) {
      return _getHappyTracks();
    } else if (queryLower.contains('calm') || queryLower.contains('peaceful')) {
      return _getCalmTracks();
    } else if (queryLower.contains('sad') || queryLower.contains('acoustic')) {
      return _getSadTracks();
    }
    
    return _getCalmTracks(); // Default
  }

  List<Map<String, dynamic>> _getHappyTracks() {
    return [
      {
        'id': 1,
        'title': 'Sunny Days',
        'artist': 'Happy Vibes',
        'album': 'Positive Energy',
        'cover': 'https://via.placeholder.com/250/FFD93D/FFFFFF?text=Happy',
        'preview': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
        'duration': 30,
      },
      {
        'id': 2,
        'title': 'Joyful Moments',
        'artist': 'Uplifting Sounds',
        'album': 'Feel Good Collection',
        'cover': 'https://via.placeholder.com/250/FFB84D/FFFFFF?text=Joy',
        'preview': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
        'duration': 30,
      },
      {
        'id': 3,
        'title': 'Bright Side',
        'artist': 'Positive Beats',
        'album': 'Optimism',
        'cover': 'https://via.placeholder.com/250/FFEB3B/FFFFFF?text=Bright',
        'preview': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
        'duration': 30,
      },
    ];
  }

  List<Map<String, dynamic>> _getCalmTracks() {
    return [
      {
        'id': 10,
        'title': 'Peaceful Mind',
        'artist': 'Calm Sounds',
        'album': 'Tranquility',
        'cover': 'https://via.placeholder.com/250/84D7E8/FFFFFF?text=Peace',
        'preview': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
        'duration': 30,
      },
      {
        'id': 11,
        'title': 'Gentle Waves',
        'artist': 'Nature Sounds',
        'album': 'Serenity',
        'cover': 'https://via.placeholder.com/250/95D5B2/FFFFFF?text=Calm',
        'preview': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
        'duration': 30,
      },
      {
        'id': 12,
        'title': 'Meditation Flow',
        'artist': 'Zen Masters',
        'album': 'Inner Peace',
        'cover': 'https://via.placeholder.com/250/B4E7CE/FFFFFF?text=Zen',
        'preview': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3',
        'duration': 30,
      },
    ];
  }

  List<Map<String, dynamic>> _getSadTracks() {
    return [
      {
        'id': 20,
        'title': 'Reflection',
        'artist': 'Acoustic Soul',
        'album': 'Quiet Moments',
        'cover': 'https://via.placeholder.com/250/74C0FC/FFFFFF?text=Reflect',
        'preview': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-7.mp3',
        'duration': 30,
      },
      {
        'id': 21,
        'title': 'Gentle Rain',
        'artist': 'Ambient Sounds',
        'album': 'Melancholy',
        'cover': 'https://via.placeholder.com/250/91A7FF/FFFFFF?text=Rain',
        'preview': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3',
        'duration': 30,
      },
    ];
  }
}