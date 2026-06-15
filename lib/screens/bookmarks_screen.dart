import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/article.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../widgets/article_card.dart';
import '../widgets/shimmer_card.dart';
import 'article_detail_screen.dart';

class BookmarksScreen extends StatefulWidget {
  final bool showAppBar;

  const BookmarksScreen({super.key, this.showAppBar = true});

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
    if (!mounted) return;
    setState(() {
      _bookmarks = bookmarks;
      _isLoading = false;
    });
  }

  void _openArticle(Article article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ArticleDetailScreen(article: article),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final body = _buildBody();

    if (!widget.showAppBar) return body;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bookmarks',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
      ),
      body: body,
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ShimmerCard(),
          ShimmerCard(),
          ShimmerCard(),
        ],
      );
    }

    if (_bookmarks.isEmpty) {
      return const _EmptyBookmarks();
    }

    return RefreshIndicator(
      onRefresh: _loadBookmarks,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _bookmarks.length,
        itemBuilder: (context, index) {
          final article = _bookmarks[index];
          return ArticleCard(
            article: article,
            onTap: () => _openArticle(article),
          );
        },
      ),
    );
  }
}

class _EmptyBookmarks extends StatelessWidget {
  const _EmptyBookmarks();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark_outline_rounded,
            color: colorScheme.outline,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'No bookmarks yet',
            style: GoogleFonts.inter(
              color: colorScheme.onSurface.withValues(alpha: 0.58),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
