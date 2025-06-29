import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_book/data/datasources/book_remote_data_source.dart';
import 'package:sample_book/data/repositories/book_repository_impl.dart';
import 'package:sample_book/domain/usecases/get_book_detail_usecase.dart';
import 'package:sample_book/presentation/bloc/book_detail_bloc/book_detail_event.dart';
import 'package:sample_book/presentation/bloc/book_detail_bloc/book_detail_state.dart';

class BookDetailBloc extends Bloc<BookDetailEvent, BookDetailState> {
  final GetBooksDetailUseCase useCase =
  GetBooksDetailUseCase(BookRepositoryImpl(BookRemoteDataSource()));

  BookDetailBloc() : super(BookDetailInitial()) {
    on<FetchBookDetailEvent>((event, emit) async {
      emit(BookDetailLoading());
      try {
        final detail = await useCase(event.workKey);
        emit(BookDetailLoaded(detail));
      } catch (e) {
        emit(BookDetailError('Failed to load book details'));
      }
    });
  }
}