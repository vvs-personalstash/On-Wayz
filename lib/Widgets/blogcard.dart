import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    final user = FirebaseAuth.instance;
    return GestureDetector(
      onTap: () async {
        var result = await Navigator.pushNamed(context, BlogScreen.routeName,
            arguments: widget.receivedData);
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
        surfaceTintColor: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.receivedData.image_url != Null)
              Container(
                  // padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                  ),
                  child: Image.network(widget.receivedData.image_url,
                      fit: BoxFit.fill)),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.receivedData.title,
                      style: Theme.of(context) // 1
                          .textTheme
                          .headlineMedium!
                          .copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 23,
                              color: Colors.white70)),
                  const SizedBox(height: 2),
                  Text(
                    widget.receivedData.content.length > 100
                        ? '${widget.receivedData.content.substring(0, 100)}...'
                        : widget.receivedData.content,
                    style: Theme.of(context).textTheme.bodyLarge, //2
                  ),
                  const Divider(
                    thickness: 0.9,
                  ),
                  ListTile(
                    visualDensity:
                        const VisualDensity(horizontal: -4, vertical: -4),
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.account_circle,
                      size: 35,
                    ),
                    title: Text(widget.receivedData.content,
                        style: Theme.of(context) //3
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.bold)),
                    trailing: FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.arrow_upward,
                            size: 20,
                            color: widget.receivedData.Likes
                                    .contains(context.watch<Users>().id)
                                ? const Color(0xFFd988a1)
                                : Colors.grey,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(widget.receivedData.Likes.length.toString()),
                        ],
                      ),
                    ),
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
