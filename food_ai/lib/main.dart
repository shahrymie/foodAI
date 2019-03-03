import 'package:flutter/material.dart';
import 'package:food_ai/page/foodinfo.dart';
import 'package:food_ai/page/login.dart';
import 'package:food_ai/page/navigation.dart';
import 'package:food_ai/page/setup.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          "loginpage": (context) => LoginPage(),
          "setuppage": (context) => SetupPage(),
          "navpage": (context) => NavPage(),
          "foodpage": (context) => FoodPage(),
        },
        home: LoginPage());
  }
}
