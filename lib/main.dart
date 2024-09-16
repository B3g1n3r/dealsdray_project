import 'package:flutter/material.dart';
import 'package:shop/screens/homescreen.dart';
import 'package:shop/screens/splashscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyApp',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
