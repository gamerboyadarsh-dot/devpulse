import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/article.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Each user gets their own bookmarks collection
  CollectionReference _bookmarksRef(String userId) {
    return _db.collection('users').doc(userId).collection('bookmarks');
  }

  // Save an article as bookmark
  Future<void> addBookmark(String userId, Article article) async {
    // Use the article URL as document ID (unique per article)
    final docId = Uri.encodeComponent(article.url);
    await _bookmarksRef(userId).doc(docId).set(article.toMap());
  }

  // Remove a bookmark
  Future<void> removeBookmark(String userId, String articleUrl) async {
    final docId = Uri.encodeComponent(articleUrl);
    await _bookmarksRef(userId).doc(docId).delete();
  }

  // Check if an article is already bookmarked
  Future<bool> isBookmarked(String userId, String articleUrl) async {
    final docId = Uri.encodeComponent(articleUrl);
    final doc = await _bookmarksRef(userId).doc(docId).get();
    return doc.exists;
  }

  // Get all bookmarks for a user
  Future<List<Article>> getBookmarks(String userId) async {
    final snapshot = await _bookmarksRef(userId).get();
    return snapshot.docs
        .map((doc) => Article.fromFirestore(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
