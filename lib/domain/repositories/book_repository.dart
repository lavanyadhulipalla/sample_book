import 'package:sample_book/domain/entities/book.dart';
import 'package:sample_book/domain/entities/book_detail.dart';

abstract class BookRepository {
  Future<List<Book>> getBooks(String query, int page);
  Future<BookDetail> getBookDetail(String workKey);
}