import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityPost {
  String id = '';
  String title = '';
  String content = '';
  String city = '';
  DateTime date = DateTime.now();
  String author = '';
  String image_url = '';
  List<String> Likes = [];
  CommunityPost(
      {required this.id,
      required this.title,
      required this.content,
      required this.city,
      required this.date,
      required this.author,
      required this.image_url,
      required this.Likes});
}
