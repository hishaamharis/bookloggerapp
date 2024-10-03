import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/models.dart';
import '../provider/book_collection_provider.dart';

class AddBookBottomSheet extends StatefulWidget {
  final BookCollection collection;
  final Book? book;

  AddBookBottomSheet({required this.collection, this.book});

  @override
  _AddBookBottomSheetState createState() => _AddBookBottomSheetState();
}

class _AddBookBottomSheetState extends State<AddBookBottomSheet> {
  String? selectedCategory;
  String? selectedBook;
  TextEditingController reviewController = TextEditingController();
  bool isLoading = false;
  List<Map<String, String>> categories = [];
  List<Book> books = [];

  @override
  void initState() {
    super.initState();
    if (widget.book != null) {
      selectedCategory = widget.book!.category;
      selectedBook = widget.book!.title;
      reviewController.text = widget.book!.review;
      fetchBooks(widget.book!.category);
    } else {
      fetchCategories();
    }
  }

  void fetchCategories() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(Uri.parse(
        'https://books-api-task-db307f0c475d.herokuapp.com/api/categories'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      setState(() {
        categories = data
            .map((e) =>
                {'id': e['id'] as String, 'category': e['category'] as String})
            .toList();
        isLoading = false;
      });
    } else {
      // Handle error
      setState(() {
        isLoading = false;
      });
    }
  }

  void fetchBooks(String categoryId) async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(Uri.parse(
        'https://books-api-task-db307f0c475d.herokuapp.com/api/books/$categoryId'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      setState(() {
        books = data
            .map((e) => Book(
                  title: e['title'],
                  category: e['category'],
                  summary: e['summary'],
                  review: '',
                ))
            .toList();
        isLoading = false;
      });
    } else {
      // Handle error
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Add book",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
          ),
          SizedBox(
            height: 10,
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
            ),
            child: isLoading
                ? CircularProgressIndicator()
                : DropdownButton<String>(
                    value: selectedCategory,
                    hint: Text('Select Category'),
                    isExpanded: true,
                    items: categories.map((category) {
                      return DropdownMenuItem<String>(
                        child: Text(category['category']!),
                        value: category['id'],
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                        fetchBooks(
                            value!);
                      });
                    },
                  ),
          ),
          SizedBox(height: 16.0),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
            ),
            child: isLoading
                ? CircularProgressIndicator()
                : DropdownButton<String>(
                    value: selectedBook,
                    hint: Text('Select Book'),
                    isExpanded: true,
                    items: books.map((book) {
                      return DropdownMenuItem<String>(
                        child: Text(book.title),
                        value: book.title,
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedBook = value;
                      });
                    },
                  ),
          ),
          SizedBox(height: 16.0),

          if (selectedBook != null)
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white,
              ),
              child: Text(
                '${books.firstWhere((book) => book.title == selectedBook).summary}',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            )
          else
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white,
              ),
              child: Text(
                'Details',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),

          SizedBox(height: 16.0),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
            ),
            child: TextField(
              controller: reviewController,
              decoration: InputDecoration(
                labelText: 'Type your Review',
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                final newBook = Book(
                  title: selectedBook!,
                  category: selectedCategory!,
                  summary: books
                      .firstWhere((book) => book.title == selectedBook)
                      .summary,
                  review: reviewController.text,
                );

                if (widget.book != null) {
                  Provider.of<BookCollectionProvider>(context, listen: false)
                      .updateBook(widget.book!, reviewController.text);
                } else {
                  Provider.of<BookCollectionProvider>(context, listen: false)
                      .addBookToCollection(widget.collection, newBook);
                }

                Navigator.pop(context);
              },
              child: Text(
                'Add',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
