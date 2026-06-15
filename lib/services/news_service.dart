import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class NewsService {
  // Get your FREE API key from https://newsapi.org (takes 1 minute)
  static const String _apiKey = 'c0933d6ddb7c4fac83fac69e6652a9cf';
  static const String _baseUrl = 'https://newsapi.org/v2';

  Future<List<Article>> fetchTechNews() async {
    final url = Uri.parse(
      '$_baseUrl/top-headlines?category=technology&language=en&pageSize=30&apiKey=$_apiKey',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List articles = data['articles'];

        // Filter out articles with no title or removed articles
        return articles
            .where((a) => a['title'] != '[Removed]' && a['title'] != null)
            .map((a) => Article.fromJson(a))
            .toList();
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}