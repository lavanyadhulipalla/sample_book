import 'package:sample_book/data/datasources/book_remote_data_source.dart';
import 'package:sample_book/domain/entities/book.dart';
import 'package:sample_book/domain/entities/book_detail.dart';
import 'package:sample_book/domain/repositories/book_repository.dart';

class BookRepositoryImpl implements BookRepository {
  final BookRemoteDataSource remoteDataSource;

  BookRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Book>> getBooks(String query, int page) {
    return remoteDataSource.fetchBooks(query, page);
  }

  @override
  Future<BookDetail> getBookDetail(String workKey) {
    return remoteDataSource.fetchBookDetail(workKey);
  }
}