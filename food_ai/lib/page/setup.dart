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
    'Cal': null,
    'FoodCal': 0.0
  };

  /*Map<String, dynamic> dailyFood = {
    'Photo': null,
    'Name': null,
  };*/

  @override
  void initState() {
    super.initState();
    userModel.getProfileRef().add(profile);
    userModel.getProfileRef().getDocuments().then((onValue) {
      setState(() {
        userModel.setPid(onValue.documents[0].documentID);
      });
    });
    /*userModel.getDailyFoodRef().add(dailyFood);
    userModel.getDailyFoodRef().getDocuments().then((onValue) {
      setState(() {
        userModel.setDfid(onValue.documents[0].documentID);
      });
    });*/
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
                          userModel.setGender(newValueSelected);
                        });
                      },
                      value: userModel.getGender(),)),
              Padding(
                padding: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 15.0),
                child: TextField(
                    onChanged: (input) {
                      setState(() {
                        userModel.setAge(num.parse(input));
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
                        userModel.setHeight(num.parse(input));
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
                        userModel.setWeight(num.parse(input));
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