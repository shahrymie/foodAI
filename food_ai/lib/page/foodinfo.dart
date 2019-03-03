import 'package:flutter/material.dart';
import 'package:food_ai/model/model.dart';
import 'package:url_launcher/url_launcher.dart';

class FoodPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("Food Information"),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.fromLTRB(20, 30, 0, 30),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                    width: 130.0,
                    height: 130.0,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: new FileImage(userModel.getImage())))),
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
                        child: Text(
                          userModel.getNutritionList()[0].toString(),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    SizedBox(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
                        child: Text(
                          userModel.getNutrition(2).toString() + " Cal",
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(0, 25, 10, 10),
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.only(top: 20),
                  leading: new Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: new AssetImage("assets/carb.png")),
                          color: Colors.yellowAccent)),
                  title: Text('Carbohydrates'),
                  trailing: Text(userModel.getNutrition(3).toString() + " g"),
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(top: 20),
                  leading: new Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: new AssetImage("assets/fat.png")),
                          color: Colors.orangeAccent)),
                  title: Text('Fats'),
                  trailing: Text(userModel.getNutrition(4).toString() + " g"),
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(top: 20),
                  leading: new Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: new AssetImage("assets/protein.png")),
                          color: Colors.white70)),
                  title: Text('Protein'),
                  trailing: Text(userModel.getNutrition(5).toString() + " g"),
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(top: 20),
                  leading: new Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: new AssetImage("assets/info.png")),
                          color: Colors.blueAccent)),
                  title: Text('Reference'),
                  subtitle: InkWell(
                    child: Text(userModel.getNutrition(6).toString()),
                    onTap: () async {
                      if (await canLaunch(
                          userModel.getNutrition(6).toString())) {
                        await launch(userModel.getNutrition(6).toString());
                      }
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      )),
    );
    /*FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        tooltip: 'Camera',
        child: Icon(Icons.add_circle),
        mini: true,
        heroTag: "btnCamera",
      );*/
  }
}
