class Article {
  final String title;
  final String description;
  final String url;
  final String imageUrl;
  final String source;
  final String publishedAt;

  Article({
    required this.title,
    required this.description,
    required this.url,
    required this.imageUrl,
    required this.source,
    required this.publishedAt,
  });

  // Converts raw JSON from the API into an Article object
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No description available.',
      url: json['url'] ?? '',
      imageUrl: json['urlToImage'] ?? '',
      source: json['source']?['name'] ?? 'Unknown',
      publishedAt: json['publishedAt'] ?? '',
    );
  }

  // Converts Article to a Map so Firestore can store it
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'url': url,
      'imageUrl': imageUrl,
      'source': source,
      'publishedAt': publishedAt,
    };
  }

  // Converts a Firestore document back into an Article object
  factory Article.fromFirestore(Map<String, dynamic> map) {
    return Article.fromMap(map);
  }

  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      url: map['url'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      source: map['source'] ?? '',
      publishedAt: map['publishedAt'] ?? '',
    );
  }

  int get readingTimeMinutes {
    final text = '$title $description'.trim();
    if (text.isEmpty) return 1;
    final wordCount = text.split(RegExp(r'\s+')).length;
    final minutes = (wordCount / 200).ceil();
    return minutes < 1 ? 1 : minutes;
  }

  String get displayDate {
    if (publishedAt.length >= 10) return publishedAt.substring(0, 10);
    return publishedAt;
  }
}
