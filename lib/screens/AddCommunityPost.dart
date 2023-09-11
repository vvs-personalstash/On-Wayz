import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart';
import 'package:on_ways/Networking/image.dart';
import 'package:provider/provider.dart';
import 'package:on_ways/Providers/User.dart';

class AddCommunityPostScreen extends StatefulWidget {
  const AddCommunityPostScreen({super.key});
  @override
  State<AddCommunityPostScreen> createState() => _AddCommunityPostScreenState();
}

class _AddCommunityPostScreenState extends State<AddCommunityPostScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // final _titleController = TextEditingController();
  final _cityController = TextEditingController();
  final _contentController = TextEditingController();
  bool initialValue = false;
  String imageUrl = 'No Image';

  @override
  Widget build(BuildContext context) {
    var dimensions = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: AppBar(
                elevation: 0,
                leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: const Icon(CupertinoIcons.multiply,
                        color: Colors.grey, size: 30),
                  ),
                ),
                centerTitle: true,
                title: Text(
                  'Create Post',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w700, color: Colors.black),
                ),
                actions: [
                  GestureDetector(
                    onTap: () {
                      bool isValid = _formKey.currentState!.validate();

                      if (isValid) {
                        Users user = Provider.of<Users>(context, listen: false);
                        final _db = FirebaseFirestore.instance;
                        _db
                            .collection('feed')
                            .add({
                              'author': user.name,
                              'author_img': user.image,
                              //          'title': _titleController.text,
                              'content': _contentController.text,
                              'location': _cityController.text,
                              'time': DateTime.now(),
                              'img': imageUrl,
                              'Likes': [],
                            })
                            .then((value) => print("Feed Added"))
                            .catchError(
                                (error) => print("Failed to add Feed: $error"));
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Invalid Input'),
                            content: const Text(
                                "Make sure o enter all the required fields"),
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
                      }
                    },
                    child: Container(
                        padding: EdgeInsets.all(8),
                        margin:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        child: Text(
                          'Post',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromARGB(255, 228, 115, 151)),
                        )),
                  )
                ],
              ),
            ),
            imageUrl != 'No Image'
                ? Container(
                    height: dimensions.height * 0.2,
                    width: dimensions.height * 0.7,
                    padding: EdgeInsets.only(
                        left: 15, right: 15, top: 8, bottom: 10),
                    margin: EdgeInsets.only(
                        left: 10, right: 20, top: 20, bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.black.withOpacity(0.7),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.fill,
                      ),
                    ))
                : Container(),
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
                      margin: EdgeInsets.all(8),
                      padding:
                          const EdgeInsets.only(left: 15, right: 15, bottom: 0),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 204, 205, 209),
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
                          hintText: 'Whats on your mind',
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
                    Divider(
                      thickness: 1,
                      height: 5,
                      color: Color.fromARGB(104, 0, 0, 0),
                    ),
                    // TextFormField(
                    //   maxLength: 50,
                    //   controller: _titleController,
                    //   decoration: const InputDecoration(
                    //     label: Text('Title'),
                    //   ),
                    //   validator: (value) {
                    //     if (value!.isEmpty) {
                    //       return 'This feild  is required';
                    //     }
                    //     return null;
                    //   },
                    // ),
                    TextFormField(
                      maxLines: 1,
                      maxLength: 30,
                      controller: _cityController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(Icons.location_on,
                            size: 25, color: Colors.deepOrange),
                        label: Text('Add Location'),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'This feild  is required';
                        }
                        return null;
                      },
                    ),
                    Divider(
                      thickness: 1,
                      height: 5,
                      color: Color.fromARGB(104, 0, 0, 0),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            backgroundColor: Color.fromARGB(255, 255, 255, 255),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            side: BorderSide(
                                width: 1, // the thickness
                                color: Colors.grey.shade400)),
                        onPressed: () async {
                          var NewimageUrl = await Navigator.of(context)
                              .pushNamed(ImageUploadScreen.routename) as String;
                          if (NewimageUrl != Null) {
                            setState(() {
                              imageUrl = NewimageUrl;
                              print(imageUrl);
                            });
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(CupertinoIcons.photo_on_rectangle,
                                color: Color.fromARGB(255, 85, 102, 146),
                                size: 27),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Photo',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          Color.fromARGB(255, 102, 100, 100)),
                            ),
                          ],
                        ))
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
