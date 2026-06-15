import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/article.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';

class ArticleDetailScreen extends StatefulWidget {
  final Article article;
  const ArticleDetailScreen({super.key, required this.article});
  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  final _firestoreService = FirestoreService();
  final _authService = AuthService();
  bool _isBookmarked = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkBookmark();
  }

  Future<void> _checkBookmark() async {
    final userId = _authService.currentUser?.uid;
    if (userId == null) return;
    final result = await _firestoreService.isBookmarked(userId, widget.article.url);
    setState(() { _isBookmarked = result; _isLoading = false; });
  }

  Future<void> _toggleBookmark() async {
    final userId = _authService.currentUser?.uid;
    if (userId == null) return;
    if (_isBookmarked) {
      await _firestoreService.removeBookmark(userId, widget.article.url);
    } else {
      await _firestoreService.addBookmark(userId, widget.article);
    }
    setState(() => _isBookmarked = !_isBookmarked);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(_isBookmarked ? 'Bookmarked!' : 'Removed from bookmarks'),
      backgroundColor: const Color(0xFF161B22),
      duration: const Duration(seconds: 1),
    ));
  }

  Future<void> _openInBrowser() async {
    final uri = Uri.parse(widget.article.url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final article = widget.article;
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        iconTheme: const IconThemeData(color: Colors.white70),
        actions: [
          _isLoading
              ? const Padding(
                  padding: EdgeInsets.all(12),
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Color(0xFF58A6FF)))
              : IconButton(
                  icon: Icon(
                    _isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
                    color: const Color(0xFF58A6FF),
                  ),
                  onPressed: _toggleBookmark,
                ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Source + date
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF58A6FF).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(article.source,
                    style: const TextStyle(
                        color: Color(0xFF58A6FF), fontSize: 12)),
              ),
              const SizedBox(width: 8),
              Text(article.publishedAt.substring(0, 10),
                  style: const TextStyle(color: Colors.white38, fontSize: 12)),
            ]),
            const SizedBox(height: 16),
            // Title
            Text(article.title,
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.4,
                )),
            const SizedBox(height: 20),
            // Image
            if (article.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: article.imageUrl,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                      height: 200, color: const Color(0xFF161B22)),
                  errorWidget: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            const SizedBox(height: 20),
            // Description
            Text(article.description,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: Colors.white70,
                  height: 1.7,
                )),
            const SizedBox(height: 32),
            // Read full article button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _openInBrowser,
                icon: const Icon(Icons.open_in_new, color: Colors.white),
                label: Text('Read Full Article',
                    style: GoogleFonts.inter(
                        color: Colors.white, fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF238636),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}