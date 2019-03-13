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
            primaryColor: Colors.yellow[900], accentColor: Colors.lightGreen[900], scaffoldBackgroundColor: Colors.yellow[50]),
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
