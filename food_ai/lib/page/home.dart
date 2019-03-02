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
  double _imageHeight;
  double _imageWidth;

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
          userModel.getGallery().whenComplete(() {
            imgRec();
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

  void _incrementCounter() {
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
  }

  Future loadModel() async {
    var res = await Tflite.loadModel(
      model: "assets/optimized_graph.tflite",
      labels: "assets/retrained_labels.txt",
    );
    print(res);
  }

  Future getImage() async {
    var image = await userModel.getImage();
    recognizeImage(image);

    new FileImage(image)
        .resolve(new ImageConfiguration())
        .addListener((ImageInfo info, bool _) {
      setState(() {
        _imageHeight = info.image.height.toDouble();
        _imageWidth = info.image.width.toDouble();
      });
    });

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

  List<Widget> renderBoxes(Size screen) {
    if (_recognitions == null) return [];
    double factorX = screen.width;
    double factorY = _imageHeight / _imageWidth * screen.width;
    Color blue = Color.fromRGBO(37, 213, 253, 1.0);
    return _recognitions.map((re) {
      return Positioned(
        left: re["rect"]["x"] * factorX,
        top: re["rect"]["y"] * factorY,
        width: re["rect"]["w"] * factorX,
        height: re["rect"]["h"] * factorY,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: blue,
              width: 2,
            ),
          ),
          child: Text(
            "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              background: Paint()..color = blue,
              color: Colors.white,
              fontSize: 12.0,
            ),
          ),
        ),
      );
    }).toList();
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
              Container(
                child: Image.file(_image)
              ),
              Container(
                child: Column(
                    children: _recognitions.map((res) {
                  if (res["confidence"] > 0.5) {
                    return Text(
                      "${res["label"]}: ${res["confidence"].toString()}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        background: Paint()..color = Colors.white,
                      ),
                    );
                  } else
                    return Text("");
                }).toList()),
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
                child: StreamBuilder(
                    stream: userModel.getDailyFoodList().asStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return Center(child: CircularProgressIndicator());
                      else {
                        return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: new Container(
                                    width: 50.0,
                                    height: 50.0,
                                    decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: new DecorationImage(
                                            fit: BoxFit.fill,
                                            image: new NetworkImage(snapshot
                                                .data[index].data['Photo'])))),
                                title: Text(snapshot.data[index].data['Name']),
                                subtitle: Text("300 Cal"),
                                trailing: Icon(Icons.info_outline),
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
