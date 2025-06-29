import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sample_book/core/constants/api_constants.dart';
import 'package:sample_book/data/models/book_model.dart';
import 'package:sample_book/domain/entities/book_detail.dart';

class BookRemoteDataSource {
  Future<List<BookModel>> fetchBooks(String query, int page) async {
    String url = '';
    if(query.isEmpty){
      url = '${ApiConstants.baseUrl}/search.json?title=a&page=$page';
    }else {
      url = '${ApiConstants.baseUrl}/search.json?title=$query&page=$page';
    }
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<BookModel>.from(
        (data['docs'] as List).map((book) => BookModel.fromJson(book)),
      );
    } else {
      print('object $response');
      throw Exception('Failed to load books');
    }
  }

  Future<BookDetail> fetchBookDetail(String workKey) async {
    final response = await http.get(Uri.parse('${ApiConstants.baseUrl}$workKey.json'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return BookDetail.fromJson(jsonData);
    } else {
      throw Exception('Failed to fetch book detail');
    }
  }
}