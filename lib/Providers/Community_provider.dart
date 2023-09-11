import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityPost {
  String id = '';

  String content = '';
  String city = '';
  DateTime date = DateTime.now();
  String author = '';
  String image_url = '';
  List<String> Likes = [];
  bool isLiked = false;
  String author_img = '';
  CommunityPost(
      {required this.id,

      required this.content,
      required this.city,
      required this.date,
      required this.author,
      required this.image_url,
      required this.Likes,
      required this.author_img});
}

class ScreenArguments {
  final CommunityPost data;
  final bool isLiked;

  ScreenArguments({required this.data, required this.isLiked});
}
