import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:on_ways/Networking/image.dart';
import 'package:on_ways/Networking/location.dart';
import 'package:on_ways/Providers/User.dart';
import 'package:on_ways/screens/scaffold_screen.dart';
import 'package:on_ways/utilities/custom_textfield.dart';
import 'package:on_ways/utilities/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  static const routename = '/signup';

  SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController usernameController = TextEditingController();

  final TextEditingController Age = TextEditingController();
  String imageUrl = 'No Image';
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    var dimensions = MediaQuery.of(context).size;

    var Latitude = 0;
    var Longitude = 0;
    debugPrint(user.email);
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: Stack(children: [
              Container(
                height: dimensions.height,
                width: dimensions.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("Assets/background.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  height: dimensions.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: () async {
                            var NewImageUrl = await Navigator.of(context)
                                    .pushNamed(ImageUploadScreen.routename)
                                as String;
                            print(NewImageUrl);
                            if (NewImageUrl != Null) {
                              setState(() {
                                imageUrl = NewImageUrl;
                                print(imageUrl);
                              });
                            }
                          },
                          child: Container(
                            height: dimensions.height * 0.3,
                            width: dimensions.width * 0.8,
                            margin: EdgeInsets.only(
                                left: 10, right: 20, top: 20, bottom: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.black.withOpacity(0.7),
                            ),
                            child: imageUrl == 'No Image'
                                ? Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.white,
                                    size: 50,
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: Image.network(
                                      imageUrl,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                          )),
                      CustomTextField(
                        label: 'Full Name',
                        iconData: Icons.person,
                        textEditingController: nameController,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        label: 'User Name',
                        iconData: Icons.person,
                        textEditingController: usernameController,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              textEditingController: Age,
                              label: 'Enter Age',
                              iconData: Icons.people_outline_sharp,
                              Keyboard: TextInputType.number,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            margin: EdgeInsets.only(left: 10, right: 20),
                            child: ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => Dialog(
                                              child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Your Location is:- ${context.watch<Location>().longitudeoflocation},${context.watch<Location>().latitudeoflocation}',
                                            ),
                                          )));
                                },
                                child: Container(
                                    height: 20,
                                    width: 100,
                                    child: Center(
                                      child: Text(
                                        'Tap for Location',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 10),
                                      ),
                                    ))),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomButton(
                          dimensions: dimensions,
                          label: 'Sign Up',
                          action: () async {
                            var db = FirebaseFirestore.instance;
                            final geo = GeoFlutterFire();
                            Location location =
                                Provider.of(context, listen: false);
                            GeoFirePoint myLocation = geo.point(
                                latitude: location.latitudeoflocation!,
                                longitude: location.longitudeoflocation!);
                            final userData = {
                              "UserName": usernameController.text,
                              "Last Location": myLocation.data,
                              "Photo": imageUrl,
                              "location": GeoPoint(location.latitudeoflocation!,
                                  location.longitudeoflocation!),
                              "age": Age.text,
                            };
                            db
                                .collection("User-Data")
                                .doc(user.uid)
                                .set(userData);
                            // await user.updatePhotoURL(imageUrl != 'No Image'
                            //     ? imageUrl
                            //     : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRTHp7HDUzfrraXrobnp_eKUtNeFiq9E8NklA&usqp=CAU');
                            await user.updateDisplayName(nameController.text);
                            if (!context.mounted) return;
                            Provider.of<Users>(context, listen: false)
                                .updateDetails();
                            Navigator.pushNamedAndRemoveUntil(context,
                                HomeScreen.routename, (route) => false);
                          }),
                      SizedBox(
                        height: 50,
                      )
                    ],
                  ),
                ),
              ),
            ])));
  }
}
