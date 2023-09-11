import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:on_ways/Providers/User.dart';
import 'package:on_ways/screens/chatscreen.dart';
import 'package:on_ways/Providers/one-onechats.dart';
import 'package:provider/provider.dart';

class ConversationList extends StatefulWidget {
  ConversationList({
    required this.name,
    // required this.messageText,
    required this.imageUrl,
    required this.time,
    required this.Id,
  });
  String name;
  // String messageText;
  String imageUrl;
  DateTime time;
  String Id;

  @override
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  @override
  Widget build(BuildContext context) {
    Users user = Provider.of<Users>(context, listen: false);
    String chatId = widget.Id.hashCode > user.id.hashCode
        ? '${widget.Id}-${user.id}'
        : '${user.id}-${widget.Id}';
    print(user.id);
    return GestureDetector(
      onTap: () {
        final _firestore = FirebaseFirestore.instance;
        final chat_credentials = _firestore.collection('chats').doc(chatId);
        debugPrint(user.email);

        chat_credentials.get().then((docSnapshot) => {
              if (docSnapshot.exists)
                {
                  Navigator.pushNamed(context, ChatScreen.id,
                      arguments: Chats(
                          UserId: widget.Id,
                          chatter: widget.name,
                          herotag: widget.Id,
                          id: chatId,
                          image_url: widget.imageUrl)),
                }
              else
                {
                  chat_credentials.set({'created': true}),
                  Navigator.pushNamed(context, ChatScreen.id,
                      arguments: Chats(
                          UserId: widget.Id,
                          chatter: widget.name,
                          herotag: widget.Id,
                          id: chatId,
                          image_url: widget.imageUrl))
                }
            });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: Colors.black12, width: 1.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 10,
              )
            ]),
        padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Hero(
                    tag: widget.Id,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(widget.imageUrl),
                      maxRadius: 30,
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.name,
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          // Text(
                          //   widget.messageText,
                          //   style: TextStyle(
                          //       fontSize: 13,
                          //       color: Colors.grey.shade600,
                          //       fontWeight: FontWeight.normal),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${widget.time.hour}:${widget.time.minute}',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
