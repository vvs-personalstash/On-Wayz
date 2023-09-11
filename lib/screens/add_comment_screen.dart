import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:on_ways/Providers/User.dart';
import 'package:provider/provider.dart';
import 'package:on_ways/Widgets/custom_appbar.dart';

class AddCommentScreen extends StatefulWidget {
  AddCommentScreen({required this.FeedId});
  String FeedId;

  @override
  State<AddCommentScreen> createState() => _AddCommentScreenState();
}

class _AddCommentScreenState extends State<AddCommentScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _contentController = TextEditingController();
  bool initialValue = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: CustomAppbar(
                title: 'Add Comment',
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.only(left: 15, right: 15, bottom: 0),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 226, 151, 197),
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: TextFormField(
                        autofocus: false,
                        controller: _contentController,
                        maxLength: 400,
                        // style: Theme.of(context).textTheme.titleSmall,
                        minLines: 7,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          hintText: 'Write your comment...',
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'This feild  is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 77, 83, 163),
                        ),
                        onPressed: () async {
                          bool isValid = _formKey.currentState!.validate();
                          if (isValid) {
                            // Student student =
                            //     Provider.of<Student>(context, listen: false);
                            // Response response = await NetworkHelper().postData(
                            //     url: 'communityPost/create/',
                            //     jsonMap: {
                            //       "student": student.id,
                            //       "title": _titleController.text,
                            //       "content": _contentController.text,
                            //       "city": _cityController.text
                            //     });
                            Users user =
                                Provider.of<Users>(context, listen: false);
                            final _firestore = FirebaseFirestore.instance;
                            _firestore
                                .collection('feed')
                                .doc(widget.FeedId)
                                .collection('comments')
                                .add({
                                  'image': user.image,
                                  'author': user.name,
                                  'content': _contentController.text,
                                  'time': DateTime.now(),
                                })
                                .then((value) => print("Comment Added"))
                                .catchError((error) =>
                                    print("Failed to add Comment: $error"));
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Invalid Input'),
                                content: const Text(
                                    "Make sure to enter all the required fields"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Okay'),
                                  )
                                ],
                              ),
                            );
                            if (!context.mounted) return;
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Add'))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
