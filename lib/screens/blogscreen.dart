import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:on_ways/Providers/Community_provider.dart';
import 'package:on_ways/screens/AddCommunityPost.dart';
import 'package:on_ways/screens/add_comment_screen.dart';
import 'package:provider/provider.dart';
import 'package:like_button/like_button.dart';
import 'package:animations/animations.dart';
import 'package:on_ways/Providers/User.dart';

class BlogScreen extends StatelessWidget {
  static const routeName = '/blogscreen';

  const BlogScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    final CommunityPost data = args.data;
    var isLiked = args.isLiked;
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Blog'),
        ),
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
          openBuilder: (context, action) => AddCommentScreen(FeedId: data.id),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: ConstrainedBox(
            constraints: const BoxConstraints.tightForFinite(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Post(data: data, isLiked: isLiked),
                Text(
                  'Comments',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: 28,
                      color: Color(0xFF1d2d59),
                      fontWeight: FontWeight.w800),
                ),
                Container(
                    padding: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(137, 141, 140, 140),
                        ),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromARGB(255, 242, 209, 213),
                              blurRadius: 7,
                              spreadRadius: 5),
                        ],
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15))),
                    child: Comments(postId: data.id)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Comments extends StatelessWidget {
  Comments({super.key, required this.postId});
  String postId;
  @override
  Widget build(BuildContext context) {
    final _firestore = FirebaseFirestore.instance;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('feed')
              .doc(postId)
              .collection('comments')
              .orderBy('time')
              .snapshots(includeMetadataChanges: true),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Container();
            }
            if (snapshot.data == null) {
              return Center(
                child: Container(),
              );
            }
            final postdata = snapshot.data?.docs;
            List<CommentWidget> FeedWidgets = [];
            for (var data in postdata!) {
              final time = data['time'].toDate();
              FeedWidgets.add(CommentWidget(
                commentContent: data['content'],
                commentName: data['author'],
                time: data['time'],
              ));
              FeedWidgets.sort((a, b) => b.time.compareTo(a.time));
            }
            return ListView(
              shrinkWrap: true,
              children: FeedWidgets,
            );
          }),
    );
  }
}

class CommentWidget extends StatelessWidget {
  CommentWidget(
      {super.key,
      required this.commentName,
      required this.commentContent,
      required this.time});
  var commentName;
  var commentContent;
  var time;
  //var upvotes=[];
  //var postId;
  //String CommentId;
  @override
  Widget build(BuildContext context) {
    // var istapped=upvotes.contains(context.watch<Users>().id);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            const Icon(
              Icons.person,
              size: 20,
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              '${commentName}',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(
          height: 6,
        ),
        Builder(builder: (context) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(28, 0, 12, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  commentContent,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: const Color.fromARGB(255, 217, 215, 215)),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(
                  height: 10,
                ),
                // Row(
                //   mainAxisSize: MainAxisSize.min,
                //   children: [
                //     const Spacer(),
                //     Text(upvotes.length.toString()),
                //     const SizedBox(
                //       width: 10,
                //     ),
                //     GestureDetector(
                //       onTap: () {
                //         if (istapped == false) {
                //         final _firestore = FirebaseFirestore.instance;
                //         _firestore.collection('feed').doc(postId).collection('comments').doc(CommentId).update({'Likes': FieldValue.arrayUnion([context.watch<Users>().id])});
                //         }
                //       },
                //       child: Icon(
                //         istapped
                //             ? Icons.thumb_up
                //             : Icons.thumb_up_alt_outlined,
                //         size: 15.0,
                //       ),
                //     ),
                //     const SizedBox(
                //       width: 8,
                //     )
                //   ],
                // ),
              ],
            ),
          );
        }),
        const Divider(
          thickness: 0.9,
          height: 30,
        ),
      ],
    );
  }
}

class Post extends StatelessWidget {
  Post({
    required this.data,
    required this.isLiked,
  });
  final CommunityPost data;
  bool isLiked;
  @override
  Widget build(BuildContext context) {
    DateTime parseDate = data.date;
    var inputDate = DateTime.parse(parseDate.toString());
    var outputDate = DateFormat('dd/MM/yyyy').format(inputDate);
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.only(top: 10, bottom: 0, left: 14, right: 14),
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 230, 232, 240),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            contentPadding: EdgeInsets.zero,
            leading: const Icon(
              Icons.account_circle,
              size: 30,
            ),
            title: Text(
              data.author,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1d2d59),
                  ),
            ),
            trailing: Text(outputDate,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.normal, fontSize: 14)),
          ),
          const Divider(
            thickness: 0.9,
          ),
          Text(data.title,
              style: Theme.of(context) // 1
                  .textTheme
                  .headlineMedium!
                  .copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                      color: const Color.fromARGB(179, 0, 0, 0))),
          Text(
            data.content,
            style:
                Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 15),
          ),
          if (data.image_url.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    data.image_url,
                    fit: BoxFit.fill,
                  )),
            ),
          Activity(data: data, isLiked: isLiked)
        ],
      ),
    );
  }
}

class Activity extends StatefulWidget {
  Activity({required this.isLiked, required this.data});
  final CommunityPost data;
  var isLiked;

  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  @override
  Widget build(BuildContext context) {
    Users user = Provider.of<Users>(context, listen: false);
    var db = FirebaseFirestore.instance;
    return Row(
      children: [
        Icon(Icons.location_history, color: const Color(0xFFd988a1)),
        Text(
          widget.data.city,
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontSize: 14,
                color: Color(0xFF1d2d59),
              ),
        ),
        const Spacer(),
        GestureDetector(
            child: Icon(
              widget.isLiked
                  ? CupertinoIcons.heart_circle
                  : CupertinoIcons.heart,
              color: widget.isLiked ? const Color(0xFFd988a1) : Colors.grey,
            ),
            onTap: () {
              try {
                if (widget.isLiked) {
                  setState(() {
                    widget.isLiked = false;
                  });
                  db.collection('feed').doc(widget.data.id).update({
                    'Likes': FieldValue.arrayRemove([user.id])
                  });
                } else {
                  setState(() {
                    widget.isLiked = true;
                  });
                  db.collection('feed').doc(widget.data.id).update({
                    'Likes': FieldValue.arrayUnion([user.id])
                  });
                }
              } catch (e) {
                print(e);
              }
            }),
      ],
    );
  }
}
