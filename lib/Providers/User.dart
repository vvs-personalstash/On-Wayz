import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User with ChangeNotifier {
  String id = '';
  String email = '';
  String name = '';
  String image = '';
  int age = 0;
  String PhoneNumber = '';
  String UserName = '';
  GeoPoint Location = GeoPoint(0, 0);
  List<dynamic> chats_id = [];

  void update({required dynamic data}) async {
    final user = await FirebaseAuth.instance.currentUser;
    final _firestore = await FirebaseFirestore.instance;
    id = await user!.uid;
    email = user.email.toString();
    name = user.displayName.toString();
    image = user.photoURL!;
    PhoneNumber = user.phoneNumber!;
    final docRef = _firestore.collection('User-Data').doc(user.uid);
    docRef.get().then((DocumentSnapshot snapshot) {
      dynamic data = snapshot.data();
      Location = data.get('Last Location');
      chats_id = data.get('chats_id');
      UserName = data.get('UserName');
      chats_id = data.get('chats_id');
      age = data.get('age');
    });
    notifyListeners();
  }

  void notify() {
    notifyListeners();
  }
}
