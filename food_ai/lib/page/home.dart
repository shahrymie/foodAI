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

  Future getList() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore
        .collection('user')
        .document(userModel.getId())
        .collection('daily food')
        .getDocuments();
    return qn.documents;
  }

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
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
                child: Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: AnimatedCircularChart(
                      key: _chartKey,
                      size: const Size(180.0, 180.0),
                      initialChartData: data,
                      chartType: CircularChartType.Radial,
                      holeLabel: userModel.getCal().toString() + ' Cal',
                      holeRadius: 40.0,
                    ))),
            Container(
                child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: StreamBuilder(
                        stream: Firestore.instance
                            .collection('user')
                            .document(userModel.getId())
                            .collection('daily food')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return CircularProgressIndicator();
                          return FirestoreListView(
                              documents: snapshot.data.documents);
                        }))),
          ],
        ),
      )),
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
