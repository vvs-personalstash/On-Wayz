import 'package:cloud_firestore/cloud_firestore.dart';
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

  final _titleController = TextEditingController();
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
                title: Text(
                  'Add Post',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
            GestureDetector(
                onTap: () async {
                  var NewimageUrl = await Navigator.of(context)
                      .pushNamed(ImageUploadScreen.routename) as String;
                  if (NewimageUrl != Null) {
                    setState(() {
                      imageUrl = NewimageUrl;
                      print(imageUrl);
                    });
                  }
                },
                child: Container(
                  height: dimensions.height * 0.2,
                  width: dimensions.height * 0.7,
                  padding:
                      EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 10),
                  margin:
                      EdgeInsets.only(left: 10, right: 20, top: 20, bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.black.withOpacity(0.7),
                  ),
                  child: imageUrl != 'No Image'
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.fill,
                          ),
                        )
                      : Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.white,
                          size: 50,
                        ),
                )),
            const SizedBox(
              height: 25,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      maxLength: 50,
                      controller: _titleController,
                      decoration: const InputDecoration(
                        label: Text('Title'),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'This feild  is required';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      maxLength: 30,
                      controller: _cityController,
                      decoration: const InputDecoration(
                        label: Text('City'),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'This feild  is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      padding:
                          const EdgeInsets.only(left: 15, right: 15, bottom: 0),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 244, 245, 248),
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
                          hintText: 'Review',
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
                            Users user =
                                Provider.of<Users>(context, listen: false);
                            final _db = FirebaseFirestore.instance;
                            _db
                                .collection('feed')
                                .add({
                                  'author': user.name,
                                  'title': _titleController.text,
                                  'content': _contentController.text,
                                  'location': _cityController.text,
                                  'time': DateTime.now(),
                                  'img': imageUrl,
                                  'Likes': [],
                                })
                                .then((value) => print("Feed Added"))
                                .catchError((error) =>
                                    print("Failed to add Feed: $error"));
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
