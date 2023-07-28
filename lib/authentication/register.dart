import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:on_ways/Networking/location.dart';
import 'package:on_ways/screens/scaffold_screen.dart';
import 'package:on_ways/utilities/custom_textfield.dart';
import 'package:on_ways/utilities/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class SignUpPage extends StatelessWidget {
  static const routename = '/signup';

  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  SignUpPage({super.key});
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    var dimensions = MediaQuery.of(context).size;
    String countrycode = '+91';
    debugPrint(user.email);
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: Container(
              height: dimensions.height,
              width: dimensions.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("Assets/background.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: dimensions.height * 0.3,
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
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, bottom: 5),
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
                  CustomButton(
                      dimensions: dimensions,
                      label: 'Sign Up',
                      action: () async {
                        var db = FirebaseFirestore.instance;
                        final userData = {
                          "UserName": usernameController.text,
                          "phonenumber": countrycode + phoneController.text,
                          "Last Location": GeoPoint(0, 0),
                        };
                        db.collection("User-Data").doc(user.uid).set(userData);
                        await user.updateDisplayName(usernameController.text);
                        await user.updatePhotoURL(
                            "https://example.com/jane-q-user/profile.jpg");
                        await user.updateDisplayName(nameController.text);
                        if (!context.mounted) return;
                        Navigator.pushNamedAndRemoveUntil(
                            context, HomeScreen.routename, (route) => false);
                      }),
                ],
              ),
            )));
  }
}
