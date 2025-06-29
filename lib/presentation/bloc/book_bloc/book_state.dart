import 'package:equatable/equatable.dart';
import 'package:sample_book/domain/entities/book.dart';

abstract class BookState extends Equatable {
  const BookState();

  @override
  List<Object?> get props => [];
}

class BookInitial extends BookState {}

class BookLoading extends BookState {
  final List<Book> books;

  const BookLoading({required this.books});

  @override
  List<Object?> get props => [books];
}

class BookLoaded extends BookState {
  final List<Book> books;
  final int currentPage;
  final bool hasReachedEnd;

  const BookLoaded({
    required this.books,
    required this.currentPage,
    required this.hasReachedEnd,
  });

  @override
  List<Object?> get props => [books, currentPage, hasReachedEnd];
}

class BookError extends BookState {
  final String message;

  const BookError(this.message);

  @override
  List<Object?> get props => [message];
}