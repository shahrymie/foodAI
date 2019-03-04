import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:food_ai/api/google.dart';
import 'package:food_ai/model/model.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: SingleChildScrollView(
                child: Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
          child: new Image.asset("assets/logo.png"),
        ),
        Container(
          padding: EdgeInsets.only(top: 30),
          child: SignInButton(Buttons.Google, onPressed: () {
            authService.googleSignIn();
            FirebaseAuth.instance.currentUser().then((user) {
              setState(() {
                userModel.setUser(
                    user.uid, user.displayName, user.email, user.photoUrl);
                userModel.initProfile();
                userModel.getProfileRef().getDocuments().then((datasnapshot) {
                  if (datasnapshot.documents.isNotEmpty)
                    Navigator.popAndPushNamed(context, "navpage");
                  else
                    Navigator.pushNamed(context, "setuppage");
                });
              });
            });
          }),
        ),
        Container(
          padding: EdgeInsets.only(top: 30),
          child: SignInButton(
            Buttons.Facebook,
            onPressed: () {
              Navigator.popAndPushNamed(context, "navpage");
            },
          ),
        ),
      ],
    ))));
  }
}
