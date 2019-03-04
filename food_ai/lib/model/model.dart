import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Model {
  String _date;
  List<String> _id =
      List<String>(4); //userID, profileID, dailyFoodID, nutritionID
  List<String> _user = List<String>(3); //Name, Email, Photo
  List<dynamic> _foodInfo =
      List<dynamic>(6); //Name, Calorie, Carb, Fat, Protein, Reference
  List<dynamic> _profile =
      List<dynamic>(6); //Age, BMR, Cal, Gender, Height, Weight
  File _image;
  var _downUrl;
  bool _foodPageState;
  num _serving;
  CollectionReference _profileRef, _dailyFoodRef;
  CollectionReference _nutritionRef;
  Map<String, dynamic> dailyFood;

  setUser(String id, String name, String email, String photo) async {
    _id[0] = id;
    _user[0] = name;
    _user[1] = email;
    _user[2] = photo;
    _profileRef = Firestore.instance
        .collection('user')
        .document(_id[0])
        .collection('profile');
    _dailyFoodRef = Firestore.instance
        .collection('user')
        .document(_id[0])
        .collection('daily food');
    _nutritionRef = Firestore.instance.collection('nutrition');
  }

  getProfileRef() {
    return _profileRef;
  }

  getDailyFoodRef() {
    return _dailyFoodRef;
  }

  getUser(int index) {
    return _user[index];
  }

  setId(int index, String id) async {
    _id[index] = id;
  }

  setProfile(dynamic data, int index, String type) async {
    _profile[index] = data;
    _profileRef.document(_id[1]).updateData({type: data});
    print('profile data: ' + _profile.toList().toString());
  }

  dynamic getProfile(int index) {
    return _profile[index];
  }

  initProfile() async {
    _profileRef.getDocuments().then((onValue) {
      _profile[3] = onValue.documents[0].data['Gender'];
      _profile[0] = onValue.documents[0].data['Age'];
      _profile[4] = onValue.documents[0].data['Height'];
      _profile[5] = onValue.documents[0].data['Weight'];
      _profile[1] = onValue.documents[0].data['BMR'];
      _profile[2] = onValue.documents[0].data['Cal'];
      _id[1] = onValue.documents[0].documentID;
    });
  }

  setBMR() async {
    if (_profile[3] == "Male") {
      _profile[1] =
          (10 * _profile[5]) + (6.25 * _profile[4]) - (5 * _profile[0]) + 5;
    } else if (_profile[3] == "Female") {
      _profile[1] =
          (10 * _profile[5]) + (6.25 * _profile[4]) - (5 * _profile[0]) - 161;
    }
    _profileRef.document(_id[1]).updateData({'BMR': _profile[1]});
  }

  void updateCal(num cal) async {
    _profile[2] = _profile[2] + cal.toDouble();
    _profileRef.document(_id[1]).updateData({'Cal': _profile[2]});
  }

  Future getCamera() async {
    _image = await ImagePicker.pickImage(source: ImageSource.camera);
  }

  Future getGallery() async {
    _image = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  Future uploadImage(String id) async {
    StorageReference ref = FirebaseStorage.instance.ref().child(id);
    StorageUploadTask upload = ref.putFile(_image);
    _downUrl = await (await upload.onComplete).ref.getDownloadURL();
  }

  Future setDailyFood(int serving) async {
    Map<String, dynamic> dailyFood = {
      'Photo': _downUrl.toString(),
      'Name': getNutrition(0),
      'ID': _id[3],
      'Serving': serving,
      'Cal': getNutrition(1) * serving
    };
    _dailyFoodRef.add(dailyFood).then((onValue) {
      _id[2] = onValue.documentID;
    });
  }

  Future deleteDailyFood() async {
    _dailyFoodRef.document(_id[2]).delete();
  }

  Future updateInfo(int serving) async {
    _dailyFoodRef.document(_id[2]).updateData({'Serving': serving});
    _dailyFoodRef
        .document(_id[2])
        .updateData({'Cal': getNutrition(1) * serving});
  }

  Future getDailyFoodList() async {
    QuerySnapshot _qn = await _dailyFoodRef.getDocuments();
    return _qn.documents;
  }

  getServing() {
    _dailyFoodRef.document(_id[2]).get().then((onValue) {
      _serving = onValue.data['Serving'];
    });
  }

  getserve() {
    return _serving;
  }

  setNutrition() {
    _nutritionRef.document(_id[3]).get().then((onValue) {
      _foodInfo[0] = onValue.data["Name"];
      _foodInfo[1] = onValue.data["Calorie"];
      _foodInfo[2] = onValue.data["Carb"];
      _foodInfo[3] = onValue.data["Fat"];
      _foodInfo[4] = onValue.data["Protein"];
      _foodInfo[5] = onValue.data["Reference"];
    });
  }

  getNutrition(int index) {
    return _foodInfo[index];
  }

  setFoodState(bool state) {
    _foodPageState = state;
  }

  setUrl(String url) {
    _downUrl = url;
  }

  getUrl() {
    return _downUrl;
  }

  getImage() {
    return _image;
  }

  getFoodState() {
    return _foodPageState;
  }

  getDate() {
    this._date =
        DateTime.now().hour.toString() + '.' + DateTime.now().minute.toString();
    return _date;
  }
}

Model userModel = new Model();


