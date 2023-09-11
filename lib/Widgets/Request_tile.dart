import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/User.dart';

class FriendRequest extends StatelessWidget {
  FriendRequest(
      {required this.name,
      required this.imageUrl,
      required this.Id,
      required this.time});
  String Id;
  String name;
  DateTime time;

  String imageUrl;

  @override
  Widget build(BuildContext context) {
    Users user = Provider.of<Users>(context, listen: false);
    return Container(
      padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage(imageUrl),
                  maxRadius: 30,
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Container(
                      color: Colors.transparent,
                      child: Text(
                        name,
                        style: TextStyle(fontSize: 16),
                      )),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              final _firestore = FirebaseFirestore.instance;
              _firestore
                  .collection('User-Data')
                  .doc(user.id)
                  .collection('Requests')
                  .doc(Id)
                  .delete();
            },
            child: Container(
                height: 30,
                child: Icon(
                  Icons.cancel_outlined,
                  color: Colors.red,
                  size: 30,
                )),
          ),
          GestureDetector(
            onTap: () {
              final _firestore = FirebaseFirestore.instance;
              _firestore
                  .collection('User-Data')
                  .doc(user.id)
                  .collection('Friends')
                  .doc(Id)
                  .set({
                'author': name,
                'image': imageUrl,
                'time': DateTime.now(),
              });
              _firestore
                  .collection('User-Data')
                  .doc(Id)
                  .collection('Friends')
                  .doc(user.id)
                  .set({
                'author': user.name,
                'image': user.image,
                'time': DateTime.now(),
              });
              _firestore
                  .collection('User-Data')
                  .doc(user.id)
                  .collection('Requests')
                  .doc(Id)
                  .delete();
            },
            child: Container(
                height: 30,
                child: Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 30,
                )),
          ),
        ],
      ),
    );
  }
}
