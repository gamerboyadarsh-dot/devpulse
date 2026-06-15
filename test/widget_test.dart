import 'package:devpulse/models/article.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Article estimates at least one minute of reading time', () {
    final article = Article(
      title: 'A short developer update',
      description: 'Small but useful.',
      url: 'https://example.com',
      imageUrl: '',
      source: 'Example',
      publishedAt: '2026-06-15T12:00:00Z',
    );

    expect(article.readingTimeMinutes, 1);
    expect(article.displayDate, '2026-06-15');
  });
}
