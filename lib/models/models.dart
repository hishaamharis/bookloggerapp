import 'package:hive/hive.dart';

part 'models.g.dart';

@HiveType(typeId: 0)
class BookCollection extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  DateTime dateCreated;

  @HiveField(2)
  List<Book> books;

  BookCollection({
    required this.name,
    required this.dateCreated,
    required this.books,
  });
}

@HiveType(typeId: 1)
class Book extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String category;

  @HiveField(2)
  String summary;

  @HiveField(3)
  String review;

  Book({
    required this.title,
    required this.category,
    required this.summary,
    required this.review,
  });
}
