import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/models.dart';
import 'provider/book_collection_provider.dart';
import 'screens/collection_list_screen.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(BookCollectionAdapter());
  Hive.registerAdapter(BookAdapter());
  await Hive.openBox<BookCollection>('collections');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookCollectionProvider(),
      child: PopupMenuTheme(
        data: PopupMenuThemeData(
          color: Colors.white,
        ),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: CollectionListScreen(),
        ),
      ),
    );
  }
}
