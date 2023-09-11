import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:on_ways/Providers/User.dart';
import 'package:on_ways/Widgets/userchattile.dart';
import 'package:provider/provider.dart';

class AllFriends extends StatefulWidget {
  const AllFriends({super.key});

  @override
  State<AllFriends> createState() => _AllFriendsState();
}

class _AllFriendsState extends State<AllFriends> {
  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    final _firestore = FirebaseFirestore.instance;
    Users user = Provider.of<Users>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              color: Colors.white,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: const Icon(CupertinoIcons.multiply,
                  color: Colors.grey, size: 30),
            ),
          ),
          centerTitle: true,
          title: Text(
            'All Friends',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          )),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('User-Data')
              .doc(user.id)
              .collection('Friends')
              .orderBy('name')
              .snapshots(),
          builder: (context, userDataSnapshot) {
            if (!userDataSnapshot.hasData) {
              return CircularProgressIndicator();
            }

            final Friends = userDataSnapshot.data?.docs;
            return Container(
              height: MediaQuery.of(context).size.height -
                  AppBar().preferredSize.height, // Constrain height

              child: ListView.builder(
                itemCount: Friends!.length,
                itemBuilder: (context, index) {
                  final friend = Friends[index];
                  final sender = friend['name'];
                  final imageUrl = friend['image'];
                  final senderId = friend.id;
                  final time = friend['time'];

                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: ConversationList(
                      Id: senderId,
                      name: sender,
                      imageUrl: imageUrl,
                      time: time.toDate(),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
    // return Scaffold(
    //     appBar: AppBar(),
    //     body: SafeArea(
    //         child: Column(
    //       children: [
    //         StreamBuilder<QuerySnapshot>(
    //             stream: _firestore
    //                 .collection('User-Data')
    //                 .doc(user.id)
    //                 .collection('Friends')
    //                 .orderBy('name')
    //                 .snapshots(),
    //             builder: (context, userDataSnapshot) {
    //               if (!userDataSnapshot.hasData) {
    //                 return CircularProgressIndicator();
    //               }

    //               final Friends = userDataSnapshot.data?.docs;
    //               List<ConversationList> FriendWidgets = [];
    //               print(1);
    //               for (var Friend in Friends!) {
    //                 final sender = Friend['name'];
    //                 final ImageUrl = Friend['image'];
    //                 //final lastText = message['text'];
    //                 final SenderId = Friend.id;
    //                 final time = Friend['time'];
    //                 print(1);
    //                 FriendWidgets.add(ConversationList(
    //                   Id: SenderId,
    //                   name: sender,
    //                   imageUrl: ImageUrl,
    //                   //   messageText: lastText,
    //                   time: time.toDate(),
    //                 ));

    //                 FriendWidgets.sort((a, b) => a.time.compareTo(b.time));
    //               }
    //               return ListView(
    //                 children: FriendWidgets,
    //                 controller: scrollController,
    //               );
    //             })
    //       ],
    //     )));
  }
}
