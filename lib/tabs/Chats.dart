import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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
                  Text(
                    'Chats',
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall!
                        .copyWith(color: Colors.white, fontSize: 14),
                  ),
                  Spacer(),
                  Icon(
                    Icons.people_outline,
                    size: 20,
                    color: Colors.white,
                  ),
                  Text(
                    'Requests',
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall!
                        .copyWith(color: Colors.white, fontSize: 14),
                  ),
                  Spacer(),
                ]),
              ),
              Container(
                margin: EdgeInsets.only(top: dimensions.height * 0.1),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.87),
                    borderRadius: BorderRadius.circular(15)),
                height: dimensions.height * 0.8 - 71,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
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
                                borderSide:
                                    BorderSide(color: Colors.grey.shade100)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
    ;
  }
}
