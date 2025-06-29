import 'package:sample_book/domain/entities/book.dart';
import 'package:sample_book/domain/repositories/book_repository.dart';

class GetBooksUseCase {
  final BookRepository repository;
  GetBooksUseCase(this.repository);

  Future<List<Book>> call(String query, int page) {
    return repository.getBooks(query, page);
  }
}