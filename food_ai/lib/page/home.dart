import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_ai/api/google.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:food_ai/model/model.dart';

import 'package:animated_floatactionbuttons/animated_floatactionbuttons.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();

  List<CircularStackEntry> data = <CircularStackEntry>[
    new CircularStackEntry(
      <CircularSegmentEntry>[
        new CircularSegmentEntry(userModel.getCal(), Colors.greenAccent,
            rankKey: 'Calorie'),
        new CircularSegmentEntry(userModel.getFoodCal(), Colors.grey)
      ],
    )
  ];

  Widget gallery() {
    return Container(
      child: new FloatingActionButton(
        onPressed: () {
          userModel.getGallery();
        },
        tooltip: 'Gallery',
        child: Icon(Icons.image),
        mini: true,
        heroTag: "btnGallery",
      ),
    );
  }

  Widget camera() {
    return Container(
      child: new FloatingActionButton(
        onPressed: () {
          userModel.getCamera();
        },
        tooltip: 'Camera',
        child: Icon(Icons.camera_alt),
        mini: true,
        heroTag: "btnCamera",
      ),
    );
  }
  /*void _incrementCounter() {
    userModel.addFoodCal();
    List<CircularStackEntry> nextData = <CircularStackEntry>[
      new CircularStackEntry(
        <CircularSegmentEntry>[
          new CircularSegmentEntry(userModel.getCal(), Colors.greenAccent),
          new CircularSegmentEntry(userModel.getFoodCal(), Colors.white)
        ],
      )
    ];
    setState(() {
      _chartKey.currentState.updateData(nextData);
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        title: new Text("Home"),
        actions: <Widget>[
          new IconButton(
            padding: EdgeInsets.only(right: 20.0),
            icon: new Icon(Icons.exit_to_app),
            onPressed: () {
              authService.signOut();
              Navigator.popAndPushNamed(context, "loginpage");
            },
          )
        ],
      ),
      body: new Builder(builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
                flex: 4,
                child: AnimatedCircularChart(
                  key: _chartKey,
                  size: const Size(180.0, 180.0),
                  initialChartData: data,
                  chartType: CircularChartType.Radial,
                  holeLabel: userModel.getCal().toString() + ' Cal',
                  holeRadius: 40.0,
                )),
            Expanded(
                flex: 6,
                child: FutureBuilder(
                    future: userModel.getDailyFoodList(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return Center(child: CircularProgressIndicator());
                      else {
                        return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: new CircleAvatar(
                                  radius: 30.0,
                                  backgroundColor: Colors.transparent,
                                child: Image.network(snapshot
                                    .data[index].data['Photo'],scale: 0.3,)),
                                title: Text(snapshot
                                    .data[index].data['Name']),
                              );
                            });
                      }
                    })),
          ],
        );
      }),
      floatingActionButton: new AnimatedFloatingActionButton(
        fabButtons: <Widget>[camera(), gallery()],
        colorStartAnimation: Colors.blue,
        colorEndAnimation: Colors.red,
        animatedIconData: AnimatedIcons.menu_close,
      ),
    );
  }
}

class FirestoreListView extends StatelessWidget {
  final List<DocumentSnapshot> documents;

  FirestoreListView({this.documents});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: documents.length,
      itemExtent: 90.0,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(documents[index].data['Name']),
        );
      },
    );
  }
}
