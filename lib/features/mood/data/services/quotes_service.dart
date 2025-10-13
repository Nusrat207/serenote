import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';

class QuotesService {
  // Use ZenQuotes API (no auth required, works fine on Android)
  static const String quotesApi = 'https://zenquotes.io/api/random';

  // Get random quote
  Future<Map<String, dynamic>> getRandomQuote() async {
    try {
      final response = await http.get(Uri.parse(quotesApi)).timeout(
        const Duration(seconds: 5),
      );
 
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          return {
            'content': data[0]['q'],
            'author': data[0]['a'],
            'tags': ['inspirational'],
          };
        }
      }
    } catch (e) {
      print('ZenQuotes error: $e');
    }

    // fallback if API fails
    return _getFallbackQuote();
  }

  // Get quote by mood (currently uses random API quote)
  Future<Map<String, dynamic>> getQuoteForMood(String mood) async {
    // Could later be extended to return mood-based quotes
    return await getRandomQuote();
  }

  // Expanded fallback quotes (categorized by mood)
  Map<String, dynamic> _getFallbackQuote() {
    final allQuotes = _getAllQuotes();
    final random = Random();
    return allQuotes[random.nextInt(allQuotes.length)];
  }

  // Get mood-specific fallback quote
  Map<String, dynamic> getFallbackQuoteForMood(String mood) {
    final allQuotes = _getAllQuotes();
    final moodQuotes = allQuotes.where((q) => q['mood'] == mood.toLowerCase()).toList();

    if (moodQuotes.isEmpty) {
      return _getFallbackQuote();
    }

    final random = Random();
    return moodQuotes[random.nextInt(moodQuotes.length)];
  }

  // Local list of quotes
  List<Map<String, dynamic>> _getAllQuotes() {
    return [
      // Joy/Happy
      {'content': 'Happiness is not something ready made. It comes from your own actions.', 'author': 'Dalai Lama', 'tags': ['happiness'], 'mood': 'joy'},
      {'content': 'The most wasted of days is one without laughter.', 'author': 'E.E. Cummings', 'tags': ['happiness'], 'mood': 'happy'},
      {'content': 'Joy is not in things; it is in us.', 'author': 'Richard Wagner', 'tags': ['happiness'], 'mood': 'joy'},

      // Calm/Peaceful
      {'content': 'Peace comes from within. Do not seek it without.', 'author': 'Buddha', 'tags': ['peace'], 'mood': 'calm'},
      {'content': 'The quieter you become, the more you can hear.', 'author': 'Ram Dass', 'tags': ['peace'], 'mood': 'calm'},
      {'content': 'Calm mind brings inner strength and self-confidence.', 'author': 'Dalai Lama', 'tags': ['peace'], 'mood': 'calm'},

      // Sad/Reflective
      {'content': 'Every experience, no matter how bad it seems, holds within it a blessing of some kind.', 'author': 'Buddha', 'tags': ['wisdom'], 'mood': 'sad'},
      {'content': 'The wound is the place where the light enters you.', 'author': 'Rumi', 'tags': ['wisdom'], 'mood': 'sad'},
      {'content': 'Tears are words that need to be written.', 'author': 'Paulo Coelho', 'tags': ['wisdom'], 'mood': 'sad'},

      // Stressed/Anxious
      {'content': 'You must learn to let go. Release the stress. You were never in control anyway.', 'author': 'Steve Maraboli', 'tags': ['wisdom'], 'mood': 'stressed'},
      {'content': 'Worrying is like sitting in a rocking chair. It gives you something to do but it doesn\'t get you anywhere.', 'author': 'Van Wilder', 'tags': ['wisdom'], 'mood': 'anxious'},
      {'content': 'Almost everything will work again if you unplug it for a few minutes, including you.', 'author': 'Anne Lamott', 'tags': ['wisdom'], 'mood': 'stressed'},

      // Angry
      {'content': 'For every minute you remain angry, you give up sixty seconds of peace of mind.', 'author': 'Ralph Waldo Emerson', 'tags': ['wisdom'], 'mood': 'angry'},
      {'content': 'Holding onto anger is like drinking poison and expecting the other person to die.', 'author': 'Buddha', 'tags': ['wisdom'], 'mood': 'angry'},

      // Neutral/General
      {'content': 'Be yourself; everyone else is already taken.', 'author': 'Oscar Wilde', 'tags': ['life'], 'mood': 'neutral'},
      {'content': 'Life is 10% what happens to you and 90% how you react to it.', 'author': 'Charles R. Swindoll', 'tags': ['life'], 'mood': 'neutral'},
      {'content': 'The only way to do great work is to love what you do.', 'author': 'Steve Jobs', 'tags': ['inspirational'], 'mood': 'neutral'},
      {'content': 'Believe you can and you\'re halfway there.', 'author': 'Theodore Roosevelt', 'tags': ['inspirational'], 'mood': 'neutral'},
    ];
  }
}
