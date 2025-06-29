class BookLocalModel {
  final String title;
  final String workKey;

  BookLocalModel({required this.title, required this.workKey});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'workKey': workKey,
    };
  }

  factory BookLocalModel.fromMap(Map<String, dynamic> map) {
    return BookLocalModel(
      title: map['title'],
      workKey: map['workKey'],
    );
  }
}