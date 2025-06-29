class Book {
  final String title;
  final List<String> authors;
  final List<String> authorKeys;
  final String? coverUrl;
  final String workKey;
  final int? firstPublishYear;
  final List<String>? languages;
  final bool? publicScan;

  Book({
    required this.title,
    required this.authors,
    required this.authorKeys,
    this.coverUrl,
    required this.workKey,
    this.firstPublishYear,
    this.languages,
    this.publicScan,
  });
}