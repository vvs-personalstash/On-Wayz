import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart';
import 'package:provider/provider.dart';

class AddCommunityPostScreen extends StatefulWidget {
  const AddCommunityPostScreen({super.key});

  @override
  State<AddCommunityPostScreen> createState() => _AddCommunityPostScreenState();
}

class _AddCommunityPostScreenState extends State<AddCommunityPostScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _cityController = TextEditingController();
  final _urlController = TextEditingController();
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
            Padding(
              padding: EdgeInsets.all(8.0),
              child: AppBar(
                title: Text('Add Post'),
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
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            enabled: initialValue,
                            controller: _urlController,
                            decoration: const InputDecoration(
                              label: Text('Image url'),
                            ),
                            validator: (value) {
                              if (initialValue) {
                                if (value!.isEmpty) {
                                  return 'jab kuch bharna nhi tha tab switch on hi kyu kiye';
                                }
                                return null;
                              }
                              return null;
                            }, //this is wow
                          ),
                        ),
                        const SizedBox(width: 26),
                        Switch(
                          activeColor: const Color(0xFFd988a1),
                          value: initialValue,
                          onChanged: (value) {
                            setState(() {
                              initialValue = value;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      padding:
                          const EdgeInsets.only(left: 15, right: 15, bottom: 0),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(37, 42, 52, 1),
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
                            var db = FirebaseFirestore.instance;
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
