class BookDetail {
  final String title;
  final String? description;
  final List<int>? covers;
  final String? firstPublishDate;

  BookDetail({
    required this.title,
    this.description,
    this.covers,
    this.firstPublishDate,
  });

  factory BookDetail.fromJson(Map<String, dynamic> json) {
    return BookDetail(
      title: json['title'] ?? 'No Title',
      description: json['description'] is Map ? json['description']['value'] : json['description'],
      covers: (json['covers'] as List?)?.cast<int>(),
      firstPublishDate: json['first_publish_date'],
    );
  }
}