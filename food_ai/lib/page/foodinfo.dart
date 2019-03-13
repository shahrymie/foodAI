import 'package:flutter/material.dart';
import 'package:food_ai/model/model.dart';
import 'package:food_ai/page/navigation.dart';
import 'package:url_launcher/url_launcher.dart';

class FoodPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  int _newServing = 1, _oldServing = 1;

  @override
  void initState() {
    super.initState();
    setState(() {
      userModel.getFoodState()
          ? _oldServing = _newServing = 1
          : _oldServing = _newServing = userModel.getserve();
    });
  }

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
                        border: Border.all(
                          color: Colors.black,
                          width: 2.5,
                        ),
                        shape: BoxShape.circle,
                        image: userModel.getFoodState()
                            ? DecorationImage(
                                fit: BoxFit.fill,
                                image: new FileImage(userModel.getImage()))
                            : DecorationImage(
                                fit: BoxFit.fill,
                                image: new NetworkImage(userModel.getUrl())))),
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
                        child: Text(
                          userModel.getNutrition(0).toString(),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    SizedBox(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
                        child: Text(
                          (userModel.getNutrition(1) * _newServing).toString() +
                              " Cal",
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
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.only(top: 15),
                  leading: new Container(
                      child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          _newServing != 1
                              ? setState(() {
                                  _newServing--;
                                })
                              : null;
                        },
                      ),
                      Text(_newServing.toString()),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            _newServing++;
                          });
                        },
                      ),
                    ],
                  )),
                  title: Text('Serving'),
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
                              image: new AssetImage("assets/carb.png")),
                          color: Colors.yellowAccent)),
                  title: Text('Carbohydrates'),
                  trailing: Text(
                      (userModel.getNutrition(2) * _newServing).toString() +
                          " g"),
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
                  trailing: Text(
                      (userModel.getNutrition(3) * _newServing).toString() +
                          " g"),
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
                  trailing: Text(
                      (userModel.getNutrition(4) * _newServing).toString() +
                          " g"),
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
                    child: Text(userModel.getNutrition(5).toString()),
                    onTap: () async {
                      if (await canLaunch(
                          userModel.getNutrition(5).toString())) {
                        await launch(userModel.getNutrition(5).toString());
                      }
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      )),
      floatingActionButton: userModel.getFoodState()
          ? FloatingActionButton(
              onPressed: () {
                userModel.updateCal(userModel.getNutrition(1) * _newServing);
                userModel.setDailyFood(_newServing);
                Navigator.pop(context);
              },
              tooltip: 'Add',
              child: Icon(Icons.add),
              heroTag: "btnAdd",
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: FloatingActionButton(
                    onPressed: () {
                      userModel.updateCal(
                          0 - (userModel.getNutrition(1) * _newServing));
                      userModel.deleteDailyFood();
                      Navigator.pop(context);
                    },
                    tooltip: 'Delete',
                    child: Icon(Icons.delete),
                    heroTag: "btnDelete",
                  ),
                ),
                FloatingActionButton(
                  onPressed: () async {
                    userModel.updateInfo(_newServing);
                    userModel.updateCal(
                        (userModel.getNutrition(1) * _newServing) -
                            (userModel.getNutrition(1) * _oldServing));
                    await new Future.delayed(const Duration(seconds: 1));
                    Navigator.pop(context);
                  },
                  tooltip: 'Save',
                  child: Icon(Icons.save),
                  heroTag: "btnSave",
                ),
              ],
            ),
    );
  }
}
