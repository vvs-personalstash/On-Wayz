import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController Age = TextEditingController();
  String imageUrl = 'No Image';
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    var dimensions = MediaQuery.of(context).size;
    String countrycode = '+91';

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
                      Expanded(
                        child: GestureDetector(
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
                      ),
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
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 25),
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, bottom: 5),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(17),
                        ),
                        child: IntlPhoneField(
                          controller: phoneController,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            border: InputBorder.none,
                            fillColor: Colors.white,
                            filled: true,
                          ),
                          initialCountryCode: 'IN',
                          onCountryChanged: (value) {
                            countrycode = value.toString();
                          },
                        ),
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
                                onPressed: () {},
                                child: Container(
                                    height: 20,
                                    width: 100,
                                    child: Text(
                                      'Tap for Location',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
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
                            final userData = {
                              "UserName": usernameController.text,
                              "phonenumber": countrycode + phoneController.text,
                              "Last Location": GeoPoint(
                                  Location().latitudeoflocation!,
                                  Location().longitudeoflocation!),
                            };
                            db
                                .collection("User-Data")
                                .doc(user.uid)
                                .set(userData);
                            await user
                                .updateDisplayName(usernameController.text);
                            await user.updatePhotoURL(imageUrl != 'No Image'
                                ? imageUrl
                                : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRTHp7HDUzfrraXrobnp_eKUtNeFiq9E8NklA&usqp=CAU');
                            await user.updateDisplayName(nameController.text);
                            if (!context.mounted) return;
                            context.read<Users>().update();
                            Navigator.pushNamedAndRemoveUntil(context,
                                HomeScreen.routename, (route) => false);
                          }),
                    ],
                  ),
                ),
              ),
            ])));
  }
}
