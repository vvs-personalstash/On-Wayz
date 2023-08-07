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
    final _auth = FirebaseAuth.instance;
    debugPrint('community rebuild');
    return Scaffold(
        appBar: AppBar(title: Text('Community Feed')),
        floatingActionButton: OpenContainer(
          transitionDuration: const Duration(milliseconds: 500),
          transitionType: ContainerTransitionType.fadeThrough,
          closedShape: const CircleBorder(),
          closedColor: const Color(0xFF50559a),
          openColor: Theme.of(context)
              .scaffoldBackgroundColor, //const Color(0xFF16161e),
          middleColor: const Color(0xFFd988a1),
          closedBuilder: (context, action) => Container(
            margin: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF50559a),
            ),
            child: const Icon(
              Icons.add,
              size: 25,
              color: Color.fromARGB(255, 216, 216, 216),
            ),
          ),
          openBuilder: (context, action) => AddCommunityPostScreen(),
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
                    title: data['title'],
                    date: data['time'].toDate(),
                    city: data['location'],
                    content: data['content'],
                    image_url: data['img'],
                  );
                  final time = data['time'].toDate();
                  FeedWidgets.add(BlogCard(
                    receivedData: post,
                    time: time,
                  ));

                  FeedWidgets.sort((a, b) => a.time.compareTo(b.time));
                }
                return Expanded(
                  child: ListView(
                    children: FeedWidgets,
                    controller: scrollController,
                  ),
                );
              })
        ])));
  }
}
