import 'package:sample_book/domain/entities/book_detail.dart';

abstract class BookDetailState {
  const BookDetailState();
}

class BookDetailInitial extends BookDetailState {}
class BookDetailLoading extends BookDetailState {}
class BookDetailLoaded extends BookDetailState {
  final BookDetail bookDetail;
  const BookDetailLoaded(this.bookDetail);
}
class BookDetailError extends BookDetailState {
  final String message;
  const BookDetailError(this.message);
}