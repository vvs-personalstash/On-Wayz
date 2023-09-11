import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Users with ChangeNotifier {
  String id = '';
  String email = '';
  String name = '';
  String image = '';
  String age = '';
  String PhoneNumber = '';
  String UserName = '';
  GeoPoint Location = GeoPoint(0, 0);
  List<dynamic> chats_id = [];
  void updateDetails() async {
    final user = await FirebaseAuth.instance.currentUser;
    print(user);
    final _firestore = await FirebaseFirestore.instance;
    id = await user!.uid;
    email = user.email.toString();
    name = user.displayName.toString();
    PhoneNumber = user.phoneNumber.toString();

    final docRef = _firestore.collection('User-Data').doc(id);
    try {
      DocumentSnapshot snapshot = await docRef.get();
      if (snapshot.exists) {
        dynamic data = snapshot.data();
        print(111);
        print(111);
        chats_id = data['chats_id'] ?? [];
        UserName = data['UserName'];
        age = data['age'];
        image = data['Photo'];
        Location = data['Last Location']['geopoint'];
        print(1111);
        notifyListeners();
      } else {
        print("Document does not exist");
      }
    } catch (e) {
      print("Error retrieving document: $e");
    }
  }

  void notify() {
    notifyListeners();
  }
}
