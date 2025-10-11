class ApiConstants {
  static const String huggingFaceBaseUrl = 'https://api-inference.huggingface.co/models';
  static const String sentimentModel = 'distilbert-base-uncased-finetuned-sst-2-english';
  static const String emotionModel = 'j-hartmann/emotion-english-distilroberta-base';
  static const String zenQuotesApi = 'https://zenquotes.io/api/random';
  static const String deezerBaseUrl = 'https://api.deezer.com';
  
  static const List<String> corsProxies = [
    'https://api.allorigins.win/raw?url=',
    'https://corsproxy.io/?',
  ];
} 