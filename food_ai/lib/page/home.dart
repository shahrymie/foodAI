import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_ai/api/google.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:food_ai/model/model.dart';

import 'package:animated_floatactionbuttons/animated_floatactionbuttons.dart';
import 'package:tflite/tflite.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File _image;
  List _recognitions;

  final GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();

  Widget gallery() {
    return Container(
      child: new FloatingActionButton(
        onPressed: () {
          userModel.getGallery().whenComplete(() {
            if (userModel.getImage() != null) imgRec();
          });
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
          userModel.getCamera().whenComplete(() {
            imgRec();
          });
        },
        tooltip: 'Camera',
        child: Icon(Icons.camera_alt),
        mini: true,
        heroTag: "btnCamera",
      ),
    );
  }

  Future loadModel() async {
    var res = await Tflite.loadModel(
      model: "assets/optimized_graph.tflite",
      labels: "assets/retrained_labels.txt",
    );
  }

  Future getImage() async {
    var image = userModel.getImage();
    recognizeImage(image);

    setState(() {
      _image = image;
    });
  }

  Future recognizeImage(File image) async {
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _recognitions = recognitions;
    });
  }

  Future<Null> imgRec() async {
    loadModel();
    getImage();
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding: EdgeInsets.all(15.0),
            children: <Widget>[
              Container(child: Image.file(_image)),
              Container(
                child: Column(
                    children: _recognitions.map((res) {
                  if (res["confidence"] > 0.5) {
                    userModel.setId(3, res["label"]);
                    userModel.setNutrition();
                    userModel.uploadImage(res["label"]);
                    return Padding(
                        padding: EdgeInsets.all(20.0),
                        child: new Text(
                          "${res["label"]}: ${res["confidence"].toStringAsFixed(3)}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            background: Paint()..color = Colors.white,
                          ),
                        ));
                  } else
                    return Text("");
                }).toList()),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: new FloatingActionButton(
                      onPressed: () {
                        userModel.setFoodState(true);
                        Navigator.popAndPushNamed(context, "foodpage");
                      },
                      tooltip: 'Accept',
                      child: Icon(Icons.check),
                      mini: true,
                      heroTag: "btnAccept",
                    ),
                  ),
                  Container(
                    child: new FloatingActionButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      tooltip: 'Decline',
                      child: Icon(Icons.close),
                      mini: true,
                      heroTag: "btnDecline",
                    ),
                  )
                ],
              )
            ],
          );
        });
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
              Navigator.popAndPushNamed(context, "loginpage");
              authService.signOut();
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
                child: new AnimatedCircularChart(
                  key: _chartKey,
                  size: const Size(180.0, 180.0),
                  initialChartData: <CircularStackEntry>[
                    new CircularStackEntry(
                      <CircularSegmentEntry>[
                        new CircularSegmentEntry(
                            userModel.getDailyCalorie().toDouble(),
                            Colors.lightGreen[900],
                            rankKey: 'Calorie'),
                        new CircularSegmentEntry(
                          userModel.getProfile(2).toDouble(),
                          Colors.grey,
                          rankKey: 'Remaining',
                        ),
                      ],
                    ),
                  ],
                  chartType: CircularChartType.Radial,
                  edgeStyle: SegmentEdgeStyle.round,
                  holeLabel: userModel.getDailyCalorie().toString() + ' Cal',
                  holeRadius: 40.0,
                )),
            Expanded(
                flex: 6,
                child: new StreamBuilder(
                    stream: userModel.getDailyFoodList().asStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return Center(child: CircularProgressIndicator());
                      else {
                        return new ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return new ListTile(
                                leading: new Container(
                                    width: 55.0,
                                    height: 55.0,
                                    decoration: new BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 1.5,
                                        ),
                                        shape: BoxShape.circle,
                                        image: new DecorationImage(
                                            fit: BoxFit.fill,
                                            image: new NetworkImage(snapshot
                                                .data[index].data['Photo'])))),
                                title: Text(snapshot.data[index].data['Name']),
                                subtitle: Text(snapshot.data[index].data['Cal']
                                        .toString() +
                                    " Cal"),
                                trailing: Icon(Icons.info_outline),
                                onTap: () async {
                                  userModel.setId(
                                      3, snapshot.data[index].data['ID']);
                                  userModel.setNutrition();
                                  userModel.setUrl(
                                      snapshot.data[index].data['Photo']);
                                  userModel.setFoodState(false);
                                  await new Future.delayed(
                                      const Duration(seconds: 1));
                                  Navigator.pushNamed(context, "foodpage");
                                },
                              );
                            });
                      }
                    })),
          ],
        );
      }),
      floatingActionButton: new AnimatedFloatingActionButton(
        fabButtons: <Widget>[camera(), gallery()],
        colorStartAnimation: Colors.lightGreen[900],
        colorEndAnimation: Colors.red[900],
        animatedIconData: AnimatedIcons.menu_close,
      ),
    );
  }
}
