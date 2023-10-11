import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:on_ways/Providers/User.dart';
import 'package:on_ways/Providers/one-onechats.dart';
import 'dart:async';
import 'package:on_ways/utilities/snackbar.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  static String id = 'chatscreen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final scrollController = ScrollController();
  final messageController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late String message;
  late User loggedInUser;
  String LastMessageUser = 'abc';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    // messageStream();
  }

  // void getMessages() async {
  //   print(1);
  //   final messaages = await _firestore.collection('common-room').get();
  //   for (var message in messaages.docs) {
  //     print(message);
  //   }
  // }
  // void messageStream() async {
  //   print(1);
  //   await for (var snapshots
  //       in _firestore.collection('common-room').snapshots()) {
  //     for (var message in snapshots.docs) {
  //       print(message.data());
  //     }
  //   }
  // }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  void scrollToBottom() {
    Timer _timer = Timer(Duration(seconds: 1), () {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 1),
        curve: Curves.easeOut,
      );
    });
  }

  bool first_message = false;
  @override
  Widget build(BuildContext context) {
    Users users = Provider.of<Users>(context, listen: false);
    final args = ModalRoute.of(context)!.settings.arguments as Chats;
    var dimensions = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        leadingWidth: 70,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 248, 149, 184),
                borderRadius: BorderRadius.circular(5)),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
          ),
        ),
        centerTitle: true,
        title: Row(
          children: [
            Hero(
              tag: args.herotag,
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                        image: NetworkImage(args.image_url),
                        fit: BoxFit.cover)),
                height: dimensions.height * 0.08,
                width: dimensions.height * 0.08,
              ),
            ),
            SizedBox(width: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 10,
                ),
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 10),
                      child: Text(
                        args.chatter,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20 * dimensions.height / 700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.circle,
                      color: Colors.green,
                      size: 5,
                    )
                  ],
                ),
                SizedBox(width: 10),
                Container(
                  padding: EdgeInsets.only(right: 10),
                  child: Text('Online Now',
                      style: TextStyle(color: Colors.grey, fontSize: 15)),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Expanded(
                  child: Divider(
                    indent: 20.0,
                    endIndent: 10.0,
                    thickness: 1,
                  ),
                ),
                Text(
                  "INTRODUCE YOURSELF",
                  style: TextStyle(
                      color: Color.fromARGB(158, 92, 103, 109),
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
                Expanded(
                  child: Divider(
                    indent: 10.0,
                    endIndent: 20.0,
                    thickness: 1,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('chats')
                    .doc(args.id)
                    .collection('userchats')
                    .orderBy('time')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    first_message = true;
                    return const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.lightBlueAccent,
                      ),
                    );
                  }
                  first_message = false;
                  scrollToBottom();
                  final messages = snapshot.data?.docs;
                  List<MessageBubble> messageWidgets = [];
                  for (var message in messages!) {
                    final chatMessage = message['text'];
                    final sender = message['sender'];
                    final time = message['time'];
                    messageWidgets.add(MessageBubble(
                      text: chatMessage,
                      Sender: sender,
                      isLastSender: LastMessageUser == sender,
                      isMe: users.name == sender,
                      time: time.toDate(),
                    ));

                    messageWidgets.sort((a, b) => a.time.compareTo(b.time));
                    LastMessageUser = message['sender'];
                  }
                  return Expanded(
                      child: ListView(
                    children: messageWidgets,
                    controller: scrollController,
                  ));
                }),
            Container(
              padding: EdgeInsets.only(top: 1, left: 10, right: 10, bottom: 1),
              margin: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0),
                  border: Border.all(color: Colors.grey.shade400)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: messageController,
                      onChanged: (value) {
                        message = value;
                        //Do something with the user input.
                      },
                      decoration: InputDecoration(
                          hintText: "Message...",
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          border: InputBorder.none),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 245, 121, 164),
                        shape: BoxShape.circle),
                    child: InkWell(
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                      onTap: () {
                        scrollController.animateTo(
                          scrollController.position.maxScrollExtent,
                          duration: Duration(seconds: 1),
                          curve: Curves.easeOut,
                        );
                        if (first_message == true) {
                          _firestore
                              .collection('User-Data')
                              .doc(users.id)
                              .collection('Previous_Chats')
                              .add({
                            'Id': args.UserId,
                            'author': args.chatter,
                            'image': args.image_url,
                            'time': DateTime.now(),
                          });
                          _firestore
                              .collection('User-Data')
                              .doc(args.UserId)
                              .collection('Previous_Chats')
                              .add({
                            'Id': users.id,
                            'author': users.name,
                            'image': users.image,
                            'time': DateTime.now(),
                          });
                        }
                        messageController.clear();
                        _firestore
                            .collection('chats')
                            .doc(args.id)
                            .collection('userchats')
                            .add({
                          'text': message,
                          'sender': users.name,
                          'time': DateTime.now()
                        });
                        LastMessageUser = 'abc';
                        //Implement send functionality.
                      },
                    ),
                  )

                  // MaterialButton(
                  //   onPressed: () {
                  //     scrollController.animateTo(
                  //       scrollController.position.maxScrollExtent,
                  //       duration: Duration(seconds: 1),
                  //       curve: Curves.easeOut,
                  //     );
                  //     messageController.clear();
                  //     _firestore
                  //         .collection('chats')
                  //         .doc(args.id)
                  //         .collection('userchats')
                  //         .add({
                  //       'text': message,
                  //       'sender': users.name,
                  //       'time': DateTime.now()
                  //     });
                  //     LastMessageUser = 'abc';
                  //     //Implement send functionality.
                  //   },
                  //   child: Text(
                  //     'Send',
                  //     style: kSendButtonTextStyle,
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble(
      {required this.text,
      required this.Sender,
      required this.isLastSender,
      required this.isMe,
      required this.time});
  String text;
  String Sender;
  bool isMe;
  bool isLastSender;
  DateTime time;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 14, right: 14, top: 5, bottom: 5),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          !isLastSender
              ? Text(
                  Sender,
                  style: TextStyle(fontSize: 12.0, color: Colors.black54),
                )
              : Container(),
          Material(
            borderRadius: isLastSender
                ? isMe
                    ? BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0))
                    : BorderRadius.only(
                        topRight: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0))
                : isMe
                    ? BorderRadius.only(
                        bottomRight: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0),
                        topLeft: Radius.circular(20.0))
                    : BorderRadius.only(
                        topRight: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0)),
            color: isMe ? Color(0xFF1d2d59) : Colors.white,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black,
                  fontSize: 12.0,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
            width: 60.0,
            child: Container(
              padding: EdgeInsets.only(top: 2),
              alignment: isMe
                  ? AlignmentDirectional.bottomEnd
                  : AlignmentDirectional.bottomStart,
              child: Text(
                '${DateFormat('hh:mm a').format(time)}',
                style: TextStyle(color: Colors.black45, fontSize: 7.0),
              ),
            ),
          )
        ],
      ),
    );
  }
}
