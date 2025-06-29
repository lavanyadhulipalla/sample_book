import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sample_book/domain/entities/book.dart';
import 'package:sample_book/domain/usecases/get_book_usecase.dart';
import 'package:sample_book/presentation/bloc/book_bloc/book_bloc.dart';
import 'package:sample_book/presentation/bloc/book_bloc/book_event.dart';
import 'package:sample_book/presentation/bloc/book_bloc/book_state.dart';

/// Mocks
class MockGetBooksUseCase extends Mock implements GetBooksUseCase {}

void main() {
  late MockGetBooksUseCase mockUseCase;
  late BookBlocTestable bookBloc;

  const query = 'A Room';

  final mockBooks = [
    Book(
      title: 'A Room with a View',
      workKey: '/works/OL88813W',
      coverUrl: 'https://covers.openlibrary.org/b/id/1748132-M.jpg',
      authorKeys: ['OL6898863A'],
      authors: ['Edward Morgan Forster'],
    ),
  ];

  setUp(() {
    mockUseCase = MockGetBooksUseCase();
    bookBloc = BookBlocTestable(useCase: mockUseCase);
  });

  tearDown(() => bookBloc.close());

  /// Success case
  blocTest<BookBloc, BookState>(
    'emits [BookLoading, BookLoaded] when books are fetched successfully',
    build: () {
      when(() => mockUseCase.call(query, 1)).thenAnswer((_) async => mockBooks);
      return bookBloc;
    },
    act: (bloc) => bloc.add(FetchBooksEvent(query: query)),
    expect: () => [
      const BookLoading(books: []),
      BookLoaded(books: mockBooks, currentPage: 1, hasReachedEnd: false),
    ],
  );

  /// Empty list case (hasReachedEnd = true)
  blocTest<BookBloc, BookState>(
    'emits [BookLoading, BookLoaded(hasReachedEnd: true)] when no books found',
    build: () {
      when(() => mockUseCase.call(query, 1)).thenAnswer((_) async => []);
      return bookBloc;
    },
    act: (bloc) => bloc.add(FetchBooksEvent(query: query)),
    expect: () => [
      const BookLoading(books: []),
      BookLoaded(books: [], currentPage: 1, hasReachedEnd: true),
    ],
  );

  /// Error case
  blocTest<BookBloc, BookState>(
    'emits [BookLoading, BookError] when use case throws exception',
    build: () {
      when(() => mockUseCase.call(query, 1))
          .thenThrow(Exception('API failed'));
      return bookBloc;
    },
    act: (bloc) => bloc.add(FetchBooksEvent(query: query)),
    expect: () => [
      const BookLoading(books: []),
      const BookError('Exception: API failed'),
    ],
  );
}

/// Override the BookBloc constructor so we can inject the mocked use case
class BookBlocTestable extends BookBloc {
  BookBlocTestable({required this.useCase}) : super();

  @override
  final GetBooksUseCase useCase;
}