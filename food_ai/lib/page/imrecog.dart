import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_ai/model/model.dart';
import 'package:tflite/tflite.dart';

class ImgRecPage extends StatefulWidget {
  @override
  _ImgRecPageState createState() => new _ImgRecPageState();
}

class _ImgRecPageState extends State<ImgRecPage> {
  File _image;
  List _recognitions;
  double _imageHeight;
  double _imageWidth;

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

  @override
  void initState() {
    super.initState();
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
              Container(
                child: _image == null
                    ? Text('No image selected.')
                    : Image.file(_image),
              ),
              Container(
                child: Column(
                    children: _recognitions != null
                        ? _recognitions.map((res) {
                            if (res["confidence"] > 0.5) {
                              return Text(
                                "${res["index"]} - ${res["label"]}: ${res["confidence"].toString()}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  background: Paint()..color = Colors.white,
                                ),
                              );
                            } else
                              return Text("");
                          }).toList()
                        : [Text("Unsuccessful")]),
              )
            ],
          );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: <Widget>[
          Container(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
              child: new RaisedButton(
                onPressed: () {
                  loadModel();
                  getImage();
                },
                child: Text('Start'),
              )),
          Container(
            child: _image == null
                ? Text('No image selected.')
                : Image.file(_image),
          ),
          Container(
            child: Column(
                children: _recognitions != null
                    ? _recognitions.map((res) {
                        if (res["confidence"] > 0.5) {
                          return Text(
                            "${res["index"]} - ${res["label"]}: ${res["confidence"].toString()}",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              background: Paint()..color = Colors.white,
                            ),
                          );
                        } else
                          return Text("");
                      }).toList()
                    : [Text("Unsuccessful")]),
          )
        ],
      )),
    );
  }
}
