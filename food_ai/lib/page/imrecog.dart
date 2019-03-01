import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_ai/model/model.dart';

import 'package:tflite/tflite.dart';

const String mobile = "MobileNet";
const String ssd = "SSD MobileNet";
const String yolo = "Tiny YOLOv2";

class ImgRecPage extends StatefulWidget {
  @override
  _ImgRecPageState createState() => new _ImgRecPageState();
}

class _ImgRecPageState extends State<ImgRecPage> {
  File _image;
  List _recognitions;
  String res;
  double _imageHeight;
  double _imageWidth;

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
    loadModel();
    getImage();
  }

  Future loadModel() async {
   
      this.res = await Tflite.loadModel(
            model: "assets/optimized_graph.tflite",
            labels: "assets/retrained_label.txt",
          );
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('tflite example app'),
      ),
      body:  Stack(
              children: <Widget>[
                Container(
                  child: _image == null
                      ? Text('No image selected.')
                      : Image.file(_image),
                ),
                Center(
                        child: Column(
                          children: _recognitions.map((res) {
                                  return Text(
                                    "${res["index"]} - ${res["label"]}: ${res["confidence"].toString()}",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20.0,
                                      background: Paint()..color = Colors.white,
                                    ),
                                  );
                                }).toList()
                        ),
                      )
              ],
            ),
    );
  }
}
