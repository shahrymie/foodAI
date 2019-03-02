import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:tflite/tflite.dart';

class Model {
  String _uid,
      _pid,
      _dfid,
      _username,
      _email,
      _photo,
      _gender,
      _date,
      _filename;
  num _age, _height, _weight, _bmr;
  double _cal, _foodcal;
  File _image;
  CollectionReference _profileRef, _dailyFoodRef;
  DocumentReference _userRef;
  Map<String, dynamic> dailyFood;

  void setUser(String id, String name, String email, String photo) async {
    this._uid = id;
    this._username = name;
    this._email = email;
    this._photo = photo;
    _userRef = Firestore.instance.collection('user').document(this._uid);
    _profileRef = Firestore.instance
        .collection('user')
        .document(this._uid)
        .collection('profile');
    _dailyFoodRef = Firestore.instance
        .collection('user')
        .document(this._uid)
        .collection('daily food');
  }

  void setPid(String pid) async {
    this._pid = pid;
  }

  void setDfid(String dpid) async {
    this._dfid = dpid;
  }

  void setGender(String gender) async {
    this._gender = gender;
    _profileRef.document(this._pid).updateData({'Gender': gender});
  }

  void setAge(num age) async {
    this._age = age;
    _profileRef.document(this._pid).updateData({'Age': age});
  }

  void setHeight(num height) async {
    this._height = height;
    _profileRef.document(this._pid).updateData({'Height': height});
  }

  void setWeight(num weight) async {
    this._weight = weight;
    _profileRef.document(this._pid).updateData({'Weight': weight});
  }

  void setBMR() async {
    if (this._gender == "Male") {
      this._bmr =
          (10 * this._weight) + (6.25 * this._height) - (5 * this._age) + 5;
    } else if (this._gender == "Female") {
      this._bmr =
          (10 * this._weight) + (6.25 * this._height) - (5 * this._age) - 161;
    }
    _profileRef.document(this._pid).updateData({'BMR': this._bmr});
    _profileRef.document(this._pid).updateData({'Cal': this._bmr});
  }

  void setProfile() async{
    _profileRef.getDocuments().then((onValue) {
      this._gender = onValue.documents[0].data['Gender'];
      this._age = onValue.documents[0].data['Age'];
      this._height = onValue.documents[0].data['Height'];
      this._weight = onValue.documents[0].data['Weight'];
      this._bmr = onValue.documents[0].data['BMR'];
      this._cal = onValue.documents[0].data['Cal'];
      this._foodcal = onValue.documents[0].data['FoodCal'];
    });
  }

  void _updateCal() async {
    if (getDate() == '0.00') this._foodcal = this._bmr;
  }

  void addFoodCal() async {
    this._foodcal = this._foodcal + 200;
  }

  getId() {
    return this._uid;
  }

  getPid() {
    return this._pid;
  }

  getDfid() {
    return this._dfid;
  }

  getUserName() {
    return this._username;
  }

  getEmail() {
    return this._email;
  }

  getPhoto() {
    return this._photo;
  }

  getGender() {
    return this._gender;
  }

  getAge() {
    return this._age;
  }

  getHeight() {
    return this._height;
  }

  getWeight() {
    return this._weight;
  }

  getBMR() {
    return this._bmr;
  }

  double getCal() {
    _updateCal();
    return this._cal - this._foodcal;
  }

  double getFoodCal() {
    return this._foodcal;
  }

  getImage() {
    return this._image;
  }

  getUrl() {
    return this._filename;
  }

  getProfileRef() {
    return this._profileRef;
  }

  getDailyFoodRef() {
    return this._dailyFoodRef;
  }

  getUserRef() {
    return this._userRef;
  }

  getDate() {
    this._date =
        DateTime.now().hour.toString() + '.' + DateTime.now().minute.toString();
    return this._date;
  }

  Future getCamera() async {
    this._image = await ImagePicker.pickImage(source: ImageSource.camera);
    this._filename = basename(this._image.path);
    _uploadImage();
  }

  Future getGallery() async {
    this._image = await ImagePicker.pickImage(source: ImageSource.gallery);
    this._filename = basename(this._image.path);
    _uploadImage();
  }

  Future _uploadImage() async {
    StorageReference ref = FirebaseStorage.instance.ref().child(this._filename);
    StorageUploadTask upload = ref.putFile(this._image);
    var downUrl = await (await upload.onComplete).ref.getDownloadURL();
    Map<String, dynamic> dailyFood = {
      'Photo': downUrl.toString(),
      'Name': this._filename,
    };
    _dailyFoodRef.add(dailyFood);
  }

  Future getDailyFoodList() async {
    QuerySnapshot _qn = await Firestore.instance
        .collection('user')
        .document(this._uid)
        .collection('daily food')
        .getDocuments();
    return _qn.documents;
  }
}

Model userModel = new Model();
