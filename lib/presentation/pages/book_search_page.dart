import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_book/presentation/bloc/book_bloc/book_bloc.dart';
import 'package:sample_book/presentation/bloc/book_bloc/book_event.dart';
import 'package:sample_book/presentation/bloc/book_bloc/book_state.dart';
import 'package:sample_book/presentation/widgets/book_list_item.dart';
import 'package:sample_book/presentation/widgets/book_shimmer_item.dart';

class BookSearchPage extends StatefulWidget {
  const BookSearchPage({super.key});

  @override
  State<BookSearchPage> createState() => _BookSearchPageState();
}

class _BookSearchPageState extends State<BookSearchPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<BookBloc>().add(FetchBooksEvent(query: 'a'));
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = context.read<BookBloc>().state;
      if (state is BookLoaded && !state.hasReachedEnd) {
        context.read<BookBloc>().add(FetchBooksEvent(query: _searchController.text));
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    context.read<BookBloc>().add(FetchBooksEvent(query: _searchController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Finder')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100],
                hintText: 'Search books...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (query) {
                context.read<BookBloc>().add(FetchBooksEvent(query: query));
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<BookBloc, BookState>(
              builder: (context, state) {
                if (state is BookLoading && state.books.isEmpty) {
                  return ListView.builder(
                    itemCount: 10,
                    itemBuilder: (_, __) => const BookShimmerItem(),
                  );
                } else if (state is BookLoaded || (state is BookLoading && state.books.isNotEmpty)) {
                  final books = state is BookLoaded ? state.books : (state as BookLoading).books;
                  final hasReachedEnd = state is BookLoaded ? state.hasReachedEnd : false;

                  return RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: hasReachedEnd ? books.length : books.length + 1,
                      itemBuilder: (context, index) {
                        if (index < books.length) {
                          return BookListItem(book: books[index]);
                        } else {
                          return const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: BookShimmerItem(),
                          );
                        }
                      },
                    ),
                  );
                } else if (state is BookError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
