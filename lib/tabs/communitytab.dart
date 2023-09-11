import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:on_ways/Providers/Community_provider.dart';
import 'package:on_ways/Widgets/blogcard.dart';
import 'package:on_ways/Widgets/custom_appbar.dart';
import 'package:on_ways/screens/AddCommunityPost.dart';

class CommunityTab extends StatefulWidget {
  const CommunityTab({super.key});

  @override
  State<CommunityTab> createState() => _CommunityTabState();
}

class _CommunityTabState extends State<CommunityTab> {
  bool isLoading = true;
  List<dynamic> data = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  }

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    final _firestore = FirebaseFirestore.instance;
    var dimensions = MediaQuery.of(context).size;
    final _auth = FirebaseAuth.instance;
    debugPrint('community rebuild');
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.white.withOpacity(0.6),
          leadingWidth: 10,
          titleSpacing: 5,
          elevation: 0,
          title: Padding(
            padding: EdgeInsets.only(left: 8, right: 8, top: 10, bottom: 10),
            child: Text(
              "Feeds",
              style: TextStyle(
                  fontSize: 20 * dimensions.height / 632,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          actions: [
            OpenContainer(
              closedElevation: 0,
              transitionDuration: const Duration(milliseconds: 500),
              transitionType: ContainerTransitionType.fadeThrough,
              closedColor: Theme.of(context).scaffoldBackgroundColor,
              openColor: Colors.white, //const Color(0xFF16161e),
              middleColor: const Color(0xFFd988a1),
              closedBuilder: (context, action) => Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 8, right: 8, top: 10, bottom: 10),
                  child: Container(
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
                ),
              ),
              openBuilder: (context, action) => AddCommunityPostScreen(),
            ),
          ],
        ),
        body: SafeArea(
            child: Column(children: [
          StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('feed').orderBy('time').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                  );
                }

                final postdata = snapshot.data?.docs;
                List<BlogCard> FeedWidgets = [];
                for (var data in postdata!) {
                  CommunityPost post = CommunityPost(
                      id: data.id,
                      Likes: List<String>.from(data['Likes']),
                      author: data['author'],
                      date: data['time'].toDate(),
                      city: data['location'],
                      content: data['content'],
                      image_url: data['img'],
                      author_img: data['author_img']);
                  final time = data['time'].toDate();
                  FeedWidgets.add(BlogCard(
                    receivedData: post,
                    time: time,
                  ));

                  FeedWidgets.sort((a, b) => a.time.compareTo(b.time));
                }
                return Expanded(
                  child: ListView(
                    padding: EdgeInsets.only(bottom: 10),
                    children: FeedWidgets,
                    controller: scrollController,
                  ),
                );
              }),
        ])));
  }
}
