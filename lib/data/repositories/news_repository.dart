import 'dart:io';

import '../../core/errors/app_exception.dart';
import '../../models/article.dart';
import '../../services/news_service.dart';

class NewsRepository {
  NewsRepository(this._newsService);

  final NewsService _newsService;

  static const List<String> categories = NewsService.categories;

  Future<List<Article>> fetchTechNews() {
    return fetchArticles(category: 'Technology');
  }

  Future<List<Article>> fetchArticles({
    String category = 'Technology',
    String query = '',
  }) async {
    try {
      return await _newsService.fetchArticles(
        category: category,
        query: query,
      );
    } on AppException {
      rethrow;
    } on SocketException catch (e) {
      throw NetworkException(
        'No internet connection. Check your network and try again.',
        debugMessage: e.toString(),
      );
    } catch (e) {
      throw NetworkException(
        'Unable to load news. Please try again.',
        debugMessage: e.toString(),
      );
    }
  }
}
