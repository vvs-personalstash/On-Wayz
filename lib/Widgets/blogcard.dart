import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:on_ways/Providers/Community_provider.dart';
import 'package:flutter/material.dart';
import 'package:on_ways/Providers/User.dart';
import 'package:on_ways/screens/blogscreen.dart';
import 'package:provider/provider.dart';

class BlogCard extends StatefulWidget {
  const BlogCard({super.key, required this.receivedData, required this.time});

  final CommunityPost receivedData;
  final DateTime time;

  @override
  State<BlogCard> createState() => _BlogCardState();
}

class _BlogCardState extends State<BlogCard> {
  late CommunityPost communityPost;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isLiked =
        widget.receivedData.Likes.contains(context.watch<Users>().id);
    Users user = Provider.of<Users>(context, listen: false);
    var db = FirebaseFirestore.instance;
    return GestureDetector(
      onTap: () async {
        var result = await Navigator.pushNamed(context, BlogScreen.routeName,
            arguments:
                ScreenArguments(data: widget.receivedData, isLiked: isLiked));
        if (result != null) {
          setState(() {
            communityPost = (result as CommunityPost);
          });
        }
      },
      child: Card(
        elevation: 5,
        clipBehavior: Clip.hardEdge,
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        color: Theme.of(context).cardTheme.color,
        surfaceTintColor: Color.fromARGB(255, 255, 255, 255),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    visualDensity:
                        const VisualDensity(horizontal: -4, vertical: -4),
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(widget.receivedData.author_img),
                      radius: 15,
                    ),
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.receivedData.author,
                            style: Theme.of(context) //3
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1d2d59))),
                        Text(
                          DateTime.now().subtract(Duration(days: 1)) ==
                                  widget.receivedData.date.day
                              ? 'Yesterday at ${DateFormat('hh:mm a').format(widget.receivedData.date)}'
                              : '${DateFormat('yMMMEd').format(widget.receivedData.date)}',
                          style: TextStyle(
                              color: Colors.black45,
                              fontSize: 10.0,
                              fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                  // Text(widget.receivedData.title,
                  //     style: Theme.of(context) // 1
                  //         .textTheme
                  //         .headlineMedium!
                  //         .copyWith(
                  //             fontWeight: FontWeight.bold,
                  //             fontSize: 23,
                  //             color: Color(0xFF1d2d59))),
                  const SizedBox(height: 2),
                  Text(
                    widget.receivedData.content.length > 100
                        ? '${widget.receivedData.content.substring(0, 100)}...'
                        : widget.receivedData.content,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Color(0xFF1d2d59)), //2
                  ),
                ],
              ),
            ),
            if (widget.receivedData.image_url != Null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(alignment: Alignment.bottomLeft, children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        widget.receivedData.image_url,
                        fit: BoxFit.fill,
                      )),
                  Positioned(
                    left: 0,
                    bottom: 0,
                    child: Container(
                      margin: EdgeInsets.only(left: 2, bottom: 2),
                      padding: EdgeInsets.all(5),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.location_on_sharp,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            "${widget.receivedData.city}",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  )
                ]),
              ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(CupertinoIcons.heart_fill,
                            size: 20, color: const Color(0xFFd988a1)),
                        const SizedBox(
                          width: 10,
                        ),
                        Text('${widget.receivedData.Likes.length.toString()}'),
                      ],
                    ),
                  ),
                  const Divider(
                    thickness: 0.9,
                  ),
                  ListTile(
                    visualDensity:
                        const VisualDensity(horizontal: -4, vertical: -4),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    leading: GestureDetector(
                        child: Icon(
                          isLiked
                              ? CupertinoIcons.heart_fill
                              : CupertinoIcons.heart,
                          color:
                              isLiked ? const Color(0xFFd988a1) : Colors.grey,
                          size: 27,
                        ),
                        onTap: () {
                          try {
                            if (isLiked) {
                              // setState(() {
                              //   isLiked = false;
                              // });
                              db
                                  .collection('feed')
                                  .doc(widget.receivedData.id)
                                  .update({
                                'Likes': FieldValue.arrayRemove([user.id])
                              });
                            } else {
                              // setState(() {
                              //   isLiked = true;
                              // });
                              db
                                  .collection('feed')
                                  .doc(widget.receivedData.id)
                                  .update({
                                'Likes': FieldValue.arrayUnion([user.id])
                              });
                            }
                          } catch (e) {
                            print(e);
                          }
                        }),
                    trailing: Icon(
                      Icons.comment_outlined,
                      size: 27,
                    ),
                    // trailing: FittedBox(
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //     children: [
                    //       Icon(
                    //         isLiked
                    //             ? CupertinoIcons.heart_fill
                    //             : CupertinoIcons.heart,
                    //         size: 20,
                    //         color: widget.receivedData.Likes
                    //                 .contains(context.watch<Users>().id)
                    //             ? const Color(0xFFd988a1)
                    //             : Colors.grey,
                    //       ),
                    //       const SizedBox(
                    //         width: 10,
                    //       ),
                    //       Text(widget.receivedData.Likes.length.toString()),
                    //     ],
                    //   ),
                    // ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
