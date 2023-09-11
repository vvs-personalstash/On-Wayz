import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chats {
  String id = '';
  String chatter = '';
  String image_url = '';
  String herotag = '';
  String UserId = '';

  Chats({
    required this.id,
    required this.UserId,
    required this.chatter,
    required this.herotag,
    required this.image_url,
  });
}
