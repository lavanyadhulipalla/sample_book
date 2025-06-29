abstract class BookDetailEvent {
  const BookDetailEvent();
}

class FetchBookDetailEvent extends BookDetailEvent {
  final String workKey;
  const FetchBookDetailEvent(this.workKey);
}