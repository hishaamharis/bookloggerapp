import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../provider/book_collection_provider.dart';
import 'add_book_bottom_sheet.dart';

void showAddBookBottomSheet(BuildContext context, BookCollection collection,
    [Book? book]) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return AddBookBottomSheet(collection: collection, book: book);
    },
  );
}

void showReviewBottomSheet(BuildContext context, Book book) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Allows the bottom sheet to take full height
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)), // Rounded corners at the top
    ),
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity, // Set width to double.infinity
        height: MediaQuery.of(context).size.height * 0.5, // Set height to 50% of the screen height
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Review',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 350,
              width: double.infinity,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                // Enable scrolling if the review is long
                child: Text(
                  book.review, // Assuming 'review' contains your written review
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

class CollectionDetailScreen extends StatelessWidget {
  final BookCollection collection;

  CollectionDetailScreen({required this.collection});

  void _deleteCollection(BuildContext context) {
    final provider = Provider.of<BookCollectionProvider>(context, listen: false);

    // Show confirmation dialog before deleting
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Collection'),
          content: Text('Are you sure you want to delete this collection?'),
          actions: [
            TextButton(
              onPressed: () {
                provider.deleteCollection(collection); // Call the delete method
                Navigator.pop(context); // Close the dialog
                Navigator.pop(context); // Go back to the previous screen
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(collection.name),
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.red,
              size: 24,
            ),
            onPressed: () => _deleteCollection(context), // Call delete function
          ),
        ],
      ),
      body: Consumer<BookCollectionProvider>(
        builder: (context, provider, child) {
          if (collection.books.isEmpty) {
            return Center(
              child: GestureDetector(
                onTap: () => showAddBookBottomSheet(context, collection),
                child: Text(
                  '+ Add your first book',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: collection.books.length,
            itemBuilder: (context, index) {
              final book = collection.books[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 14),
                      child: Container(
                        width: 10,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  book.category,
                                  style: TextStyle(color: Colors.black45),
                                ),
                                PopupMenuButton<String>(
                                  icon: Icon(Icons.more_vert),
                                  onSelected: (value) {
                                    if (value == 'Edit') {
                                      // Add edit functionality here
                                    } else if (value == 'Remove') {
                                      // Add remove functionality here
                                    }
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return ['Edit', 'Remove']
                                        .map((String choice) {
                                      return PopupMenuItem<String>(
                                        value: choice,
                                        child: Text(
                                          choice,
                                          style: TextStyle(
                                            color: choice == 'Remove'
                                                ? Colors.red
                                                : Colors.blue,
                                          ),
                                        ),
                                      );
                                    }).toList();
                                  },
                                ),
                              ],
                            ),
                            Text(
                              book.title,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: Text(
                                book.summary,
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.contact_page_rounded,
                                    color: Colors.blueAccent),
                                SizedBox(width: 5),
                                GestureDetector(
                                  onTap: () {
                                    showReviewBottomSheet(context, book); // Show the review bottom sheet
                                  },
                                  child: Text(
                                    "Review",
                                    style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        onTap: () {
                          showAddBookBottomSheet(context, collection, book);
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: collection.books.isNotEmpty
          ? SizedBox(
        width: 380,
        child: FloatingActionButton.extended(
          onPressed: () {
            showAddBookBottomSheet(context, collection);
          },
          label: Text(
            'Add book',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.blueAccent,
        ),
      )
          : null,
    );
  }
}
