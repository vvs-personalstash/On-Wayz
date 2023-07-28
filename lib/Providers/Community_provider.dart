import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityPost with ChangeNotifier {
  String id = '';
  String title = '';
  String content = '';
  String city = '';
  DateTime date = DateTime.now();
  String student = '';
  String image_url = '';
  int upvotes = 0;
  List<String> Bookmarks = [];
  List<String> Likes = [];
  CommunityPost();

  toggleBookMark(String studentId) {
    if (Bookmarks.contains(studentId)) {
      Bookmarks.remove(studentId);
    } else {
      Bookmarks.add(studentId);
    }
    var db = FirebaseFirestore.instance;
    db.collection('feed').doc('feeds').update({'bookmarks': Bookmarks});
    notifyListeners();
  }

  toggleLike(String studentId) {
    if (Likes.contains(studentId)) {
      Likes.remove(studentId);
      upvotes = upvotes - 1;
    } else {
      Likes.add(studentId);
      upvotes = upvotes + 1;
    }
    var db = FirebaseFirestore.instance;
    db.collection('feed').doc('feeds').update({'likes': Likes});
    notifyListeners();
  }
}
