import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ChucNang/home.dart';
import 'data/source/favorite_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => FavoriteProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MusicApp(),
    );
  }
}
