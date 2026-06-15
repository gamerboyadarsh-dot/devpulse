import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/article.dart';

class NewsService {
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
        final List articles = jsonDecode(response.body) as List;

        final parsedArticles = articles
            .where((a) => a['title'] != null)
            .where((a) => (a['url'] ?? '').toString().isNotEmpty)
            .map((a) => Article.fromJson(a))
            .toList();

        await _saveCachedArticles(cacheKey, parsedArticles);
        return parsedArticles;
      } else {
        return await _loadCachedArticles(cacheKey);
      }
    } catch (e) {
      final cachedArticles = await _loadCachedArticles(cacheKey);
      if (cachedArticles.isNotEmpty) return cachedArticles;
      throw Exception('Network error: $e');
    }
  }

  Uri _buildUrl({required String category, required String query}) {
    if (query.isNotEmpty) {
      return Uri.parse(
        'https://dev.to/api/articles?tag=$query&per_page=30',
      );
    }
    final tag = _devToTagFor(category);
    return Uri.parse(
      'https://dev.to/api/articles?tag=$tag&per_page=30',
    );
  }

  String _devToTagFor(String category) {
    switch (category) {
      case 'AI': return 'ai';
      case 'Crypto': return 'blockchain';
      case 'Science': return 'science';
      case 'Gaming': return 'gaming';
      case 'Technology':
      default: return 'technology';
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