import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SentimentService {
  // Using free HuggingFace inference API
  // Model: distilbert-base-uncased-finetuned-sst-2-english (sentiment analysis)
  static const String apiUrl =
      'https://api-inference.huggingface.co/models/distilbert-base-uncased-finetuned-sst-2-english';

   final String? apiToken = dotenv.env['HUGGINGFACE_API_TOKEN'];
     

  Future<Map<String, dynamic>> analyzeSentiment(String text) async {
    try {
      final headers = <String, String>{
        'Content-Type': 'application/json',
      };

      if ((apiToken?.isNotEmpty ?? false)) {
        headers['Authorization'] = 'Bearer ${apiToken!}';
      }

      final body = jsonEncode({'inputs': text});

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final List<dynamic> results = jsonDecode(response.body);
        
        if (results.isNotEmpty && results[0] is List) {
          final predictions = results[0] as List;
          
          // Find the prediction with highest score
          double maxScore = 0;
          String topLabel = 'NEUTRAL';
          
          for (var prediction in predictions) {
            final score = prediction['score'] as double;
            if (score > maxScore) {
              maxScore = score;
              topLabel = prediction['label'] as String;
            }
          }

          return {
            'label': topLabel,
            'confidence': maxScore,
            'success': true,
          };
        }
      } else if (response.statusCode == 503) {
        // Model is loading
        return {
          'label': 'NEUTRAL',
          'confidence': 0.5,
          'success': false,
          'error': 'Model is loading. Please try again in a moment.',
        };
      }

      return {
        'label': 'NEUTRAL',
        'confidence': 0.5,
        'success': false,
        'error': 'Failed to analyze sentiment',
      };
    } catch (e) {
      return {
        'label': 'NEUTRAL',
        'confidence': 0.5,
        'success': false,
        'error': e.toString(),
      };
    }
  }

  // Alternative: More emotion-specific model
  Future<Map<String, dynamic>> analyzeEmotions(String text) async {
    const emotionModelUrl =
        'https://api-inference.huggingface.co/models/j-hartmann/emotion-english-distilroberta-base';

    try {
      final headers = <String, String>{
        'Content-Type': 'application/json',
        if ((apiToken?.isNotEmpty ?? false)) 'Authorization': 'Bearer ${apiToken!}',
      };

      final body = jsonEncode({'inputs': text});

      final response = await http.post(
        Uri.parse(emotionModelUrl),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final List<dynamic> results = jsonDecode(response.body);
        
        if (results.isNotEmpty && results[0] is List) {
          final predictions = results[0] as List;
          
          double maxScore = 0;
          String topEmotion = 'neutral';
          
          for (var prediction in predictions) {
            final score = prediction['score'] as double;
            if (score > maxScore) {
              maxScore = score;
              topEmotion = prediction['label'] as String;
            }
          }

          return {
            'label': topEmotion,
            'confidence': maxScore,
            'success': true,
          };
        }
      }

      return {
        'label': 'neutral',
        'confidence': 0.5,
        'success': false,
        'error': 'Failed to analyze emotions',
      };
    } catch (e) {
      return {
        'label': 'neutral',
        'confidence': 0.5,
        'success': false,
        'error': e.toString(),
      };
    }
  }
}