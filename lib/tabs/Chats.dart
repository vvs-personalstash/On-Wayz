import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:on_ways/Networking/chatsclass.dart';
import 'package:on_ways/Providers/User.dart';
import 'package:on_ways/Widgets/Request_tile.dart';
import 'package:provider/provider.dart';

import '../Widgets/userchattile.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<ChatUsers> chatUsers = [
    ChatUsers(
        name: "Jane Russel",
        text: "Awesome Setup",
        image: "images/userImage1.jpeg",
        time: "Now"),
    ChatUsers(
        name: "Glady's Murphy",
        text: "That's Great",
        image: "images/userImage2.jpeg",
        time: "Yesterday"),
    ChatUsers(
        name: "Jorge Henry",
        text: "Hey where are you?",
        image: "images/userImage3.jpeg",
        time: "31 Mar"),
    ChatUsers(
        name: "Philip Fox",
        text: "Busy! Call me in 20 mins",
        image: "images/userImage4.jpeg",
        time: "28 Mar"),
    ChatUsers(
        name: "Debra Hawkins",
        text: "Thankyou, It's awesome",
        image: "images/userImage5.jpeg",
        time: "23 Mar"),
    ChatUsers(
        name: "Jacob Pena",
        text: "will update you in evening",
        image: "images/userImage6.jpeg",
        time: "17 Mar"),
    ChatUsers(
        name: "Andrey Jones",
        text: "Can you please share the file?",
        image: "images/userImage7.jpeg",
        time: "24 Feb"),
    ChatUsers(
        name: "John Wick",
        text: "How are you?",
        image: "images/userImage8.jpeg",
        time: "18 Feb"),
  ];
  bool SelectedValue = false; //true for chats false for requests
  final _firestore = FirebaseFirestore.instance;
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    Users user = Provider.of<Users>(context, listen: false);
    var dimensions = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 8, right: 8, top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "Conversations",
                      style: TextStyle(
                          fontSize: 20 * dimensions.height / 632,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.pink[50],
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.add,
                          color: Colors.pink,
                          size: 20,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text(
                          "Add New",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color.fromARGB(255, 48, 74, 146),
                ),
                height: dimensions.height * 0.2,
                padding: EdgeInsets.only(
                    left: 15, right: 15, bottom: dimensions.height * 0.12),
                child: Row(children: [
                  Spacer(),
                  Icon(
                    Icons.chat_outlined,
                    size: 20,
                    color: Colors.white,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        SelectedValue = true;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 15),
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Chats',
                        style: SelectedValue
                            ? Theme.of(context).textTheme.labelSmall!.copyWith(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w300)
                            : Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(color: Colors.grey, fontSize: 15),
                      ),
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.people_outline,
                    size: 20,
                    color: Colors.white,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        SelectedValue = false;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 15),
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Requests',
                        style: SelectedValue == false
                            ? Theme.of(context).textTheme.labelSmall!.copyWith(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w300)
                            : Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(color: Colors.grey, fontSize: 15),
                      ),
                    ),
                  ),
                  Spacer(),
                ]),
              ),
              Container(
                margin: EdgeInsets.only(top: dimensions.height * 0.08),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.87),
                    borderRadius: BorderRadius.circular(15)),
                height: dimensions.height * 0.8 - 71,
                child: SelectedValue
                    ? SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(top: 16, left: 16, right: 16),
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Search...",
                                  hintStyle:
                                      TextStyle(color: Colors.grey.shade600),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Colors.grey.shade600,
                                    size: 20,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                  contentPadding: EdgeInsets.all(8),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade100)),
                                ),
                              ),
                            ),
                            ListView.builder(
                              itemCount: chatUsers.length,
                              shrinkWrap: true,
                              padding: EdgeInsets.only(top: 16),
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return ConversationList(
                                  name: chatUsers[index].name,
                                  messageText: chatUsers[index].text,
                                  imageUrl: chatUsers[index].image,
                                  time: chatUsers[index].time,
                                  isMessageRead:
                                      (index == 0 || index == 3) ? true : false,
                                );
                              },
                            )
                          ],
                        ),
                      )
                    : StreamBuilder<QuerySnapshot>(
                        stream: _firestore
                            .collection('User-Data')
                            .doc(user.id)
                            .collection('Requests')
                            .orderBy('time')
                            .snapshots(),
                        builder: (context, userDataSnapshot) {
                          if (!userDataSnapshot.hasData) {
                            return CircularProgressIndicator();
                          }

                          final requests = userDataSnapshot.data?.docs;
                          List<FriendRequest> RequestWidgets = [];
                          print(1);
                          for (var message in requests!) {
                            final sender = message['author'];
                            final ImageUrl = message['image'];
                            final Id = message.id;
                            final time = message['time'];
                            print(1);
                            RequestWidgets.add(FriendRequest(
                              Id: Id,
                              name: sender,
                              imageUrl: ImageUrl,
                              time: time.toDate(),
                            ));

                            RequestWidgets.sort(
                                (a, b) => a.time.compareTo(b.time));
                          }
                          return ListView(
                            children: RequestWidgets,
                            controller: scrollController,
                          );
                        }),
              ),
            ],
          )
        ],
      ),
    );
  }
}
