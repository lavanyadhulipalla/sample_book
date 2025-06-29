import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_book/data/local/book_database_helper.dart';
import 'package:sample_book/data/local/book_local_model.dart';
import 'package:sample_book/domain/entities/book.dart';
import 'package:sample_book/presentation/bloc/book_detail_bloc/book_detail_bloc.dart';
import 'package:sample_book/presentation/bloc/book_detail_bloc/book_detail_event.dart';
import 'package:sample_book/presentation/bloc/book_detail_bloc/book_detail_state.dart';

class BookDetailPage extends StatefulWidget {
  final Book book;

  const BookDetailPage({super.key, required this.book});

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage>
    with SingleTickerProviderStateMixin {
  final _dbHelper = BookDatabaseHelper();
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    context
        .read<BookDetailBloc>()
        .add(FetchBookDetailEvent(widget.book.workKey));
  }

  Future<void> _saveBook(String title, String key) async {
    final book = BookLocalModel(title: title, workKey: key);
    await _dbHelper.insertBook(book);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Book Added To Library!')),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildAuthorAvatars(
      List<String>? authorKeys, List<String>? authorNames) {
    if (authorKeys == null || authorKeys.isEmpty)
      return const SizedBox.shrink();

    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: authorKeys.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final key = authorKeys[index];
          if (kDebugMode) {
            print('image url https://covers.openlibrary.org/a/olid/$key.jpg');
          }
          final name = authorNames != null && authorNames.length > index
              ? authorNames[index]
              : 'A';
          final imageUrl = 'https://covers.openlibrary.org/a/olid/$key.jpg';

          return CircleAvatar(
            radius: 22,
            backgroundColor: Colors.orange[100],
            backgroundImage: NetworkImage(imageUrl),
            child: Text(
              name[0].toUpperCase(),
              style: const TextStyle(color: Colors.black),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[200],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: BlocBuilder<BookDetailBloc, BookDetailState>(
        builder: (context, state) {
          if (state is BookDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BookDetailLoaded) {
            final bookDetail = state.bookDetail;
            final coverUrl = bookDetail.covers?.isNotEmpty == true
                ? 'https://covers.openlibrary.org/b/id/${bookDetail.covers!.first}-L.jpg'
                : null;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    color: Colors.orange[200],
                    child: Center(
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: coverUrl != null
                              ? Image.network(coverUrl, height: MediaQuery.of(context).size.height * 0.25)
                              : const Icon(Icons.book, size: 100),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          Text(
                            bookDetail.title,
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            textAlign: TextAlign.center,
                            widget.book.authors.join(', '),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 16),

                          Expanded(
                            child: SingleChildScrollView(
                              child: Text(
                                bookDetail.description ??
                                    'No description available.',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: _buildAuthorAvatars(
                                widget.book.authorKeys, widget.book.authors),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: ElevatedButton(
                              onPressed: () => _saveBook(
                                  bookDetail.title, widget.book.workKey),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                                minimumSize: const Size.fromHeight(50),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text("Add to Library"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else if (state is BookDetailError) {
            return Center(child: Text(state.message));
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
