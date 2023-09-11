import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:on_ways/Networking/chatsclass.dart';
import 'package:on_ways/Providers/User.dart';
import 'package:on_ways/Providers/one-onechats.dart';
import 'package:on_ways/Widgets/Request_tile.dart';
import 'package:on_ways/screens/all_friend.dart';
import 'package:provider/provider.dart';

import '../Widgets/userchattile.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _firestore = FirebaseFirestore.instance;
  final scrollController = ScrollController();
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
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
                  OpenContainer(
                    openElevation: 4,
                    closedElevation: 0,
                    transitionDuration: const Duration(milliseconds: 500),
                    transitionType: ContainerTransitionType.fadeThrough,
                    closedColor: Theme.of(context).scaffoldBackgroundColor,
                    openColor: Colors.white, //const Color(0xFF16161e),
                    middleColor: const Color(0xFFd988a1),
                    closedBuilder: (context, action) => Container(
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
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    openBuilder: (context, action) => AllFriends(),
                  )
                ],
              ),
            ),
          ),
          DefaultTabController(
              length: 2,
              initialIndex: 0,
              child: Stack(children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color.fromARGB(255, 48, 74, 146),
                  ),
                  height: dimensions.height * 0.2,
                  padding: EdgeInsets.only(
                      left: 15, right: 15, bottom: dimensions.height * 0.12),
                  child: TabBar(tabs: [
                    Row(
                      children: [
                        Icon(
                          Icons.chat_outlined,
                          size: 20,
                          color: Colors.white,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          child: Text(
                            'Chats',
                            style: selectedIndex == 0
                                ? Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w300)
                                : Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(color: Colors.grey, fontSize: 15),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.people_alt_outlined,
                          size: 20,
                          color: Colors.white,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          child: Text(
                            'Requests',
                            style: selectedIndex == 1
                                ? Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w300)
                                : Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(color: Colors.grey, fontSize: 15),
                          ),
                        ),
                      ],
                    )
                  ]),
                ),
                Container(
                    margin: EdgeInsets.only(top: dimensions.height * 0.08),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.87),
                        borderRadius: BorderRadius.circular(15)),
                    height: dimensions.height * 0.8 - 71,
                    child: TabBarView(
                      children: [
                        ChatsWidgets(key: PageStorageKey('Chats')),
                        RequestTabs(key: PageStorageKey('Requests')),
                      ],
                    )),
              ]))
        ],
      ),
    );
  }
}

class RequestTabs extends StatefulWidget {
  const RequestTabs({super.key});

  @override
  State<RequestTabs> createState() => _RequestTabsState();
}

class _RequestTabsState extends State<RequestTabs>
    with AutomaticKeepAliveClientMixin<RequestTabs> {
  final scrollController = ScrollController();
  final _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    Users user = Provider.of<Users>(context, listen: false);
    return StreamBuilder<QuerySnapshot>(
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
            print(101);
            RequestWidgets.add(FriendRequest(
              Id: Id,
              name: sender,
              imageUrl: ImageUrl,
              time: time.toDate(),
            ));

            RequestWidgets.sort((a, b) => a.time.compareTo(b.time));
          }
          return ListView(
            children: RequestWidgets,
            controller: scrollController,
          );
        });
  }

  @override
  bool get wantKeepAlive => true;
}

class ChatsWidgets extends StatefulWidget {
  ChatsWidgets({super.key});

  @override
  State<ChatsWidgets> createState() => _ChatsWidgetsState();
}

class _ChatsWidgetsState extends State<ChatsWidgets>
    with AutomaticKeepAliveClientMixin<ChatsWidgets> {
  @override
  bool get wantKeepAlive => true;
  var stream;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    var dimensions = MediaQuery.of(context).size;
    final _firestore = FirebaseFirestore.instance;
    final scrollController = ScrollController();
    Users user = Provider.of<Users>(context, listen: false);
    return Column(children: [
      Container(
        height: dimensions.height * 0.13,
        width: dimensions.width,
        child: Padding(
          padding: EdgeInsets.only(top: 16, left: 16, right: 16),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search...",
              hintStyle: TextStyle(color: Colors.grey.shade600),
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
                  borderSide: BorderSide(color: Colors.grey.shade100)),
            ),
          ),
        ),
      ),
      Expanded(
        child: StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('User-Data')
                .doc(user.id)
                .collection('Previous_Chats')
                .orderBy('time')
                .snapshots(),
            builder: (context, userDataSnapshot) {
              if (!userDataSnapshot.hasData) {
                return CircularProgressIndicator();
              }

              final conversations = userDataSnapshot.data?.docs;
              List<ConversationList> ConvoWidgets = [];
              print(1);
              for (var message in conversations!) {
                final sender = message['author'];
                final ImageUrl = message['image'];
                //final lastText = message['text'];
                final SenderId = message['Id'];
                final time = message['time'];
                print(1);
                ConvoWidgets.add(ConversationList(
                  Id: SenderId,
                  name: sender,
                  imageUrl: ImageUrl,
                  //   messageText: lastText,
                  time: time.toDate(),
                ));

                ConvoWidgets.sort((a, b) => a.time.compareTo(b.time));
              }
              return ListView(
                children: ConvoWidgets,
                controller: scrollController,
              );
            }),
      )
    ]);
  }
}
