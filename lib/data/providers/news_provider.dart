import 'package:moderno/data/models/news.dart';

final newsProviderInstance = NewsProvider();

class NewsProvider {
  static NewsProvider instance = NewsProvider();

  final _newsDB = _loadNewsDatabase();

  Future<List<News>> getNews([int count = 5]) async {
    return _newsDB.take(count).toList();
  }
}

List<News> _loadNewsDatabase() {
  List<News> newsDatabase = [
    News(
      imageUrl: "images/news/news1.jpg",
      title: "New Couche Models",
    ),
    News(
      imageUrl: "images/news/news2.jpg",
      title: "Experience The Light",
    ),
    News(
      imageUrl: "images/news/news3.jpg",
      title: "Back to School Desks",
    ),
    News(
      imageUrl: "images/news/news4.jpg",
      title: "New Shelf Designs",
    ),
    News(
      imageUrl: "images/news/news5.jpg",
      title: "Enhance your Morning Routine",
    ),
  ];
  return newsDatabase;
}
