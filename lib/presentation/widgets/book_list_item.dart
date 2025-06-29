import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_book/domain/entities/book.dart';
import 'package:sample_book/presentation/bloc/book_detail_bloc/book_detail_bloc.dart';
import 'package:sample_book/presentation/bloc/book_detail_bloc/book_detail_event.dart';
import 'package:sample_book/presentation/pages/book_detail_page.dart';

class BookListItem extends StatelessWidget {
  final Book book;

  const BookListItem({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 12,
      shadowColor: Colors.orange.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => BookDetailBloc()..add(FetchBookDetailEvent(book.workKey)),
                child: BookDetailPage(book: book),
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              book.coverUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(9),
                      child: Image.network(
                        book.coverUrl!,
                        width: 55,
                        height: 70,
                        fit: BoxFit.cover,
                      ),)
                  : const Icon(Icons.book),
              SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    Text(book.authors.join(', ')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
