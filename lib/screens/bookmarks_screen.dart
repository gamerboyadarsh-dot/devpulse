import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../models/article.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';
import '../widgets/article_card.dart';
import 'article_detail_screen.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});
  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  final _firestoreService = FirestoreService();
  final _authService = AuthService();
  List<Article> _bookmarks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    final userId = _authService.currentUser?.uid;
    if (userId == null) return;
    final bookmarks = await _firestoreService.getBookmarks(userId);
    setState(() { _bookmarks = bookmarks; _isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        iconTheme: const IconThemeData(color: Colors.white70),
        title: Text('Bookmarks',
            style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      body: _isLoading
          ? const Center(
              child: SpinKitFadingCube(color: Color(0xFF58A6FF), size: 40))
          : _bookmarks.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.bookmark_outline,
                          color: Colors.white24, size: 64),
                      const SizedBox(height: 16),
                      Text('No bookmarks yet',
                          style: GoogleFonts.inter(
                              color: Colors.white38, fontSize: 16)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _bookmarks.length,
                  itemBuilder: (context, index) {
                    return ArticleCard(
                      article: _bookmarks[index],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ArticleDetailScreen(
                              article: _bookmarks[index]),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}