import 'package:moderno/data/models/news.dart';
import 'package:moderno/data/providers/news_provider.dart';

class NewsRepository {
  static NewsRepository instance = NewsRepository();

  final _newsProvider = newsProviderInstance;

  NewsRepository();

  Future<List<News>> getNews([int count = 5]) async {
    return await _newsProvider.getNews(count);
  }
}
