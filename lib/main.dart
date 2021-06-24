import 'package:flutter/material.dart';
import 'slide_up_bottom_bar/slide_up_bottom_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: SlideUpBar(),
      // home: TravelCardDemo(),
    );
  }
}

