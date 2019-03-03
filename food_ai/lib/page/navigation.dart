import 'package:flutter/material.dart';
import 'about.dart';
import 'history.dart';
import 'home.dart';
import 'profile.dart';

class NavPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NavPageState();
}

class NavPageState extends State<NavPage> {
  int _selectedPage = 0;
  final _pageOption = [HomePage(), HistoryPage(), ProfilePage(), AboutPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageOption[_selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPage,
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.blue,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
          BottomNavigationBarItem(
              icon: Icon(Icons.insert_invitation), title: Text("History")),
          BottomNavigationBarItem(
              icon: Icon(Icons.people), title: Text("Profiles")),
          BottomNavigationBarItem(icon: Icon(Icons.info), title: Text("About")),
        ],
        onTap: (int index) {
          setState(() {
            _selectedPage = index;
          });
        },
      ),
    );
  }
}
