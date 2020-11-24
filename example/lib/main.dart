import 'package:flutter/material.dart';
import 'sliver_home_page.dart';
import 'home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Animated Stream List example',
      home: SliverHomePage(),
    );
  }
}
