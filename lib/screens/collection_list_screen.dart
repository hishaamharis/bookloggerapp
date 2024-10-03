import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../provider/book_collection_provider.dart';
import 'add_book_bottom_sheet.dart';
import 'collection_details_screen.dart';

void showAddBookBottomSheet(BuildContext context, BookCollection collection,
    [Book? book]) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return AddBookBottomSheet(collection: collection, book: book);
    },
  );
}

class CollectionListScreen extends StatelessWidget {
  final TextEditingController collectionNameController =
  TextEditingController();

  void showAddCollectionDialog(BuildContext context) {
    // Fetch existing collections count to generate the next name
    final provider = Provider.of<BookCollectionProvider>(context, listen: false);
    final collectionCount = provider.collections.length + 1;
    final collectionName = 'Collection $collectionCount';

    final newCollection = BookCollection(
      name: collectionName,
      dateCreated: DateTime.now(),
      books: [],
    );

    provider.addCollection(newCollection);

    // Navigate to the CollectionDetailScreen immediately after adding
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CollectionDetailScreen(collection: newCollection),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 130,
            width: double.infinity,
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Text(
                  'Good Morning',
                  style: TextStyle(color: Colors.white70, fontSize: 17),
                ),
                Text(
                  'Rajesh Mehta',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<BookCollectionProvider>(
              builder: (context, provider, child) {
                return ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  itemCount: provider.collections.length,
                  itemBuilder: (context, index) {
                    final collection = provider.collections[index];
                    String formattedDate = DateFormat('MMMM d, yyyy')
                        .format(collection.dateCreated);

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
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
                              title: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    collection.name,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.calendar_month,
                                          color: Colors.grey),
                                      SizedBox(width: 4.0),
                                      Text(
                                        formattedDate,
                                        style: TextStyle(
                                          color: Colors.black38,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              subtitle: Padding(
                                padding:
                                const EdgeInsets.only(top: 8, bottom: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 6.0),
                                      decoration: BoxDecoration(
                                        color: Colors.deepPurple[100],
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        '${collection.books.length} books',
                                        style: TextStyle(
                                          color: Colors.black38,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CollectionDetailScreen(
                                            collection: collection),
                                  ),
                                );
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
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: 380,
        child: FloatingActionButton.extended(
          onPressed: () {
            showAddCollectionDialog(context);
          },
          label: Text(
            'Create a new collection',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.blueAccent,
        ),
      ),
    );
  }
}
