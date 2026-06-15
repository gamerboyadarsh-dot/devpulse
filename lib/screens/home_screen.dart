import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../services/news_service.dart';
import '../services/auth_service.dart';
import '../models/article.dart';
import '../widgets/article_card.dart';
import 'article_detail_screen.dart';
import 'bookmarks_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _newsService = NewsService();
  final _authService = AuthService();
  List<Article> _articles = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  Future<void> _loadNews() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final articles = await _newsService.fetchTechNews();
      setState(() { _articles = articles; _isLoading = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _isLoading = false; });
    }
  }

  Future<void> _signOut() async {
    await _authService.signOut();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        elevation: 0,
        title: Text('DevPulse',
            style: GoogleFonts.jetBrainsMono(
              color: const Color(0xFF58A6FF),
              fontWeight: FontWeight.bold,
            )),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_outline, color: Colors.white70),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const BookmarksScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white70),
            onPressed: _signOut,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: SpinKitFadingCube(color: Color(0xFF58A6FF), size: 40))
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.wifi_off, color: Colors.white38, size: 48),
                      const SizedBox(height: 12),
                      Text('Failed to load news',
                          style: TextStyle(color: Colors.white54)),
                      TextButton(
                          onPressed: _loadNews,
                          child: const Text('Retry',
                              style: TextStyle(color: Color(0xFF58A6FF)))),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadNews,
                  color: const Color(0xFF58A6FF),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _articles.length,
                    itemBuilder: (context, index) {
                      return ArticleCard(
                        article: _articles[index],
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ArticleDetailScreen(
                                article: _articles[index]),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}