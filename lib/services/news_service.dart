import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/article.dart';

class NewsService {
  // Get your FREE API key from https://newsapi.org (takes 1 minute)
  static const String _apiKey = 'c0933d6ddb7c4fac83fac69e6652a9cf';
  static const String _baseUrl = 'https://newsapi.org/v2';
  static const List<String> categories = [
    'Technology',
    'AI',
    'Crypto',
    'Science',
    'Gaming',
  ];

  Future<List<Article>> fetchTechNews() {
    return fetchArticles(category: 'Technology');
  }

  Future<List<Article>> fetchArticles({
    String category = 'Technology',
    String query = '',
  }) async {
    final cleanQuery = query.trim();
    final cacheKey = _cacheKey(category, cleanQuery);
    final url = _buildUrl(category: category, query: cleanQuery);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List articles = data['articles'] ?? [];

        final parsedArticles = articles
            .where((a) => a['title'] != '[Removed]' && a['title'] != null)
            .where((a) => (a['url'] ?? '').toString().isNotEmpty)
            .map((a) => Article.fromJson(a))
            .toList();

        await _saveCachedArticles(cacheKey, parsedArticles);
        return parsedArticles;
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      final cachedArticles = await _loadCachedArticles(cacheKey);
      if (cachedArticles.isNotEmpty) return cachedArticles;
      throw Exception('Network error: $e');
    }
  }

  Uri _buildUrl({required String category, required String query}) {
    if (query.isEmpty && _usesTopHeadlines(category)) {
      return Uri.parse('$_baseUrl/top-headlines').replace(queryParameters: {
        'category': category.toLowerCase(),
        'language': 'en',
        'pageSize': '30',
        'apiKey': _apiKey,
      });
    }

    final topic = _topicForCategory(category);
    final searchTerm = query.isEmpty ? topic : '$query $topic';

    return Uri.parse('$_baseUrl/everything').replace(queryParameters: {
      'q': searchTerm,
      'language': 'en',
      'sortBy': 'publishedAt',
      'pageSize': '30',
      'apiKey': _apiKey,
    });
  }

  bool _usesTopHeadlines(String category) {
    return category == 'Technology' || category == 'Science';
  }

  String _topicForCategory(String category) {
    switch (category) {
      case 'AI':
        return 'artificial intelligence';
      case 'Crypto':
        return 'cryptocurrency';
      case 'Science':
        return 'science';
      case 'Gaming':
        return 'gaming';
      case 'Technology':
      default:
        return 'technology';
    }
  }

  String _cacheKey(String category, String query) {
    final raw = '${category}_$query'.toLowerCase();
    final safe = raw.replaceAll(RegExp(r'[^a-z0-9]+'), '_');
    return 'devpulse_cached_articles_$safe';
  }

  Future<void> _saveCachedArticles(
    String cacheKey,
    List<Article> articles,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded =
        jsonEncode(articles.map((article) => article.toMap()).toList());
    await prefs.setString(cacheKey, encoded);
  }

  Future<List<Article>> _loadCachedArticles(String cacheKey) async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(cacheKey);
    if (cached == null) return [];

    final decoded = jsonDecode(cached) as List<dynamic>;
    return decoded
        .map((item) => Article.fromMap(item as Map<String, dynamic>))
        .toList();
  }
}
