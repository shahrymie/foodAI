import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_ai/model/model.dart';

class SetupPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  Map<String, dynamic> profile = {
    'Gender': null,
    'Age': null,
    'Height': null,
    'Weight': null,
    'BMR': null,
    'Cal': 0.0,
  };

  @override
  void initState() {
    super.initState();
    userModel.getProfileRef().add(profile);
    userModel.getProfileRef().getDocuments().then((onValue) {
      setState(() {
        userModel.setPid(onValue.documents[0].documentID);
      });
    });
  }

  var genders = ['Male', 'Female'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text("Profile Setup"),
        ),
        body: Center(
            child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              
              Padding(
                  padding: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 15.0),
                  child: DropdownButtonFormField<String>(
                      hint: new Text("Gender"),
                      items: genders.map((String dropDownStringItem) {
                        return DropdownMenuItem<String>(
                          value: dropDownStringItem,
                          child: Text(dropDownStringItem),
                        );
                      }).toList(),
                      onChanged: (String newValueSelected) {
                        setState(() {
                          userModel.setProfile(newValueSelected,3,"Gender");
                        });
                      },
                      value: userModel.getProfile(3),)),
              Padding(
                padding: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 15.0),
                child: TextField(
                    onChanged: (input) {
                      setState(() {
                        userModel.setProfile(num.parse(input),0,"Age");
                      });
                    },
                    decoration:
                        InputDecoration(labelText: 'Age', hintText: 'Year'),
                    keyboardType: TextInputType.datetime),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 15.0),
                child: TextField(
                    onChanged: (input) {
                      setState(() {
                        userModel.setProfile(num.parse(input),4,"Height");
                      });
                    },
                    decoration:
                        InputDecoration(labelText: 'Height', hintText: "cm"),
                    keyboardType: TextInputType.number),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 15.0),
                child: TextField(
                    onChanged: (input) {
                      setState(() {
                        userModel.setProfile(num.parse(input),5,"Weight");
                      });
                    },
                    decoration:
                        InputDecoration(labelText: 'Weight', hintText: 'kg'),
                    keyboardType: TextInputType.number),
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
                  child: new RaisedButton(
                    onPressed: () {
                      userModel.setBMR();
                      Navigator.pop(context);
                      Navigator.popAndPushNamed(context, "navpage");
                    },
                    child: Text('Next'),
                  )),
            ],
          ),
        )));
  }
}
