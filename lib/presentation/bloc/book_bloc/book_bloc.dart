import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_book/data/datasources/book_remote_data_source.dart';
import 'package:sample_book/data/repositories/book_repository_impl.dart';
import 'package:sample_book/domain/entities/book.dart';
import 'package:sample_book/domain/usecases/get_book_usecase.dart';
import 'package:sample_book/presentation/bloc/book_bloc/book_event.dart';
import 'package:sample_book/presentation/bloc/book_bloc/book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final GetBooksUseCase useCase =
  GetBooksUseCase(BookRepositoryImpl(BookRemoteDataSource()));

  List<Book> _allBooks = [];
  int _currentPage = 1;
  String _lastQuery = '';

  BookBloc() : super(BookInitial()) {
    on<FetchBooksEvent>((event, emit) async {
      try {
        if (_lastQuery != event.query) {
          _currentPage = 1;
          _allBooks = [];
        }
        _lastQuery = event.query;
        if (_currentPage == 1) emit(BookLoading(books: []));

        final books = await useCase(event.query, _currentPage);

        if (books.isEmpty) {
          emit(BookLoaded(books: _allBooks, currentPage: _currentPage, hasReachedEnd: true));
        } else {
          _allBooks.addAll(books);
          emit(BookLoaded(books: _allBooks, currentPage: _currentPage, hasReachedEnd: false));
          _currentPage++;
        }
      } catch (e) {
        emit(BookError(e.toString()));
      }
    });
  }
}