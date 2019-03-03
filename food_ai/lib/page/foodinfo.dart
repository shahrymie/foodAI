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
        padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                    width: 120.0,
                    height: 120.0,
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
                  contentPadding: EdgeInsets.only(top: 15),
                  leading: new Container(
                      width: 40.0,
                      height: 40.0,
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
                  contentPadding: EdgeInsets.only(top: 15),
                  leading: new Container(
                      width: 40.0,
                      height: 40.0,
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
                  contentPadding: EdgeInsets.only(top: 15),
                  leading: new Container(
                      width: 40.0,
                      height: 40.0,
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
                  contentPadding: EdgeInsets.only(top: 15),
                  leading: new Container(
                      width: 40.0,
                      height: 40.0,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          userModel.setDailyFood();
          userModel.updateCal(userModel.getNutrition(2));
          Navigator.pop(context);
        },
        tooltip: 'Save',
        child: Icon(Icons.add),
        heroTag: "btnSave",
      )
    );
    
  }
}
