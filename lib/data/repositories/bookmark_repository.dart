import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/errors/app_exception.dart';
import '../../models/article.dart';
import '../../services/firestore_service.dart';

class BookmarkRepository {
  BookmarkRepository(this._firestoreService);

  final FirestoreService _firestoreService;

  Future<void> addBookmark(String userId, Article article) async {
    try {
      await _firestoreService.addBookmark(userId, article);
    } on FirebaseException catch (e) {
      throw FirestoreException(
        'Unable to save bookmark. Please try again.',
        debugMessage: e.message,
      );
    } catch (e) {
      throw FirestoreException(
        'Unable to save bookmark. Please try again.',
        debugMessage: e.toString(),
      );
    }
  }

  Future<void> removeBookmark(String userId, String articleUrl) async {
    try {
      await _firestoreService.removeBookmark(userId, articleUrl);
    } on FirebaseException catch (e) {
      throw FirestoreException(
        'Unable to remove bookmark. Please try again.',
        debugMessage: e.message,
      );
    } catch (e) {
      throw FirestoreException(
        'Unable to remove bookmark. Please try again.',
        debugMessage: e.toString(),
      );
    }
  }

  Future<bool> isBookmarked(String userId, String articleUrl) async {
    try {
      return await _firestoreService.isBookmarked(userId, articleUrl);
    } on FirebaseException catch (e) {
      throw FirestoreException(
        'Unable to check bookmark status.',
        debugMessage: e.message,
      );
    } catch (e) {
      throw FirestoreException(
        'Unable to check bookmark status.',
        debugMessage: e.toString(),
      );
    }
  }

  Future<List<Article>> getBookmarks(String userId) async {
    try {
      return await _firestoreService.getBookmarks(userId);
    } on FirebaseException catch (e) {
      throw FirestoreException(
        'Unable to load bookmarks. Please try again.',
        debugMessage: e.message,
      );
    } catch (e) {
      throw FirestoreException(
        'Unable to load bookmarks. Please try again.',
        debugMessage: e.toString(),
      );
    }
  }
}
