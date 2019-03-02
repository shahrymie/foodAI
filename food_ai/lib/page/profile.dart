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
                      userModel.setAge(num.parse(input));
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
                      userModel.setHeight(num.parse(input));
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
                      userModel.setWeight(num.parse(input));
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
                      userModel.setGender(newValueSelected);
                    });
                  },
                  value: userModel.getGender()),
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
                ClipOval(
                  child: Image.network(
                    userModel.getPhoto(),
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  children: <Widget>[
                    SizedBox(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
                        child: Text(
                          userModel.getUserName(),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
                        child: Text(userModel.getEmail(),
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
                  subtitle: Text(userModel.getGender()),
                  trailing: Icon(Icons.edit),
                  onTap: _askGender,
                ),
                ListTile(
                  title: Text('Age'),
                  subtitle: Text(userModel.getAge().toString()),
                  trailing: Icon(Icons.edit),
                  onTap: _askAge,
                ),
                ListTile(
                  title: Text('Height'),
                  subtitle: Text(userModel.getHeight().toString()),
                  trailing: Icon(Icons.edit),
                  onTap: _askHeight,
                ),
                ListTile(
                  title: Text('Weight'),
                  subtitle: Text(userModel.getWeight().toString()),
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
