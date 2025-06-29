import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_book/presentation/bloc/book_bloc/book_bloc.dart';
import 'package:sample_book/presentation/bloc/book_bloc/book_event.dart';
import 'package:sample_book/presentation/bloc/book_detail_bloc/book_detail_bloc.dart';
import 'package:sample_book/presentation/pages/book_search_page.dart';
import 'package:sample_book/presentation/pages/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Book Finder',
        theme: ThemeData(
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
            titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.black),
            bodyMedium: TextStyle(color: Colors.black87),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
