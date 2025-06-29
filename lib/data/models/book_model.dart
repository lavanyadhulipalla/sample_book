import 'package:sample_book/domain/entities/book.dart';

class BookModel extends Book {
  BookModel({
    required String title,
    required List<String> authors,
    required List<String> authorKeys,
    String? coverUrl,
    required String workKey,
    int? firstPublishYear,
    List<String>? languages,
    bool? publicScan,
  }) : super(
    title: title,
    authors: authors,
    authorKeys: authorKeys,
    coverUrl: coverUrl,
    workKey: workKey,
    firstPublishYear: firstPublishYear,
    languages: languages,
    publicScan: publicScan,
  );

  factory BookModel.fromJson(Map<String, dynamic> json) {
    final coverId = json['cover_i'];
    return BookModel(
      title: json['title'] ?? '',
      authors: List<String>.from(json['author_name'] ?? []),
      authorKeys: List<String>.from(json['author_key'] ?? []),
      coverUrl: coverId != null ? 'https://covers.openlibrary.org/b/id/$coverId-M.jpg' : null,
      workKey: json['key'] ?? '',
      firstPublishYear: json['first_publish_year'],
      languages: json['language'] != null ? List<String>.from(json['language']) : null,
      publicScan: json['public_scan_b'],
    );
  }
}