import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/article.dart';
import '../providers/theme_provider.dart';
import '../services/news_service.dart';
import '../widgets/article_card.dart';
import '../widgets/shimmer_card.dart';
import 'article_detail_screen.dart';
import 'bookmarks_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _newsService = NewsService();
  final _searchController = TextEditingController();

  List<Article> _articles = [];
  bool _isLoading = true;
  String? _error;
  String _selectedCategory = NewsService.categories.first;
  int _selectedIndex = 0;
  int _bookmarksRefreshSeed = 0;
  int _profileRefreshSeed = 0;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
    _loadNews();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadNews() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final articles = await _newsService.fetchArticles(
        category: _selectedCategory,
        query: _searchController.text,
      );
      if (!mounted) return;
      setState(() {
        _articles = articles;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  List<Article> get _filteredArticles {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return _articles;

    return _articles.where((article) {
      return article.title.toLowerCase().contains(query) ||
          article.description.toLowerCase().contains(query) ||
          article.source.toLowerCase().contains(query);
    }).toList();
  }

  void _selectCategory(String category) {
    if (_selectedCategory == category) return;
    setState(() => _selectedCategory = category);
    _loadNews();
  }

  void _openArticle(Article article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ArticleDetailScreen(article: article),
      ),
    );
  }

  Future<void> _shareArticle(Article article) async {
    await Share.share('${article.title}\n${article.url}');
  }

  void _selectTab(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 1) _bookmarksRefreshSeed++;
      if (index == 2) _profileRefreshSeed++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final titles = ['DevPulse', 'Bookmarks', 'Profile'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          titles[_selectedIndex],
          style: GoogleFonts.jetBrainsMono(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return IconButton(
                tooltip: themeProvider.isDarkMode ? 'Light mode' : 'Dark mode',
                icon: Icon(
                  themeProvider.isDarkMode
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                ),
                onPressed: themeProvider.toggleTheme,
              );
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildFeed(),
          BookmarksScreen(
            key: ValueKey('bookmarks-$_bookmarksRefreshSeed'),
            showAppBar: false,
          ),
          ProfileScreen(key: ValueKey('profile-$_profileRefreshSeed')),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _selectTab,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_outline_rounded),
            activeIcon: Icon(Icons.bookmark_rounded),
            label: 'Bookmarks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildFeed() {
    if (_isLoading) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          _SearchBar(controller: _searchController, onSubmit: _loadNews),
          const SizedBox(height: 14),
          _CategoryBar(
            selectedCategory: _selectedCategory,
            onSelected: _selectCategory,
          ),
          const SizedBox(height: 16),
          const ShimmerCard(featured: true),
          const ShimmerCard(),
          const ShimmerCard(),
        ],
      );
    }

    if (_error != null) {
      return _ErrorState(onRetry: _loadNews);
    }

    final articles = _filteredArticles;

    return RefreshIndicator(
      onRefresh: _loadNews,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          _SearchBar(controller: _searchController, onSubmit: _loadNews),
          const SizedBox(height: 14),
          _CategoryBar(
            selectedCategory: _selectedCategory,
            onSelected: _selectCategory,
          ),
          const SizedBox(height: 16),
          if (articles.isEmpty)
            const _EmptyState()
          else ...[
            ArticleCard(
              article: articles.first,
              featured: true,
              onTap: () => _openArticle(articles.first),
              onShare: () => _shareArticle(articles.first),
            ),
            for (final article in articles.skip(1))
              ArticleCard(
                article: article,
                onTap: () => _openArticle(article),
                onShare: () => _shareArticle(article),
              ),
          ],
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmit;

  const _SearchBar({
    required this.controller,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      onSubmitted: (_) => onSubmit(),
      decoration: InputDecoration(
        hintText: 'Search developer news',
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
                tooltip: 'Clear search',
                icon: const Icon(Icons.close_rounded),
                onPressed: () {
                  controller.clear();
                  onSubmit();
                },
              ),
      ),
    );
  }
}

class _CategoryBar extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onSelected;

  const _CategoryBar({
    required this.selectedCategory,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: NewsService.categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = NewsService.categories[index];
          return ChoiceChip(
            label: Text(category),
            selected: selectedCategory == category,
            onSelected: (_) => onSelected(category),
          );
        },
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded, color: colorScheme.outline, size: 48),
            const SizedBox(height: 12),
            Text(
              'Failed to load news',
              style: GoogleFonts.inter(
                color: colorScheme.onSurface.withValues(alpha: 0.64),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            TextButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Column(
        children: [
          Icon(Icons.search_off_rounded, color: colorScheme.outline, size: 52),
          const SizedBox(height: 12),
          Text(
            'No articles found',
            style: GoogleFonts.inter(
              color: colorScheme.onSurface.withValues(alpha: 0.64),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
