import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Model {
  String _uid,
      _pid,
      _dfid,
      _username,
      _email,
      _photo,
      _date,
      _filename;   
  List<dynamic> _foodInfo = List<dynamic>(7);
  List<dynamic> _profile = List<dynamic>(6);
  File _image;
  var _downUrl; 
  CollectionReference _profileRef, _dailyFoodRef;
  DocumentReference _userRef;
  Map<String, dynamic> dailyFood;

  setUser(String id, String name, String email, String photo) async {
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

  setPid(String pid) async {
    this._pid = pid;
  }

  setDfid(String dpid) async {
    this._dfid = dpid;
  }

  setProfile(dynamic data, int index, String type) async{
    this._profile[index] = data;
    _profileRef.document(this._pid).updateData({type: data});
  }

  setFileName(String filename) {
    this._filename = filename;
  }

  setBMR() async {
    if (_profile[3] == "Male") {
      _profile[1] =
          (10 * _profile[5] ) + (6.25 * _profile[4] ) - (5 * _profile[0] ) + 5;
    } else if (_profile[3] == "Female") {
      _profile[1] =
          (10 * _profile[5] ) + (6.25 * _profile[4] ) - (5 * _profile[0] ) - 161;
    }
    _profileRef.document(this._pid).updateData({'BMR': _profile[1] });
  }

  initProfile() async {
    _profileRef.getDocuments().then((onValue) {
      this._profile[3] = onValue.documents[0].data['Gender'];
      this._profile[0] = onValue.documents[0].data['Age'];
      this._profile[4] = onValue.documents[0].data['Height'];
      this._profile[5] = onValue.documents[0].data['Weight'];
      this._profile[1] = onValue.documents[0].data['BMR'];
      this._profile[2] = onValue.documents[0].data['Cal'];
    });
  }

  setNutrition() {
    Firestore.instance
        .collection('nutrition')
        .document(userModel.getFileName())
        .get()
        .then((onValue) {
      this._foodInfo[0] = onValue.data["Name"];
      this._foodInfo[1] = onValue.data["Serving"];
      this._foodInfo[2] = onValue.data["Calorie"];
      this._foodInfo[3] = onValue.data["Carb"];
      this._foodInfo[4] = onValue.data["Fat"];
      this._foodInfo[5] = onValue.data["Protein"];
      this._foodInfo[6] = onValue.data["Reference"];
    }).whenComplete(() {
      print('set done');
    });
  }

  void updateCal(num cal) async {
    if (getDate() == '0.00') this._profile[2] = 0.0;
    else this._profile[2] = this._profile[2]+cal;
    _profileRef.document(this._pid).updateData({'Cal': this._profile[2]});
  }

  dynamic getProfile(int index){
    return _profile[index];
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

  double getDailyCalorie() {
    return _profile[1]- _profile[2];
  }

  File getImage() {
    return this._image;
  }

  getUrl() {
    return this._filename;
  }

  getFileName() {
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
  }

  Future getGallery() async {
    this._image = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  Future uploadImage() async {
    StorageReference ref = FirebaseStorage.instance.ref().child(this._filename);
    StorageUploadTask upload = ref.putFile(this._image);
    this._downUrl = await (await upload.onComplete).ref.getDownloadURL();
  }

  Future setDailyFood() async{
    Map<String, dynamic> dailyFood = {
      'Photo': _downUrl.toString(),
      'Name': getNutrition(0),
      'ID': this._filename,
      'Serving': 1,
      'Cal':getNutrition(2)
    };
    _dailyFoodRef.add(dailyFood).then((onValue) {
      this._dfid = onValue.documentID;
    });
  }

  Future getDailyFoodList() async {
    QuerySnapshot _qn = await _dailyFoodRef
        .getDocuments();
    return _qn.documents;
  }

  getNutrition(int index) {
    return _foodInfo[index];
  }
}

Model userModel = new Model();
