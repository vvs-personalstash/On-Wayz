import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:on_ways/Networking/image.dart';
import 'package:on_ways/Providers/User.dart';
import 'package:on_ways/utilities/userdetailtabscreen.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = '/editprofie';
  EditProfileScreen({super.key, required this.image});
  String image;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;
  late String NewImage;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NewImage = widget.image;
    print(1);
    print(NewImage);
  }

  @override
  Widget build(BuildContext context) {
    var dimensions = MediaQuery.of(context).size;
    double screenHeight = dimensions.height;
    Users users = Provider.of<Users>(context, listen: false);
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              leading: GestureDetector(
                onTap: () {
                  users.updateDetails();
                  Navigator.pop(context);
                },
                child: Container(
                  color: Colors.white,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: const Icon(CupertinoIcons.multiply,
                      color: Colors.grey, size: 30),
                ),
              ),
              centerTitle: true,
              title: Text(
                'Update Profile',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.w700, color: Colors.black),
              ),
            ),
            body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Row(children: [
                GestureDetector(
                    onTap: () async {
                      var NewImageUrl = await Navigator.of(context)
                          .pushNamed(ImageUploadScreen.routename) as String;
                      print(NewImageUrl);
                      if (NewImageUrl != Null) {
                        setState(() {
                          NewImage = NewImageUrl;
                          print(widget.image);
                        });
                        db
                            .collection("User-Data")
                            .doc(users.id)
                            .update({"Photo": NewImageUrl}).then(
                                (value) => print(
                                    "DocumentSnapshot successfully updated!"),
                                onError: (e) =>
                                    print("Error updating document $e"));
                      }
                    },
                    child: Container(
                      width: dimensions.width,
                      height: dimensions.height * 0.3,
                      child: Stack(
                        children: [
                          SizedBox(
                            height: screenHeight * 0.26,
                          ),
                          Container(
                            height: screenHeight * 0.2,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFF1d2d59),
                                    Colors.pink.shade200,
                                    Colors.white,
                                    //50559a
                                  ]),
                              borderRadius: BorderRadius.vertical(
                                  bottom: Radius.elliptical(
                                      MediaQuery.of(context).size.width,
                                      250.0)),
                            ),
                          ),
                          Positioned(
                            top: screenHeight * 0.11,
                            left: screenHeight * 0.168,
                            child: Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 3, color: Colors.white),
                                color: Color.fromARGB(255, 201, 200, 200),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black26,
                                      spreadRadius: 0,
                                      blurRadius: 8)
                                ],
                              ),
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(NewImage),
                                backgroundColor: Color(0xFFfafafa),
                                radius: 60,
                              ),
                            ),
                          ),
                          Positioned(
                            top: screenHeight * 0.11,
                            left: screenHeight * 0.168,
                            child: Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 3, color: Colors.white),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black26,
                                      spreadRadius: 0,
                                      blurRadius: 8)
                                ],
                              ),
                              child: CircleAvatar(
                                backgroundColor:
                                    Color.fromARGB(255, 110, 107, 107)
                                        .withOpacity(0.2),
                                radius: 60,
                              ),
                            ),
                          ),
                          Positioned(
                            child: CircleAvatar(
                              radius: 15,
                              child: Icon(
                                Icons.edit,
                                size: 19,
                                color: Colors.white,
                              ),
                              backgroundColor: Colors.grey,
                            ),
                            top: screenHeight * 0.11 + 90,
                            left: screenHeight * 0.168 + 100,
                          )
                          // Positioned(
                          //   top: screenHeight * 0.115,
                          //   left: screenHeight * 0.170,
                          //   child: Center(
                          //     child: CircleAvatar(
                          //       backgroundImage: NetworkImage(user.image),
                          //       radius: 55,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ))
              ]),
              SizedBox(height: 20),
              UserdetailTile(
                Icons.chevron_right_outlined,
                titleDescription: users.name,
                trailingIcon: Icons.create,
                title: 'Name',
                onPress: () async {
                  var result = await showTextInputDialog(
                      title: "Update User Name",
                      barrierDismissible: true,
                      // style: AdaptiveStyle
                      context: context,
                      textFields: [
                        DialogTextField(
                          hintText: "Name",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "This field is required";
                            }
                            return null;
                          },
                        ),
                      ]);
                  if (result == null) return;

                  await user.updateDisplayName(result[0]);
                  // Response response = await NetworkHelper().patchData(
                  //     url: 'student/update/${student.id}',
                  //     jsonMap: {"name": result[0]});
                  // if (response.statusCode == 200) {
                  //   dynamic data = jsonDecode(response.body);
                  //   student.update(data: data);
                  // }
                },
              ),
              const Divider(
                thickness: 0.5,
                indent: 20,
                endIndent: 20,
              ),
              UserdetailTile(
                Icons.chevron_right_outlined,
                titleDescription: users.UserName,
                trailingIcon: Icons.create,
                title: 'User Name',
                onPress: () async {
                  var result = await showTextInputDialog(
                      title: "Update User_Name",
                      barrierDismissible: true,
                      // style: AdaptiveStyle
                      context: context,
                      textFields: [
                        DialogTextField(
                          hintText: "User_Name",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "This field is required";
                            }
                            return null;
                          },
                        ),
                      ]);
                  if (result == null) return;
                  db
                      .collection("User-Data")
                      .doc(users.id)
                      .update({"UserName": result[0]}).then(
                          (value) =>
                              print("DocumentSnapshot successfully updated!"),
                          onError: (e) => print("Error updating document $e"));
                  // Response response = await NetworkHelper().patchData(
                  //     url: 'student/update/${student.id}',
                  //     jsonMap: {"city": result[0]});
                  // if (response.statusCode == 200) {
                  //   dynamic data = jsonDecode(response.body);
                  //   student.update(data: data);
                  // }
                },
              ),
              const Divider(
                thickness: 0.5,
                indent: 20,
                endIndent: 20,
              ),
              UserdetailTile(
                Icons.chevron_right_outlined,
                titleDescription: '${users.age}',
                trailingIcon: Icons.create,
                title: 'Age',
                onPress: () async {
                  var result = await showTextInputDialog(
                      title: "Update Age",
                      barrierDismissible: true,
                      // style: AdaptiveStyle
                      context: context,
                      textFields: [
                        DialogTextField(
                          hintText: "Age",
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "This field is required";
                            }
                            var age = double.tryParse(value);
                            if (age == null) {
                              return "Only numeric input allowed";
                            }
                            return null;
                          },
                        ),
                      ]);
                  if (result == null) return;

                  db
                      .collection("User-Data")
                      .doc(users.id)
                      .update({"age": result}).then(
                          (value) =>
                              print("DocumentSnapshot successfully updated!"),
                          onError: (e) => print("Error updating document $e"));
                  // Response response = await NetworkHelper().patchData(
                  //     url: 'student/update/${student.id}',
                  //     jsonMap: {"total_budget": result[0]});
                  // if (response.statusCode == 200) {
                  //   dynamic data = jsonDecode(response.body);
                  //   student.update(data: data);
                  // }
                },
              ),
              const Divider(
                thickness: 0.5,
                indent: 20,
                endIndent: 20,
              ),
            ])));
  }
}
