import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/models.dart';

class BookCollectionProvider with ChangeNotifier {
  Box<BookCollection> collectionsBox = Hive.box<BookCollection>('collections');

  List<BookCollection> get collections => collectionsBox.values.toList();

  void addCollection(BookCollection collection) {
    collectionsBox.add(collection);
    notifyListeners();
  }

  void addBookToCollection(BookCollection collection, Book book) {
    collection.books.add(book);
    collection.save();
    notifyListeners();
  }

  void updateBook(Book book, String review) {
    book.review = review;
    book.save();
    notifyListeners();
  }

  // Method to delete a collection
  void deleteCollection(BookCollection collection) {
    collection.delete(); // Delete from Hive
    notifyListeners();
  }

}
