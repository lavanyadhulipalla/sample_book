abstract class BookEvent {}

class FetchBooksEvent extends BookEvent {
  final String query;
  final int page;

  FetchBooksEvent({required this.query, this.page = 1});
}