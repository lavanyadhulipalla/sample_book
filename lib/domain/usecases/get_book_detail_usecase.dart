import 'package:sample_book/domain/entities/book_detail.dart';
import 'package:sample_book/domain/repositories/book_repository.dart';

class GetBooksDetailUseCase {
  final BookRepository repository;
  GetBooksDetailUseCase(this.repository);

  Future<BookDetail> call(String workKey) {
    return repository.getBookDetail(workKey);
  }
}