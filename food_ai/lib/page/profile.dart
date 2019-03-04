import 'package:flutter/material.dart';
import 'package:food_ai/model/model.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var genders = ['Male', 'Female'];

  Future<Null> _askAge() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding: EdgeInsets.all(15.0),
            title: new Text('Input Current Age'),
            children: <Widget>[
              TextField(
                  onChanged: (input) {
                    setState(() {
                      userModel.setProfile(num.parse(input), 0, "Age");
                    });
                  },
                  decoration:
                      InputDecoration(labelText: 'Age', hintText: 'Year'),
                  keyboardType: TextInputType.number),
              RaisedButton(
                onPressed: () {
                  userModel.setBMR();
                  Navigator.pop(context);
                },
                child: Text('Submit'),
              )
            ],
          );
        });
  }

  Future<Null> _askHeight() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding: EdgeInsets.all(15.0),
            title: new Text('Input Current Height'),
            children: <Widget>[
              TextField(
                  onChanged: (input) {
                    setState(() {
                      userModel.setProfile(num.parse(input), 4, "Height");
                    });
                  },
                  decoration:
                      InputDecoration(labelText: 'Height', hintText: 'cm'),
                  keyboardType: TextInputType.number),
              RaisedButton(
                onPressed: () {
                  userModel.setBMR();
                  Navigator.pop(context);
                },
                child: Text('Submit'),
              )
            ],
          );
        });
  }

  Future<Null> _askWeight() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding: EdgeInsets.all(15.0),
            title: new Text('Input Latest Weight'),
            children: <Widget>[
              TextField(
                  onChanged: (input) {
                    setState(() {
                      userModel.setProfile(num.parse(input), 5, "Weight");
                    });
                  },
                  decoration:
                      InputDecoration(labelText: 'Weight', hintText: 'Kg'),
                  keyboardType: TextInputType.number),
              RaisedButton(
                onPressed: () {
                  userModel.setBMR();
                  Navigator.pop(context);
                },
                child: Text('Submit'),
              )
            ],
          );
        });
  }

  Future<Null> _askGender() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding: EdgeInsets.all(15.0),
            title: new Text('Input new age'),
            children: <Widget>[
              DropdownButtonFormField<String>(
                  hint: new Text("Gender"),
                  items: genders.map((String dropDownStringItem) {
                    return DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      child: Text(dropDownStringItem),
                    );
                  }).toList(),
                  onChanged: (String newValueSelected) {
                    setState(() {
                      userModel.setProfile(newValueSelected, 3, "Gender");
                    });
                  },
                  value: userModel.getProfile(3)),
              RaisedButton(
                onPressed: () {
                  userModel.setBMR();
                  Navigator.pop(context);
                },
                child: Text('Submit'),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text('User Profile'),
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
                    width: 100.0,
                    height: 100.0,
                    decoration: new BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 2.5,
                        ),
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: new NetworkImage(userModel.getUser(2))))),
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
                        child: Text(
                          userModel.getUser(0),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
                        child: Text(userModel.getUser(1),
                            textAlign: TextAlign.right)),
                  ],
                ),
              ],
            ),
            ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(0, 25, 10, 10),
              children: <Widget>[
                ListTile(
                  title: Text('Gender'),
                  subtitle: Text(userModel.getProfile(3)),
                  trailing: Icon(Icons.edit),
                  onTap: _askGender,
                ),
                ListTile(
                  title: Text('Age'),
                  subtitle: Text(userModel.getProfile(0).toString()),
                  trailing: Icon(Icons.edit),
                  onTap: _askAge,
                ),
                ListTile(
                  title: Text('Height'),
                  subtitle: Text(userModel.getProfile(4).toString()),
                  trailing: Icon(Icons.edit),
                  onTap: _askHeight,
                ),
                ListTile(
                  title: Text('Weight'),
                  subtitle: Text(userModel.getProfile(5).toString()),
                  trailing: Icon(Icons.edit),
                  onTap: _askWeight,
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}
