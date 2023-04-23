import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:quantum_it/Model/news_moedl.dart';

Future<List<Article>> getNews() async {
  final response = await get(Uri.parse(
      'https://newsapi.org/v2/everything?q=tesla&from=2023-03-23&sortBy=publishedAt&apiKey=bbc892a802424d259378c62dfa8a9d9e'));
  if (response.statusCode == 200) {
    var news = NewsModel.fromJson(json.decode(response.body));
    var data = json.decode(response.body);
    var article = news.articles;

    print('${article[1].author}................................');
    var ar = data['articles'] as List;
    var list = ar.map<Article>((json) => Article.fromJson(json)).toList();
    return list;
  } else {
    return [];
  }
}

