import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    final CommunityPost data =
        ModalRoute.of(context)!.settings.arguments as CommunityPost;
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
                Post(data: data),
                Comments(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Comments extends StatelessWidget {
  const Comments({
    super.key,
  });

  final List comments = const [
    {
      "student": "Ravi Maurya",
      "comment": "demo comment",
      "upvotes": 0,
      "date": "2023-06-25",
      "post": 2,
      "liked": false
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        shrinkWrap: true,
        primary: false,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: comments.length,
        itemBuilder: (context, index) {
          bool tap = false;
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
                    '${comments[index]['student']}',
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
                        '${comments[index]['comment']}',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: const Color.fromARGB(255, 217, 215, 215)),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Spacer(),
                          Text('${comments[index]['upvotes']}'),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (tap == false) {
                                // setState(() {
                                //   comments[index]['upvotes']++;
                                //   tap = true;
                                // });
                              }
                            },
                            child: Icon(
                              tap
                                  ? Icons.thumb_up
                                  : Icons.thumb_up_alt_outlined,
                              size: 15.0,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          )
                        ],
                      ),
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
        },
      ),
    );
  }
}

class Post extends StatelessWidget {
  const Post({
    required this.data,
  });
  final CommunityPost data;

  @override
  Widget build(BuildContext context) {
    DateTime parseDate = data.date;
    var inputDate = DateTime.parse(parseDate.toString());
    var outputDate = DateFormat('dd/MM/yyyy').format(inputDate);
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.only(top: 10, bottom: 0, left: 14, right: 14),
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 159, 174, 223),
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
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
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
                      color: Colors.white70)),
          if (data.image_url.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Image(
                image: NetworkImage(data.image_url),
                fit: BoxFit.cover,
              ),
            ),
          Text(
            data.content,
            style:
                Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 15),
          ),
          //       Activity(data: data)
        ],
      ),
    );
  }
}

// class Activity extends StatelessWidget {
//   const Activity({required this.data});
//   final CommunityPost data;
//   @override
//   Widget build(BuildContext context) {
//     var db = FirebaseFirestore.instance;
//     return Row(
//       children: [
//         const Spacer(),
//         LikeButton(
//             likeBuilder: (isLiked) => Icon(
//                   Icons.arrow_upward,
//                   color: isLiked ? const Color(0xFFd988a1) : Colors.grey,
//                 ),
//             likeCount: data.Likes.length,
//             isLiked: data.Likes.contains(context.watch<Users>().id),
//             onTap: (isLiked) {
//               try {
//                 db.collection('feed').doc(data.id).update({
//                   'Likes':
//                       FieldValue.arrayRemove(context.watch<Users>().id as List)
//                 });
//               } catch (e) {
//                 print(e);
//               }
//             }),
//       ],
//     );
//   }
// }
